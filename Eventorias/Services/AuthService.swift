//
//  AuthService.swift
//  Eventorias
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService: AuthServiceProtocol {
    static let shared = AuthService()
    
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                print("Failed to sign up: \(error.localizedDescription)")
            } else if let authResult = authResult {
                let uid = authResult.user.uid
            
                let userData: [String: Any] = [
                    "uid": uid,
                    "name": name,
                    "email": email,
                    "createdAt": FieldValue.serverTimestamp()
                ]
                
                Firestore.firestore().collection("Users").document(uid).setData(userData) { error in
                    if let error = error {
                        completion(.failure(error))
                        print("Failed to create Firestore user: \(error.localizedDescription)")
                    } else {
                        completion(.success(uid))
                        print("Account successfully created, UID: \(uid)")
                    }
                }
            }
        }
    }

       
       func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
           Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
               if let error = error {
                   completion(.failure(error))
                   print(error)
               } else if let authResult = authResult {
                   let uid = authResult.user.uid
                   completion(.success(uid))
                   print("Account successfully logged in, UID: \(uid)")
               }
           }
       }
}
