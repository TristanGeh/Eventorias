//
//  AuthService.swift
//  Eventorias
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService: AuthServiceProtocol {
    static let shared = AuthService()

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
