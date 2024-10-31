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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.userViewModel.user)
            XCTAssertEqual(self.userViewModel.user?.name, "Mock User")
            XCTAssertEqual(self.userViewModel.nameToEdit, "Mock User")
            XCTAssertEqual(self.userViewModel.emailToEdit, "mock@user.com")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testFetchUserFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Fetch user failure")

        userViewModel.fetchUser()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.userViewModel.user)
            XCTAssertEqual(self.userViewModel.errorMsg, "Failed to fetch user")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserInfoSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Update user info success")

        userViewModel.user = User(uid: "mock_uid", name: "Old Name", notification: false, profilPicture: "", email: "old@user.com")
        userViewModel.nameToEdit = "New Name"
        userViewModel.emailToEdit = "new@user.com"

        userViewModel.updateUserInfo()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.userViewModel.user?.name, "New Name")
            XCTAssertEqual(self.userViewModel.user?.email, "new@user.com")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserInfoFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Update user info failure")

        userViewModel.user = User(uid: "mock_uid", name: "Old Name", notification: false, profilPicture: "", email: "old@user.com")
        userViewModel.nameToEdit = "New Name"
        userViewModel.emailToEdit = "new@user.com"

        userViewModel.updateUserInfo()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.userViewModel.errorMsg, "Failed to update user info")
            XCTAssertEqual(self.userViewModel.user?.name, "Old Name")
            XCTAssertEqual(self.userViewModel.user?.email, "old@user.com")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserNotificationPreferenceSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Update user notification preference success")

        userViewModel.user = User(uid: "mock_uid", name: "Mock User", notification: false, profilPicture: "", email: "mock@user.com")
        userViewModel.notificationEnabled = true

        userViewModel.updateUserNotificationPreference()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.userViewModel.user?.notification ?? false)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserNotificationPreferenceFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Update user notification preference failure")

        userViewModel.user = User(uid: "mock_uid", name: "Mock User", notification: false, profilPicture: "", email: "mock@user.com")
        userViewModel.notificationEnabled = true

        userViewModel.updateUserNotificationPreference()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.userViewModel.errorMsg, "Failed to update user notification preference")
            XCTAssertFalse(self.userViewModel.user?.notification ?? true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserImageSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Update user image success")

        userViewModel.user = User(uid: "mock_uid", name: "Mock User", notification: false, profilPicture: "", email: "mock@user.com")
        userViewModel.selectedImage = UIImage(systemName: "person")

        userViewModel.updateUserImage()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.userViewModel.user?.profilPicture)
            XCTAssertEqual(self.userViewModel.user?.profilPicture, "updated_mock_image_url")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserImageFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Update user image failure")

        userViewModel.user = User(uid: "mock_uid", name: "Mock User", notification: false, profilPicture: "", email: "mock@user.com")
        userViewModel.selectedImage = UIImage(systemName: "person")

        userViewModel.updateUserImage()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.userViewModel.errorMsg, "Failed to update user image")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
}
