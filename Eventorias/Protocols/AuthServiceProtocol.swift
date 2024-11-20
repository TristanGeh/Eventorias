//
//  AuthServiceProtocol.swift
//  Eventorias
//

import Foundation

protocol AuthServiceProtocol {
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<String, Error>) -> Void)
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
}
