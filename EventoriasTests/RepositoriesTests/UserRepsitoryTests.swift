//
//  UserRepsitoryTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class UserRepositoryTests: XCTestCase {
    
    var userRepository: UserRepository!
    var mockUserService: MockUserService!
    
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        userRepository = UserRepository(userProvider: mockUserService)
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        mockUserService.user = user
    }
    
    override func tearDown() {
        userRepository = nil
        mockUserService = nil
        super.tearDown()
    }
    
    // MARK: - Tests for fetchUser
    
    func testFetchUserSuccess() {
        // Given
        mockUserService.shouldFail = false
        let expectedUser = User(uid: "123", name: "Test User", notification: true, profilPicture: "https://mockurl.com/profile.jpg", email: "test@example.com")
        mockUserService.user = expectedUser
        
        // When
        userRepository.fetchUser { result in
            // Then
            switch result {
            case .success(let user):
                XCTAssertEqual(user.uid, expectedUser.uid, "Expected user ID to match")
                XCTAssertEqual(user.name, expectedUser.name, "Expected user name to match")
                XCTAssertEqual(user.email, expectedUser.email, "Expected user email to match")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
    }
    
    func testFetchUserFailure() {
        // Given
        mockUserService.shouldFail = true
        
        // When
        userRepository.fetchUser { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to fetch user", "Expected failure message for fetching user")
            }
        }
    }
    
    // MARK: - Tests for updateUserInfo
    
    func testUpdateUserInfoSuccess() {
        // Given
        mockUserService.shouldFail = false
        let user = User(uid: "123", name: "Updated User", notification: false, profilPicture: "", email: "updated@example.com")
        
        // When
        userRepository.updateUserInfo(user: user) { result in
            // Then
            switch result {
            case .success:
                XCTAssertEqual(user.name, "Updated User", "Expected user name to be updated")
                XCTAssertEqual(user.email, "updated@example.com", "Expected user email to be updated")
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
        userRepository.updateUserInfo(user: user) { result in
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
        
        let expectation = self.expectation(description: "Update notification preference should succeed")
        
        // When
        userRepository.updateUserNotificationPreference(user: user, enabled: true) { result in
            // Then
            switch result {
            case .success:
                XCTAssertTrue(self.mockUserService.user?.notification ?? false, "Expected notification preference to be updated to true")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testUpdateUserNotificationPreferenceFailure() {
        // Given
        mockUserService.shouldFail = true
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        
        let expectation = self.expectation(description: "Update notification preference should fail")
        
        // When
        userRepository.updateUserNotificationPreference(user: user, enabled: true) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to update user notification preference", "Expected failure message for updating user notification preference")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: - Tests for updateUserImage
    
    func testUpdateUserImageSuccess() {
        // Given
        mockUserService.shouldFail = false
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        
        // Charger l'image de test depuis les assets du projet
        guard let testImage = UIImage(named: "testImage") else {
            XCTFail("Expected testImage to be found in assets")
            return
        }
        
        let expectation = self.expectation(description: "Update user image should succeed")
        
        // When
        userRepository.updateUserImage(user: user, image: testImage) { result in
            // Then
            switch result {
            case .success:
                XCTAssertEqual(self.mockUserService.user?.profilPicture, "https://mockurl.com/profilepicture.jpg", "Expected profile picture URL to be updated")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testUpdateUserImageFailure() {
        // Given
        mockUserService.shouldFail = true
        let user = User(uid: "123", name: "Test User", notification: false, profilPicture: "", email: "test@example.com")
        
        // Charger l'image de test depuis les assets du projet
        guard let testImage = UIImage(named: "testImage") else {
            XCTFail("Expected testImage to be found in assets")
            return
        }
        
        let expectation = self.expectation(description: "Update user image should fail")
        
        // When
        userRepository.updateUserImage(user: user, image: testImage) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to update user image", "Expected failure message for updating user image")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: - Tests for convertFirebaseURL
    
    func testConvertFirebaseURLSuccess() {
        // Given
        mockUserService.shouldFail = false
        let gsUrl = "gs://mockbucket/path/to/resource"
        
        // When
        userRepository.convertFirebaseURL(gsUrl) { convertedUrl in
            // Then
            XCTAssertEqual(convertedUrl, "https://mockurl.com/convertedurl.jpg", "Expected URL to be converted successfully")
        }
    }
    
    func testConvertFirebaseURLFailure() {
        // Given
        mockUserService.shouldFail = true
        let gsUrl = "gs://mockbucket/path/to/resource"
        
        // When
        userRepository.convertFirebaseURL(gsUrl) { convertedUrl in
            // Then
            XCTAssertEqual(convertedUrl, "", "Expected empty URL on failure")
        }
    }
}
