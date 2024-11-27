//
//  MockUserRepository.swift
//  EventoriasTests
//

import Foundation
import SwiftUI
@testable import Eventorias

class MockUserRepository: UserManager {
    var shouldFail: Bool = false
    var user: User?
    
    init(user: User? = nil) {
        self.user = user
    }
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockUserRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user"])))
        } else if let user = user {
            completion(.success(user))
        } else {
            completion(.failure(NSError(domain: "MockUserRepository", code: 2, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
        }
    }
    
    func updateUserInfo(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockUserRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update user info"])))
        } else {
            self.user = user
            completion(.success(()))
        }
    }
    
    func updateUserNotificationPreference(user: User, enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockUserRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update user notification preference"])))
        } else if let existingUser = self.user, existingUser.uid == user.uid {
            var updatedUser = existingUser
            updatedUser.notification = enabled
            self.user = updatedUser
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "MockUserRepository", code: 2, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
        }
    }
    
    func updateUserImage(user: User, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockUserRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update user image"])))
        } else if let existingUser = self.user, existingUser.uid == user.uid {
            var updatedUser = existingUser
            updatedUser.profilPicture = "https://mockurl.com/profilepicture.jpg"
            self.user = updatedUser
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "MockUserRepository", code: 2, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
        }
    }
    
    func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void) {
        if shouldFail {
            completion("Failed to convert URL")
        } else {
            completion("https://mockurl.com/converted/\(gsUrl)")
        }
    }
}
