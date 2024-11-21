//
//  EventServiceMock.swift
//  Eventorias
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MockEventService: EventServiceProtocol {
    var shouldSucceed: Bool = true
    var eventsDatabase: [String: EventRaw] = [:]

    func addEvent(event: EventRaw, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            eventsDatabase[event.id] = event
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock add event error"])))
        }
    }

    func fetchEvents(completion: @escaping (Result<[EventRaw], Error>) -> Void) {
        if shouldSucceed {
            let mockEvents = Array(eventsDatabase.values)
            completion(.success(mockEvents))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch events"])))
        }
    }

    func fetchUserProfilPicture(forUID uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceed {
            completion(.success("gs://eventorias.appspot.com"))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user name"])))
        }
    }
}
