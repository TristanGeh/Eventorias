//
//  AuthService.swift
//  Eventorias
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultReal: AuthDataResultProtocol {
    
    let user: UserProtocol

    init(authDataResult: AuthDataResult) {
        self.user = UserReal(user: authDataResult.user)
    }
}

struct UserReal: UserProtocol {
    let uid: String
    let email: String

    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email ?? ""
    }
}

class AuthService: FirebaseAuthProvider {
    
    func createUser(email: String, password: String, completion: @escaping (Result<AuthDataResultProtocol, any Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                print("Failed to sign up: \(error.localizedDescription)")
            } else if let authResult = authResult {
                
                let result = AuthDataResultReal(authDataResult: authResult)
                completion(.success(result))
            }
        }
    }

    func saveUserData(uid: String, userData: [String : Any], completion: @escaping (Result<Void, Error>) -> Void) {
        Firestore.firestore().collection("Users").document(uid).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
                print("Failed to create Firestore user: \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
            
        }
    }

       
    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResultProtocol, Error>) -> Void) {
           Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
               if let error = error {
                   completion(.failure(error))
                   print(error)
               } else if let authResult = authResult {
                   
                   let result = AuthDataResultReal(authDataResult: authResult)
                   completion(.success(result))
               }
           }
       }
}
