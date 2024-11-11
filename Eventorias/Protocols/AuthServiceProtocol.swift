//
//  AuthServiceProtocol.swift
//  Eventorias
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
}
