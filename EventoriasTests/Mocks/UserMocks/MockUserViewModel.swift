//
//  MockUserViewModel.swift
//  EventoriasTests
//

import Foundation
@testable import Eventorias

class MockUserViewModel: UserRepository {
    
    init() {
        super.init(userProvider: MockUserService())
    }
}


struct MockUser {
    static let example = User(
        uid: "123",
        name: "Mock User",
        notification: true,
        profilPicture: "https://mockurl.com/profile.jpg",
        email: "mockuser@example.com"
    )
}
