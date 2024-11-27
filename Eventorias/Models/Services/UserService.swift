//
//  UserService.swift
//  Eventorias
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


class UserService: UserProvider {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "NoUser", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged"])))
            return
        }
        
        db.collection("Users").document(user.uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                print("Erreur lors de la récupération du document utilisateur : \(error.localizedDescription)")
            } else if let document = document, document.exists {
                let data = document.data()!
                let user = User(uid: user.uid,
                                name: data["name"] as? String ?? "",
                                notification: data["notification"] as? Bool ?? false,
                                profilPicture: data["profilPicture"] as? String ?? "",
                                email: data["email"] as? String ?? "")
                print("Document utilisateur récupéré : \(user)")
                completion(.success(user))
            } else {
                print("Le document utilisateur n'existe pas.")
                completion(.failure(NSError(domain: "NoUser", code: 404, userInfo: [NSLocalizedDescriptionKey: "Le document utilisateur n'existe pas."])))
            }
        }
        
    }
    
    func updateUserInfo(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let userData: [String: Any] = [
            "uid": user.uid,
            "name": user.name,
            "email": user.email
        ]
        
        db.collection("Users").document(user.uid).setData(userData, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUserNotificationPreference(user: User, enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let notificationData: [String: Any] = [
            "notification": enabled
        ]
        
        db.collection("Users").document(user.uid).setData(notificationData, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUserImage(user: User, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image conversion to JPEG failed."])))
            return
        }
        
        let storageRef = Storage.storage().reference()
        let profileImageRef = storageRef.child("profileImages/\(user.uid).jpg")
        
        profileImageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                profileImageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        let imageData: [String: Any] = [
                            "profilePicture": url.absoluteString
                        ]
                        
                        Firestore.firestore().collection("Users").document(user.uid).setData(imageData, merge: true) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }
                    }
                }
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
