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
    
    func testLoginSuccess() {
        mockAuthService.shouldSucceed = true
        
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

