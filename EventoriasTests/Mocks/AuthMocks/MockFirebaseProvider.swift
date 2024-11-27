//
//  MockFirebaseProvider.swift
//  EventoriasTests
//

import Foundation
import FirebaseAuth
@testable import Eventorias

struct UserMock: UserProtocol {
    let uid: String
    let email: String
}

struct AuthDataResultMock: AuthDataResultProtocol {

    
    let user: UserProtocol
    
    init(user: UserMock) {
        self.user = user
    }
}

class MockFirebaseAuthProvider: FirebaseAuthProvider {
    
    var shouldSucceed: Bool = true
    var usersDatabase: [String: [String: Any]] = [:]
    
    func createUser(email: String, password: String, completion: @escaping (Result<AuthDataResultProtocol, Error>) -> Void) {
        if shouldSucceed {
            let mockUID = UUID().uuidString
            let userData: [String: Any] = [
                "uid": mockUID,
                "email": email
            ]
            usersDatabase[mockUID] = userData
            let user = UserMock(uid: mockUID, email: email)
            let authDataResult = AuthDataResultMock(user: user)
            completion(.success(authDataResult))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock sign-up error"])))
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResultProtocol, Error>) -> Void) {
        if shouldSucceed {
            if let userData = usersDatabase.values.first(where: { $0["email"] as? String == email }) {
                let uid = userData["uid"] as! String
                let user = UserMock(uid: uid, email: email)
                let authDataResult = AuthDataResultMock(user: user)
                completion(.success(authDataResult))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock login error"])))
        }
    }
    
    func saveUserData(uid: String, userData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            usersDatabase[uid] = userData
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock save user data error"])))
        }
    }
}


