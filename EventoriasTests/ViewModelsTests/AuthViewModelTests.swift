//
//  AuthViewModelTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class AuthViewModelTests: XCTestCase {
    
    var authViewModel: AuthViewModel!
    var mockAuthProvider: MockFirebaseAuthProvider!
    var authRepository: MockAuthRepository!
    
    
    override func setUp() {
        super.setUp()
        mockAuthProvider = MockFirebaseAuthProvider()
        authRepository = MockAuthRepository()
        authViewModel = AuthViewModel(authService: authRepository)
    }
    
    override func tearDown() {
        authViewModel = nil
        mockAuthProvider = nil
        authRepository = nil
        super.tearDown()
    }
    
    // MARK: - Tests for signUp
    
    func testSignUpSuccess() {
        // Given
        mockAuthProvider.shouldSucceed = true
        authViewModel.email = "test@example.com"
        authViewModel.password = "password123"
        authViewModel.name = "Test User"
        
        // When
        authViewModel.signUp()
        
        // Then
        XCTAssertEqual(authViewModel.errorMessage, "Account created successfully", "Expected success message for account creation")
        XCTAssertTrue(authViewModel.isConnected, "User should be connected after successful sign up")
    }
    
    func testSignUpFailure() {
        // Given
        authRepository.shouldSucceed = false
        authViewModel.email = "test@example.com"
        authViewModel.password = "password123"
        authViewModel.name = "Test User"
        
        // When
        authViewModel.signUp()
        
        // Then
        XCTAssertEqual(authViewModel.errorMessage, "An error occured while try create Account: Mock sign-up error", "Expected failure message for account creation")
        XCTAssertFalse(authViewModel.isConnected, "User should not be connected after failed sign up")
    }
    
    func testSignUpInvalidEmail() {
        // Given
        authViewModel.email = "invalid-email"
        authViewModel.password = "password123"
        authViewModel.name = "Test User"
        
        // When
        authViewModel.signUp()
        
        // Then
        XCTAssertEqual(authViewModel.errorMessage, "Invalid email format", "Expected invalid email format message")
        XCTAssertFalse(authViewModel.isConnected, "User should not be connected with invalid email")
    }
    
    // MARK: - Tests for login
    
    func testLoginSuccess() {
        // Given
        authRepository.shouldSucceed = true
        let testUser = MockUserForLogin(uid: "123", email: "test@example.com", password: "password123")
        authRepository.usersDatabase["123"] = testUser
        authViewModel.email = "test@example.com"
        authViewModel.password = "password123"
        
        
        // When
        authViewModel.login()
        
        // Then
        XCTAssertEqual(self.authViewModel.errorMessage, "Logged successfully !", "Expected success message for login")
        XCTAssertTrue(self.authViewModel.isConnected, "User should be connected after successful login")
    }
    
    func testLoginFailure() {
        // Given
        authRepository.shouldSucceed = false
        authViewModel.email = "test@example.com"
        authViewModel.password = "password123"
        
        // When
        authViewModel.login()
        
        // Then
        XCTAssertEqual(self.authViewModel.errorMessage, "Mock login error", "Expected failure message for login")
        XCTAssertFalse(self.authViewModel.isConnected, "User should not be connected after failed login")
    }
    
    func testLoginInvalidEmail() {
        // Given
        authViewModel.email = "invalid-email"
        authViewModel.password = "password123"
        
        // When
        authViewModel.login()
        
        // Then
        XCTAssertEqual(authViewModel.errorMessage, "Invalid email format", "Expected invalid email format message")
        XCTAssertFalse(authViewModel.isConnected, "User should not be connected with invalid email")
    }
}
