//
//  AuthRepsitoryTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class AuthRepsitoryTests: XCTestCase {
    
    var authRepository: AuthRepository!
    var mockAuthProvider: MockFirebaseAuthProvider!
    
    override func setUp() {
        super.setUp()
        mockAuthProvider = MockFirebaseAuthProvider()
        authRepository = AuthRepository(authProvider: mockAuthProvider)
    }
    
    override func tearDown() {
        authRepository = nil
        mockAuthProvider = nil
        super.tearDown()
    }
    
    // MARK: - Tests for signUp
    
    func testSignUpSuccess() {
        // Given
        mockAuthProvider.shouldSucceed = true
        let expectedEmail = "test@example.com"
        let expectedPassword = "password123"
        let expectedName = "Test User"
        
        // When
        authRepository.signUp(email: expectedEmail, password: expectedPassword, name: expectedName) { result in
            // Then
            switch result {
            case .success(let uid):
                XCTAssertFalse(uid.isEmpty, "UID should not be empty")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
    }
    
    func testSignUpFailure() {
        // Given
        mockAuthProvider.shouldSucceed = false
        let expectedEmail = "test@example.com"
        let expectedPassword = "password123"
        let expectedName = "Test User"
        
        // When
        authRepository.signUp(email: expectedEmail, password: expectedPassword, name: expectedName) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil")
            }
        }
    }
    
    // MARK: - Tests for saveUser
    
    func testSaveUserSuccess() {
        // Given
        mockAuthProvider.shouldSucceed = true
        let uid = "mockUserID"
        let expectedEmail = "test@example.com"
        let expectedName = "Test User"
        
        // When
        authRepository.saveUser(uid: uid, email: expectedEmail, name: expectedName) { result in
            // Then
            switch result {
            case .success(let savedUID):
                XCTAssertEqual(savedUID, uid, "Saved UID should match the expected UID")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
    }
    
    func testSaveUserFailure() {
        // Given
        mockAuthProvider.shouldSucceed = false
        let uid = "mockUserID"
        let expectedEmail = "test@example.com"
        let expectedName = "Test User"
        
        // When
        authRepository.saveUser(uid: uid, email: expectedEmail, name: expectedName) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil")
            }
        }
    }
    
    // MARK: - Tests for login
    
    func testLoginSuccess() {
        // Given
        mockAuthProvider.shouldSucceed = true
        let expectedEmail = "test@example.com"
        let expectedPassword = "password123"
        let mockUID = UUID().uuidString
        mockAuthProvider.usersDatabase[mockUID] = [
            "uid": mockUID,
            "email": expectedEmail,
            "password": expectedPassword 
        ]
        
        let expectation = self.expectation(description: "Login should succeed")
        
        // When
        authRepository.login(email: expectedEmail, password: expectedPassword) { result in
            // Then
            switch result {
            case .success(let uid):
                XCTAssertFalse(uid.isEmpty, "UID should not be empty")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoginFailure() {
        // Given
        mockAuthProvider.shouldSucceed = false
        let expectedEmail = "test@example.com"
        let expectedPassword = "password123"
        
        // When
        authRepository.login(email: expectedEmail, password: expectedPassword) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil")
            }
        }
    }
}
