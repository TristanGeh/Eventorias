//
//  UserViewModelTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class UserViewModelTests: XCTestCase {
    var userViewModel: UserViewModel!
    var mockUserService: MockUserService!
    
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        mockUserService.usersDatabase["mock_uid"] = User(uid: "mock_uid", name: "Mock User" , notification: false, profilPicture: "gs://eventorias.appspot.com", email: "mock@user.com")
        userViewModel = UserViewModel(userService: mockUserService)
    }
    
    override func tearDown() {
        userViewModel = nil
        mockUserService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchUserSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Fetch user success")
        
        userViewModel.fetchUser()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.userViewModel.user)
            XCTAssertEqual(self.userViewModel.user?.name, "Mock User")
            XCTAssertEqual(self.userViewModel.nameToEdit, "Mock User")
            XCTAssertEqual(self.userViewModel.emailToEdit, "mock@user.com")
            XCTAssertEqual(self.userViewModel.notificationEnabled, false)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchUserFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Fetch user failure")
        
        userViewModel.fetchUser()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNil(self.userViewModel.user)
            XCTAssertNotNil(self.userViewModel.errorMsg)
            XCTAssertEqual(self.userViewModel.errorMsg, "Failed to update user info")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateUserInfoSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Update user info success")
        
        userViewModel.nameToEdit = "Updated Name"
        userViewModel.emailToEdit = "updated@user.com"
        
        userViewModel.updateUserInfo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.mockUserService.usersDatabase["mock_uid"]?.name, "Updated Name")
            XCTAssertEqual(self.mockUserService.usersDatabase["mock_uid"]?.email, "updated@user.com")
            XCTAssertEqual(self.userViewModel.user?.name, "Updated Name")
            XCTAssertEqual(self.userViewModel.user?.email, "updated@user.com")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateUserInfoFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Update user info failure")
        
        userViewModel.nameToEdit = "Updated Name"
        userViewModel.emailToEdit = "updated@user.com"
        
        userViewModel.updateUserInfo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.userViewModel.errorMsg)
            XCTAssertEqual(self.userViewModel.errorMsg, "Failed to update user info")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateUserNotificationPreferenceSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Update user notification preference success")
        
        userViewModel.notificationEnabled = true
        userViewModel.updateUserNotificationPreference()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.mockUserService.usersDatabase["mock_uid"]?.notification, true)
            XCTAssertEqual(self.userViewModel.user?.notification, true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateUserNotificationPreferenceFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Update user notification preference failure")
        
        userViewModel.notificationEnabled = true
        userViewModel.updateUserNotificationPreference()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.userViewModel.errorMsg)
            XCTAssertEqual(self.userViewModel.errorMsg, "Failed to update user notification preference")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    /*func testUpdateUserImageSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Update user image success")
        
        guard let image = UIImage(named: "testImage", in: Bundle(for: type(of: self)), compatibleWith: nil) else {
            XCTFail("Failed to load test image")
            return
        }
        userViewModel.selectedImage = image
        userViewModel.updateUserImage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.mockUserService.usersDatabase["mock_uid"]?.profilPicture, "updated_mock_image_url")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateUserImageFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Update user image failure")
        
        guard let image = UIImage(named: "testImage", in: Bundle(for: type(of: self)), compatibleWith: nil) else {
            XCTFail("Failed to load test image")
            return
        }
        userViewModel.selectedImage = image
        userViewModel.updateUserImage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.userViewModel.errorMsg)
            XCTAssertEqual(self.userViewModel.errorMsg, "Failed to update user image")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }*/
}



