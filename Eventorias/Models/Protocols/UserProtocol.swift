//
//  UserServiceProtocol.swift
//  Eventorias
//

import Foundation
import SwiftUI

protocol UserProvider {
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void)
    func updateUserInfo(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserNotificationPreference(user: User, enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserImage(user: User, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void)
    func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void)

}

protocol UserManager {
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void)
    func updateUserInfo(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserNotificationPreference(user: User, enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserImage(user: User, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void)
    func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void)
}
