//
//  UserServiceMock.swift
//  Eventorias
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class MockUserService: UserServiceProtocol {
    var shouldSucceed: Bool = true
    var usersDatabase: [String: User] = [:]

    init() {
        let mockUser = User(uid: "mock_uid", name: "Mock User", notification: false, profilPicture: "test", email: "mock@user.com")
        usersDatabase[mockUser.uid] = mockUser
    }

    func fetchUser(withID uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        if shouldSucceed {
            if let user = usersDatabase[uid] {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user"])))
        }
    }

    func updateUserInfo(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            usersDatabase[user.uid] = user
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update user info"])))
        }
    }

    func updateUserNotificationPreference(user: User, enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            if var existingUser = usersDatabase[user.uid] {
                existingUser.notification = enabled
                usersDatabase[user.uid] = existingUser
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update user notification preference"])))
        }
    }

    func updateUserImage(user: User, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            if var existingUser = usersDatabase[user.uid] {
                existingUser.profilPicture = "updated_mock_image_url"
                usersDatabase[user.uid] = existingUser
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update user image"])))
        }
    }
}

