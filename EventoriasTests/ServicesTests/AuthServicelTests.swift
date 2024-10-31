//
//  AuthServicelTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class AuthServiceTests: XCTestCase {
    
    var authService: AuthServiceProtocol!
    var mockAuthService: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        authService = mockAuthService
    }
    
    override func tearDown() {
        authService = nil
        mockAuthService = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    func testSignUpSuccess() {
        mockAuthService.shouldSucceed = true
        let expectation = self.expectation(description: "SignUp success")
        
        authService.signUp(email: "test@example.com", password: "password123", name: "Test User") { result in
            switch result {
            case .success(let uid):
                XCTAssertNotNil(uid, "UID should not be nil on sign-up success")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSignUpFailure() {
        mockAuthService.shouldSucceed = false
        let expectation = self.expectation(description: "SignUp failure")
        
        authService.signUp(email: "test@example.com", password: "password123", name: "Test User") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Mock sign-up error")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoginSuccess() {
        mockAuthService.shouldSucceed = true
        let signUpExpectation = self.expectation(description: "Sign up for login test")
        
        authService.signUp(email: "test@example.com", password: "password123", name: "Test User") { result in
            switch result {
            case .success:
                signUpExpectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to sign up: \(error)")
            }
        }
        
        waitForExpectations(timeout: 1.0)
        
        let loginExpectation = self.expectation(description: "Login success")
        
        authService.login(email: "test@example.com", password: "password123") { result in
            switch result {
            case .success(let uid):
                XCTAssertNotNil(uid, "UID should not be nil on login success")
                loginExpectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoginFailure() {
        mockAuthService.shouldSucceed = true
        let loginExpectation = self.expectation(description: "Login failure")
        
        authService.login(email: "nonexistent@example.com", password: "password123") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "User not found")
                loginExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

