//
//  AuthServiceMock.swift
//  Eventorias
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class MockAuthService: AuthServiceProtocol {
    var shouldSucceed: Bool = true
    
    var usersDatabase: [String: [String: Any]] = [:]
    
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceed {
            let mockUID = UUID().uuidString
            
            let userData: [String: Any] = [
                "uid": mockUID,
                "name": name,
                "email": email,
                "createdAt": Date()
            ]
            usersDatabase[mockUID] = userData
            
            completion(.success(mockUID))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock sign-up error"])))
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceed {
            if let (uid, _) = usersDatabase.first(where: { $0.value["email"] as? String == email }) {
                completion(.success(uid))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock login error"])))
        }
    }
}

