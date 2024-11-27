//
//  EventServiceMock.swift
//  Eventorias
//

import Foundation
import SwiftUI
@testable import Eventorias

class MockEventService: EventProvider {
    
    var events: [EventRaw] = []
    var shouldFail: Bool = false
    
    func addEvent(title: String, description: String, date: Date, time: Date, address: String, image: UIImage, completion: @escaping (Result<Void, any Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to add event"])))
        } else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let formattedDate = dateFormatter.string(from: date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            timeFormatter.locale = Locale(identifier: "en_US")
            let formattedTime = timeFormatter.string(from: time)
            
            
            let newEvent = EventRaw(
                id: UUID().uuidString,
                title: title,
                description: description,
                date: formattedDate,
                time: formattedTime,
                createdBy: "MockUserID",
                location: address,
                imageUrl: "https://mockurl.com/eventimage.jpg"
            )
            events.append(newEvent)
            completion(.success(()))
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload image"])))
        } else {
            completion(.success("https://mockurl.com/eventimage.jpg"))
        }
    }
    
    func fetchEvents(completion: @escaping (Result<[EventRaw], Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch events"])))
        } else {
            completion(.success(events))
        }
    }
    
    func fetchUserProfilPicture(forUID uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch profile picture"])))
        } else {
            completion(.success("gs://eventorias.appspot.com"))
        }
    }
    
    func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void) {
        if shouldFail {
            completion("")
        } else {
            completion("https://mockurl.com/convertedurl.jpg")
        }
    }
}
