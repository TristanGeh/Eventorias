//
//  AuthRepository.swift
//  Eventorias
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthRepository: AuthManager {
    
    private let authProvider: FirebaseAuthProvider
    
    init(authProvider: FirebaseAuthProvider) {
        self.authProvider = authProvider
    }
    
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<String, any Error>) -> Void) {
        authProvider.createUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let authResult):
                    let uid = authResult.user.uid
                    self?.saveUser(uid: uid, email: email, name: name, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func saveUser(uid: String, email: String, name: String, completion: @escaping (Result<String, any Error>) -> Void) {
        let userData: [String : Any] = [
            "uid": uid,
            "name": name,
            "email": email,
            "createdAt": FieldValue.serverTimestamp()
        ]
        authProvider.saveUserData(uid: uid, userData: userData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(uid))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, any Error>) -> Void) {
        authProvider.signIn(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let authResult):
                    let uid = authResult.user.uid
                    completion(.success(uid))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
