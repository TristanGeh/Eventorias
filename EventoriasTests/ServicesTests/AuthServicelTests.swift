//
//  AuthServicelTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

class AuthServiceTests: XCTestCase {
    
    var authService: AuthService!
    var mockAuth: MockFirebaseAuthProvider!
    
    override func setUp() {
        super.setUp()
        mockAuth = MockFirebaseAuthProvider()
        authService = AuthService()
    }
    
    override func tearDown() {
        authService = nil
        mockAuth = nil
        super.tearDown()
    }
    
    // MARK: - Tests for createUser
    
    func testCreateUserSuccess() {
        // Given
        mockAuth.shouldSucceed = true
        let expectedEmail = "test@example.com"
        let expectedPassword = "password123"
        
        let expectation = self.expectation(description: "User should be created successfully")
        
        // When
        mockAuth.createUser(email: expectedEmail, password: expectedPassword) { result in
            // Then
            switch result {
            case .success(let authDataResult):
                XCTAssertEqual(authDataResult.user.email, expectedEmail, "Expected email to match for successful user creation")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCreateUserFailure() {
        // Given
        mockAuth.shouldSucceed = false
        let expectedEmail = "test@example.com"
        let expectedPassword = "password123"
        
        let expectation = self.expectation(description: "User creation should fail")
        
        // When
        mockAuth.createUser(email: expectedEmail, password: expectedPassword) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Mock sign-up error", "Expected failure message for sign-up")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: - Tests for saveUserData
    
    func testSaveUserDataSuccess() {
        // Given
        let uid = "mockUserID"
        let userData: [String: Any] = [
            "name": "Test User",
            "email": "test@example.com"
        ]
        mockAuth.shouldSucceed = true
        
        let expectation = self.expectation(description: "User data should be saved successfully")
        
        // When
        mockAuth.saveUserData(uid: uid, userData: userData) { result in
            // Then
            switch result {
            case .success:
                XCTAssertNotNil(self.mockAuth.usersDatabase[uid], "Expected user data to be saved in the database")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSaveUserDataFailure() {
        // Given
        let uid = "mockUserID"
        let userData: [String: Any] = [
            "name": "Test User",
            "email": "test@example.com"
        ]
        mockAuth.shouldSucceed = false
        
        let expectation = self.expectation(description: "User data saving should fail")
        
        // When
        mockAuth.saveUserData(uid: uid, userData: userData) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Mock save user data error", "Expected failure message for saving user data")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: - Tests for signIn
    
    func testSignInSuccess() {
        // Given
        mockAuth.shouldSucceed = true
        let expectedEmail = "test@example.com"
        let expectedPassword = "password123"
        let mockUID = "123"
        let userData: [String: Any] = [
            "uid": mockUID,
            "email": expectedEmail
        ]
        mockAuth.usersDatabase[mockUID] = userData
        
        let expectation = self.expectation(description: "User should sign in successfully")
        
        // When
        mockAuth.signIn(email: expectedEmail, password: expectedPassword) { result in
            // Then
            switch result {
            case .success(let authDataResult):
                XCTAssertEqual(authDataResult.user.email, expectedEmail, "Expected email to match after successful sign-in")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSignInFailure() {
        // Given
        mockAuth.shouldSucceed = false
        let expectedEmail = "test@example.com"
        let expectedPassword = "password123"
        
        let expectation = self.expectation(description: "User sign in should fail")
        
        // When
        mockAuth.signIn(email: expectedEmail, password: expectedPassword) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Mock login error", "Expected failure message for sign-in")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
