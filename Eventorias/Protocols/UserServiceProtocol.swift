//
//  UserServiceProtocol.swift
//  Eventorias
//

import Foundation
import SwiftUI

protocol UserServiceProtocol {
    func fetchUser(withID uid: String, completion: @escaping (Result<User, Error>) -> Void)
    func updateUserInfo(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserNotificationPreference(user: User, enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserImage(user: User, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void)
}

