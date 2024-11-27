//
//  UserServiceMock.swift
//  Eventorias
//

import Foundation
import SwiftUI
@testable import Eventorias

class MockUserService: UserProvider {
    
    var user: User?
    var shouldFail: Bool = false
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user"])))
        } else if let user = user {
            completion(.success(user))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
        }
    }
    
    func updateUserInfo(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update user info"])))
        } else {
            self.user = user
            completion(.success(()))
        }
    }
    
    func updateUserNotificationPreference(user: User, enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update user notification preference"])))
        } else {
            if var existingUser = self.user, existingUser.uid == user.uid {
                existingUser.notification = enabled
                self.user = existingUser
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 2, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }
    }

    
    func updateUserImage(user: User, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update user image"])))
        } else {
            if var existingUser = self.user, existingUser.uid == user.uid {
                existingUser.profilPicture = "https://mockurl.com/profilepicture.jpg"
                self.user = existingUser
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }
    }
    
    func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void) {
        if shouldFail {
            completion("")
        } else {
            completion("https://mockurl.com/convertedurl.jpg")
        }
    }
}

