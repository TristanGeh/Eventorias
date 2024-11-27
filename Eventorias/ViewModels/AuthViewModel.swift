//
//  AuthViewModel.swift
//  Eventorias
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var errorMessage: String?
    @Published var isConnected: Bool = false
    
    private let authService: AuthManager
    
    init(authService: AuthManager = AuthRepository(authProvider: AuthService())) {
        self.authService = authService
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func signUp() {
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format"
            return
        }
        
        authService.signUp(email: email, password: password, name: name) { result in
            switch result {
            case .success:
                self.errorMessage = "Account created successfully"
                self.isConnected = true
            case .failure(let error):
                self.errorMessage = "An error occured while try create Account: \(error.localizedDescription)"
            }
        }
    }
    
    
    func login() {
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format"
            return
        }
        authService.login(email: email, password: password) { result in
            switch result {
            case .success:
                self.errorMessage =  "Logged successfully !"
                self.isConnected = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isConnected = false
            }
        }
    }
}
