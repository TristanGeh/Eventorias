//
//  UserRepository.swift
//  Eventorias
//

import Foundation
import SwiftUI

class UserRepository: UserManager {
    private let userProvider: UserProvider
    
    init(userProvider: UserProvider = UserService()) {
        self.userProvider = userProvider
    }
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        userProvider.fetchUser() { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func updateUserInfo(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        userProvider.updateUserInfo(user: user) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func updateUserNotificationPreference(user: User, enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        userProvider.updateUserNotificationPreference(user: user, enabled: enabled) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func updateUserImage(user: User, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        userProvider.updateUserImage(user: user, image: image) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void) {
        userProvider.convertFirebaseURL(gsUrl) { url in
            DispatchQueue.main.async {
                completion(url)
            }
        }
    }
}
