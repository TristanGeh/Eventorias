//
//  UserViewModelTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class UserViewModelTests: XCTestCase {
    
    var userViewModel: UserViewModel!
    var mockUserService: MockUserService!
    var userRepository: MockUserRepository!
    
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        userRepository = MockUserRepository()
        userViewModel = UserViewModel(userRepository: userRepository)
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        mockUserService.user = user
        userViewModel.user = user
    }
    
    override func tearDown() {
        userViewModel = nil
        mockUserService = nil
        userRepository = nil
        super.tearDown()
    }
    
    // MARK: - Tests for fetchUser
    
    func testFetchUserSuccess() {
        // Given
        userRepository.shouldFail = false
        let expectedUser = User(uid: "123", name: "Test User", notification: true, profilPicture: "https://mockurl.com/profile.jpg", email: "test@example.com")
        userRepository.user = expectedUser
        
        // When
        userViewModel.fetchUser()
        
        // Then
        XCTAssertEqual(self.userViewModel.user?.uid, expectedUser.uid, "Expected user ID to match")
        XCTAssertEqual(self.userViewModel.user?.name, expectedUser.name, "Expected user name to match")
        XCTAssertEqual(self.userViewModel.user?.email, expectedUser.email, "Expected user email to match")
    }

    func testFetchUserFailure() {
        // Given
        userRepository.shouldFail = true
        
        // When
        userViewModel.fetchUser()
        
        // Then
        XCTAssertEqual(self.userViewModel.errorMsg, "Failed to update user info", "Expected failure message for fetching user")
    }

    
    // MARK: - Tests for updateUserInfo
    
    func testUpdateUserInfoSuccess() {
        // Given
        userRepository.shouldFail = false
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        userViewModel.user = user
        print("\(user)")
        userViewModel.nameToEdit = "Updated Name"
        userViewModel.emailToEdit = "updated@example.com"
        
        // When
        userViewModel.updateUserInfo()
        print("\(user)")
        
        // Then
        XCTAssertEqual(userViewModel.user?.name, "Updated Name", "Expected user name to be updated")
        XCTAssertEqual(userViewModel.user?.email, "updated@example.com", "Expected user email to be updated")
    }
    
    func testUpdateUserInfoFailure() {
        // Given
        userRepository.shouldFail = true
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        userViewModel.user = user
        print("\(user)")
        userViewModel.nameToEdit = "Updated Name"
        userViewModel.emailToEdit = "updated@example.com"
        
        // When
        userViewModel.updateUserInfo()
        print("\(user)")
        
        // Then
        XCTAssertEqual(userViewModel.errorMsg, "Failed to update user info", "Expected failure message when updating user info fails")
    }
    
    // MARK: - Tests for updateUserNotificationPreference
    
    func testUpdateUserNotificationPreferenceSuccess() {
        // Given
        userRepository.shouldFail = false
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "https://mockurl.com/profilepicture.jpg", email: "test@example.com")
        
        userRepository.user = user
        
        userViewModel.user = user
        userViewModel.notificationEnabled = true
        
        // When
        userViewModel.updateUserNotificationPreference()
        
        // Then
        XCTAssertTrue(userRepository.user?.notification ?? false, "Expected notification preference to be updated to true")
    }

    
    func testUpdateUserNotificationPreferenceFailure() {
        // Given
        userRepository.shouldFail = true
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "https://mockurl.com/profilepicture.jpg", email: "test@example.com")
        userViewModel.user = user
        print("\(user)")
        userViewModel.notificationEnabled = true
        
        // When
        userViewModel.updateUserNotificationPreference()
        print("\(user)")
        
        // Then
        XCTAssertEqual(userViewModel.errorMsg, "Failed to update user notification preference", "Expected failure message when updating notification preference fails")
    }
    
    // MARK: - Tests for updateUserImage
    
    func testUpdateUserImageSuccess() {
        // Given
        userRepository.shouldFail = false
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        userRepository.user = user
        
        userViewModel.user = user
        
        // Charger l'image de test depuis les assets du projet
        guard let testImage = UIImage(named: "testImage") else {
            XCTFail("Expected testImage to be found in assets")
            return
        }
        
        userViewModel.selectedImage = testImage
        
        // When
        userViewModel.updateUserImage()
        
        // Then
        XCTAssertEqual(userRepository.user?.profilPicture, "https://mockurl.com/profilepicture.jpg", "Expected profile picture URL to be updated")
    }

    
    func testUpdateUserImageFailure() {
        // Given
        userRepository.shouldFail = true
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        userViewModel.user = user
        userViewModel.selectedImage = UIImage()
        
        // When
        userViewModel.updateUserImage()
        
        // Then
        XCTAssertEqual(userViewModel.errorMsg, "Failed to update user image", "Expected failure message when updating user image fails")
    }
}
