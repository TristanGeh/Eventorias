//
//  EventRepositoryMock.swift
//  EventoriasTests
//

import Foundation
import SwiftUI
@testable import Eventorias

class MockEventRepository: EventManager {
    
    var events: [Event] = []
    var shouldFail: Bool = false
    
    func addEvent(title: String, description: String, date: Date, time: Date, address: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to add event"])))
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let formattedDate = dateFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.locale = Locale(identifier: "en_US")
        let formattedTime = timeFormatter.string(from: time)
        
        let eventRaw = EventRaw(
            id: UUID().uuidString,
            title: title,
            description: description,
            date: formattedDate,
            time: formattedTime,
            createdBy: "MockUserID",
            location: address,
            imageUrl: "https://mockurl.com/eventimage.jpg"
        )
        
        let newEvent = Event(eventRaw: eventRaw)
        self.events.append(newEvent)
        completion(.success(()))
    }
    
    
    
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch events"])))
        } else {
            completion(.success(events))
        }
    }
}
