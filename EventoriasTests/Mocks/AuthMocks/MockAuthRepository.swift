//
//  MockAuthRepository.swift
//  EventoriasTests
//

import Foundation
@testable import Eventorias

struct MockUserForLogin: UserProtocol {
    let uid: String
    var email: String
    let password: String
    var name: String?
}

class MockAuthRepository: AuthManager {
    var shouldSucceed: Bool = true
    var usersDatabase: [String: MockUserForLogin] = [:]
    
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceed {
            let mockUID = UUID().uuidString
            let user = MockUserForLogin(uid: mockUID, email: email, password: password)
            usersDatabase[mockUID] = user
            completion(.success(mockUID))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock sign-up error"])))
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceed {
            if let user = usersDatabase.values.first(where: { $0.email == email }) {
                completion(.success(user.uid))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock login error"])))
        }
    }
    
    func saveUser(uid: String, email: String, name: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceed {
            if var user = usersDatabase[uid] {
                user.name = name
                user.email = email
                usersDatabase[uid] = user
                completion(.success(uid))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock save user data error"])))
        }
    }
}
