//
//  AuthViewModelTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class AuthViewModelTests: XCTestCase {
    var authViewModel: AuthViewModel!
    var mockAuthService: MockAuthService!

    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        authViewModel = AuthViewModel(authService: mockAuthService)
    }

    override func tearDown() {
        authViewModel = nil
        mockAuthService = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testIsValidEmail() {
        XCTAssertTrue(authViewModel.isValidEmail("test@example.com"))
        XCTAssertFalse(authViewModel.isValidEmail("invalid-email"))
        XCTAssertFalse(authViewModel.isValidEmail("@example.com"))
        XCTAssertFalse(authViewModel.isValidEmail("test@.com"))
    }

    func testSignUpSuccess() {
        mockAuthService.shouldSucceed = true
        let expectation = self.expectation(description: "Sign up success")

        authViewModel.email = "test@example.com"
        authViewModel.password = "password123"
        authViewModel.name = "Test User"

        authViewModel.signUp()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.authViewModel.errorMessage, "Account created successfully!")
            XCTAssertTrue(self.authViewModel.isConnected)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testSignUpFailure() {
        mockAuthService.shouldSucceed = false
        let expectation = self.expectation(description: "Sign up failure")

        authViewModel.email = "test@example.com"
        authViewModel.password = "password123"
        authViewModel.name = "Test User"

        authViewModel.signUp()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.authViewModel.errorMessage, "Mock sign-up error")
            XCTAssertFalse(self.authViewModel.isConnected)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testLoginSuccess() {
        mockAuthService.shouldSucceed = true
        let expectation = self.expectation(description: "Login success")

        authViewModel.email = "test@example.com"
        authViewModel.password = "password123"

        authViewModel.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.authViewModel.errorMessage, "Logged successfully !")
            XCTAssertTrue(self.authViewModel.isConnected)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testLoginFailure() {
        mockAuthService.shouldSucceed = false
        let expectation = self.expectation(description: "Login failure")

        authViewModel.email = "test@example.com"
        authViewModel.password = "password123"

        authViewModel.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.authViewModel.errorMessage, "Mock login error")
            XCTAssertFalse(self.authViewModel.isConnected)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testInvalidEmail() {
        authViewModel.email = "invalid-email"
        authViewModel.signUp()
        XCTAssertEqual(authViewModel.errorMessage, "Invalid email format")
        XCTAssertFalse(authViewModel.isConnected)
    }
}
