//
//  UserModel.swift
//  Eventorias
//

import Foundation

struct User: Identifiable {
    var id: String { uid }
    var uid: String
    var name: String
    var notification: Bool
    var profilPicture: String
    var email: String
}
