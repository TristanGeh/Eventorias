//
//  UserServiceTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class UserServiceTests: XCTestCase {

    var userService: UserServiceProtocol!
    var mockUserService: MockUserService!

    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        userService = mockUserService
    }

    override func tearDown() {
        userService = nil
        mockUserService = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testFetchUserSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Fetch user success")

        userService.fetchUser(withID: "mock_uid") { result in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.uid, "mock_uid")
                XCTAssertEqual(user.name, "Mock User")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 1.0)
    }

    func testFetchUserFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Fetch user failure")

        userService.fetchUser(withID: "unknown_uid") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to fetch user")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserInfoSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Update user info success")

        let updatedUser = User(uid: "mock_uid", name: "Updated Name", notification: false, profilPicture: "test", email: "updated@user.com")

        userService.updateUserInfo(user: updatedUser) { result in
            switch result {
            case .success:
                if let fetchedUser = self.mockUserService.usersDatabase[updatedUser.uid] {
                    XCTAssertEqual(fetchedUser.name, "Updated Name")
                    XCTAssertEqual(fetchedUser.email, "updated@user.com")
                    expectation.fulfill()
                } else {
                    XCTFail("User not found in the mock database")
                }
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserInfoFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Update user info failure")

        let user = User(uid: "mock_uid", name: "Updated Name", notification: false, profilPicture: "test", email: "updated@user.com")

        userService.updateUserInfo(user: user) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to update user info")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserNotificationPreferenceSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Update user notification preference success")

        let user = User(uid: "mock_uid", name: "Mock User", notification: false, profilPicture: "test", email: "mock@user.com")

        userService.updateUserNotificationPreference(user: user, enabled: true) { result in
            switch result {
            case .success:
                if let fetchedUser = self.mockUserService.usersDatabase[user.uid] {
                    XCTAssertTrue(fetchedUser.notification)
                    expectation.fulfill()
                } else {
                    XCTFail("User not found in the mock database")
                }
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserNotificationPreferenceFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Update user notification preference failure")

        let user = User(uid: "mock_uid", name: "Mock User", notification: false, profilPicture: "test", email: "mock@user.com")

        userService.updateUserNotificationPreference(user: user, enabled: true) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to update user notification preference")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserImageSuccess() {
        mockUserService.shouldSucceed = true
        let expectation = self.expectation(description: "Update user image success")

        let user = User(uid: "mock_uid", name: "Mock User", notification: false, profilPicture: "test", email: "mock@user.com")
        let image = UIImage(systemName: "person")!

        userService.updateUserImage(user: user, image: image) { result in
            switch result {
            case .success:
                if let fetchedUser = self.mockUserService.usersDatabase[user.uid] {
                    XCTAssertEqual(fetchedUser.profilPicture, "updated_mock_image_url")
                    expectation.fulfill()
                } else {
                    XCTFail("User not found in the mock database")
                }
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUpdateUserImageFailure() {
        mockUserService.shouldSucceed = false
        let expectation = self.expectation(description: "Update user image failure")

        let user = User(uid: "mock_uid", name: "Mock User", notification: false, profilPicture: "test", email: "mock@user.com")
        let image = UIImage(systemName: "person")!

        userService.updateUserImage(user: user, image: image) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to update user image")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1.0)
    }
}

