//
//  EventServiceProtocol.swift
//  Eventorias
//

import Foundation

protocol EventServiceProtocol {
    func addEvent(event: EventRaw, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchEvents(completion: @escaping(Result<[EventRaw], Error>) -> Void)
    func fetchUserProfilPicture(forUID uid: String, completion: @escaping (Result<String, Error>) -> Void)
}
