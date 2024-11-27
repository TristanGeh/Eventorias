//
//  EventProtocol.swift
//  Eventorias
//

import Foundation
import SwiftUI

protocol EventProvider {
    func addEvent(title: String, description: String, date: Date, time: Date, address: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void)
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
    func fetchEvents(completion: @escaping (Result<[EventRaw], Error>) -> Void)
    func fetchUserProfilPicture(forUID uid: String, completion: @escaping (Result<String, Error>) -> Void)
    func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void)
}

protocol EventManager {
    func addEvent(title: String, description: String, date: Date, time: Date, address: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void)
}
