//
//  AuthProtocol.swift
//  Eventorias
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthProvider {
    func createUser(email: String, password: String, completion: @escaping (Result<AuthDataResultProtocol, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResultProtocol, Error>) -> Void)
    func saveUserData(uid: String, userData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
}

protocol AuthManager {
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<String, Error>) -> Void)
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func saveUser(uid: String, email: String, name: String, completion: @escaping (Result<String, Error>) -> Void)
}

protocol AuthDataResultProtocol {
    var user: UserProtocol { get }
}

protocol UserProtocol {
    var uid: String { get }
    var email: String { get }
}
