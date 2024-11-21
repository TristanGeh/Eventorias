//
//  EventService.swift
//  Eventorias
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class EventService: EventServiceProtocol {
    private let db = Firestore.firestore()
    
    func addEvent(event: EventRaw, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "NoUser", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged"])))
            return
        }
        let documentRef = db.collection("Events").document()
        let eventData: [String: Any] = [
            "id": documentRef.documentID,
            "title": event.title,
            "description": event.description,
            "date": event.date,
            "time": event.time,
            "createdBy": user.uid,
            "location": event.location,
            "imageUrl": event.imageUrl
        ]
        
        db.collection("Events").addDocument(data: eventData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
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
                    snapshot.documents.forEach { document in
                        print("Document ID: \(document.documentID)")
                        print("Document data: \(document.data())")
                    }

                    let events = snapshot.documents.compactMap { document -> EventRaw? in
                        let data = document.data()
                        let documentID = document.documentID

                        print("Document ID: \(documentID), Type: \(type(of: documentID))")

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
}
