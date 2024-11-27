//
//  EventService.swift
//  Eventorias
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class EventService: EventProvider {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func addEvent(title: String, description: String, date: Date, time: Date, address: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "NoUser", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged"])))
            return
        }
        
        uploadImage(image: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageUrl):
                _ = self.db.collection("Events").document()
                let eventData: [String: Any] = [
                    "id": user.uid,
                    "title": title,
                    "description": description,
                    "date": date,
                    "time": time,
                    "createdBy": user.uid,
                    "location": address,
                    "imageUrl": imageUrl
                ]
                
                self.db.collection("Events").addDocument(data: eventData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "NoUser", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged"])))
            return
        }
        
        let storageRef = storage.reference().child("eventImages/\(user.uid).jpg")
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                storageRef.downloadURL { url, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(error))
                        } else if let url = url {
                            completion(.success(url.absoluteString))
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image conversion to JPEG failed."])))
            }
        }
    }
    
    func fetchEvents(completion: @escaping (Result<[EventRaw], Error>) -> Void) {
        db.collection("Events").getDocuments { snapshot, error in
            if let error = error {
                print("Erreur lors de la récupération des événements depuis Firebase: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let snapshot = snapshot {
                print("Nombre de documents dans le snapshot: \(snapshot.documents.count)")
                if snapshot.documents.isEmpty {
                } else {
                    
                    let events = snapshot.documents.compactMap { document -> EventRaw? in
                        let data = document.data()
                        let documentID = document.documentID
                        
                        return EventRaw(
                            id: documentID,
                            title: data["title"] as? String ?? "",
                            description: data["description"] as? String ?? "",
                            date: data["date"] as? String ?? "",
                            time: data["time"] as? String ?? "",
                            createdBy: data["createdBy"] as? String ?? "",
                            location: data["location"] as? String ?? "",
                            imageUrl: data["imageUrl"] as? String ?? ""
                        )
                    }
                    
                    print("Nombre d'événements récupérés après mappage: \(events.count)")
                    completion(.success(events))
                }
            } else {
                print("Le snapshot est vide.")
                completion(.success([]))
            }
        }
        
    }
    
    
    func fetchUserProfilPicture(forUID uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection("Users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data()!
                let profilPicture = data["profilPicture"] as? String ?? "Unknown"
                completion(.success(profilPicture))
            }
        }
    }
    
    func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void) {
            let storageRef = Storage.storage().reference(forURL: gsUrl)
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Erreur lors de la récupération de l'URL: \(error.localizedDescription)")
                    completion("")
                } else if let url = url {
                    completion(url.absoluteString)
                }
            }
        }
}
