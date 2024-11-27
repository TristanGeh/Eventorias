//
//  EventRepository.swift
//  Eventorias
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import CoreLocation
import SwiftUI

class EventRepository: EventManager {
    private let eventProvider: EventProvider
    private let geocoder = CLGeocoder()
    
    init(eventProvider: EventProvider = EventService()) {
        self.eventProvider = eventProvider
    }
    
    // MARK: - Formateur
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    func formattedDate(from date: Date) -> String {
        return dayFormatter.string(from: date)
    }
    
    func formattedTime(from date: Date) -> String {
        return timeFormatter.string(from: date)
    }
    
    
    // MARK: - Functions
    
    
    func addEvent(title: String, description: String, date: Date, time: Date, address: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        
        eventProvider.addEvent(title: title, description: description, date: date, time: time, address: address, image: image, completion: completion)
    }
    
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        eventProvider.fetchEvents { result in
            switch result {
            case .success(let eventsRaw):
                self.convertEventImageUrls(for: eventsRaw) { updatedEvents in
                    self.loadCreatorProfilePicture(for: updatedEvents) { finalEvents in
                        completion(.success(finalEvents))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func convertEventImageUrls(for events: [EventRaw], completion: @escaping ([Event]) -> Void) {
        var updatedEvents: [Event] = []
        let group = DispatchGroup()
        
        for eventRaw in events {
            group.enter()
            if !eventRaw.imageUrl.isEmpty {
                convertFirebaseURL(eventRaw.imageUrl) { httpUrl in
                    var updatedEvent = Event(eventRaw: eventRaw)
                    updatedEvent.imageUrl = httpUrl
                    updatedEvents.append(updatedEvent)
                    group.leave()
                }
            } else {
                updatedEvents.append(Event(eventRaw: eventRaw))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(updatedEvents)
        }
    }
    
    private func loadCreatorProfilePicture(for events: [Event], completion: @escaping ([Event]) -> Void) {
        var updatedEvents: [Event] = []
        let group = DispatchGroup()
        
        for event in events {
            group.enter()
            eventProvider.fetchUserProfilPicture(forUID: event.createdBy) { result in
                switch result {
                case .success(let profilePictureUrl):
                    self.convertFirebaseURL(profilePictureUrl) { httpUrl in
                        var updatedEvent = event
                        updatedEvent.profilePictureUrl = !httpUrl.isEmpty ? httpUrl : nil
                        updatedEvents.append(updatedEvent)
                        group.leave()
                    }
                case .failure:
                    updatedEvents.append(event)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(updatedEvents)
        }
    }
    
    func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void) {
        eventProvider.convertFirebaseURL(gsUrl) { url in
            DispatchQueue.main.async {
                completion(url)
            }
        }
    }
}
