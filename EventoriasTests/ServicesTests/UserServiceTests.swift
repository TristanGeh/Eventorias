//
//  UserServiceTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class UserServiceTests: XCTestCase {
    
    var userService: UserService!
    var mockUserService: MockUserService!
    
    override func setUp() {
        super.setUp()
        userService = UserService()
        mockUserService = MockUserService()
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        mockUserService.user = user
    }
    
    override func tearDown() {
        userService = nil
        mockUserService = nil
        super.tearDown()
    }
    
    // MARK: - Tests for fetchUser
    
    func testFetchUserSuccess() {
        // Given
        mockUserService.shouldFail = false
        let expectedUser = User(uid: "123", name: "Test User", notification: true, profilPicture: "https://mockurl.com/profile.jpg", email: "test@example.com")
        mockUserService.user = expectedUser
        
        let expectation = self.expectation(description: "fetchUserSuccess")
        
        // When
        mockUserService.fetchUser { result in
            // Then
            switch result {
            case .success(let user):
                XCTAssertEqual(user.uid, expectedUser.uid, "Expected user ID to match")
                XCTAssertEqual(user.name, expectedUser.name, "Expected user name to match")
                XCTAssertEqual(user.email, expectedUser.email, "Expected user email to match")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchUserFailure() {
        // Given
        mockUserService.shouldFail = true
        
        let expectation = self.expectation(description: "fetchUserFailure")
        
        // When
        mockUserService.fetchUser { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to fetch user", "Expected failure message for fetching user")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: - Tests for updateUserInfo
    
    func testUpdateUserInfoSuccess() {
        // Given
        mockUserService.shouldFail = false
        let user = User(uid: "123", name: "Updated User", notification: false, profilPicture: "", email: "updated@example.com")
        
        // When
        mockUserService.updateUserInfo(user: user) { result in
            // Then
            switch result {
            case .success:
                XCTAssertEqual(self.mockUserService.user?.name, "Updated User", "Expected user name to be updated")
                XCTAssertEqual(self.mockUserService.user?.email, "updated@example.com", "Expected user email to be updated")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
    }
    
    func testUpdateUserInfoFailure() {
        // Given
        mockUserService.shouldFail = true
        let user = User(uid: "123", name: "Updated User", notification: false, profilPicture: "", email: "updated@example.com")
        
        // When
        mockUserService.updateUserInfo(user: user) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to update user info", "Expected failure message for updating user info")
            }
        }
    }
    
    // MARK: - Tests for updateUserNotificationPreference
    
    func testUpdateUserNotificationPreferenceSuccess() {
        // Given
        mockUserService.shouldFail = false
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        mockUserService.user = user // Assignez l'utilisateur au mock pour assurer la mise à jour
        
        // When
        mockUserService.updateUserNotificationPreference(user: user, enabled: true) { result in
            // Then
            switch result {
            case .success:
                XCTAssertTrue(self.mockUserService.user?.notification ?? false, "Expected notification preference to be updated to true")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
    }
    
    func testUpdateUserNotificationPreferenceFailure() {
        // Given
        mockUserService.shouldFail = true
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        
        // When
        mockUserService.updateUserNotificationPreference(user: user, enabled: true) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to update user notification preference", "Expected failure message for updating user notification preference")
            }
        }
    }
    
    // MARK: - Tests for updateUserImage
    
    func testUpdateUserImageSuccess() {
        // Given
        mockUserService.shouldFail = false
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        mockUserService.user = user // Assurez-vous que l'utilisateur est présent dans le mock avant la mise à jour
        let image = UIImage()
        
        // When
        mockUserService.updateUserImage(user: user, image: image) { result in
            // Then
            switch result {
            case .success:
                XCTAssertEqual(self.mockUserService.user?.profilPicture, "https://mockurl.com/profilepicture.jpg", "Expected profile picture URL to be updated")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
    }
    
    // MARK: - Tests for convertFirebaseURL
    
    func testConvertFirebaseURLSuccess() {
        // Given
        mockUserService.shouldFail = false
        let gsUrl = "gs://somebucket/somepath"
        
        // When
        mockUserService.convertFirebaseURL(gsUrl) { convertedUrl in
            // Then
            XCTAssertEqual(convertedUrl, "https://mockurl.com/convertedurl.jpg", "Expected Firebase URL to be converted successfully")
        }
    }
    
    func testConvertFirebaseURLFailure() {
        // Given
        mockUserService.shouldFail = true
        let gsUrl = "gs://somebucket/somepath"
        
        // When
        mockUserService.convertFirebaseURL(gsUrl) { convertedUrl in
            // Then
            XCTAssertEqual(convertedUrl, "", "Expected failure to convert Firebase URL")
        }
    }
}

