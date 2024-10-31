//
//  EventListViewModel.swift
//  Eventorias
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import CoreLocation
import SwiftUI

class EventListViewModel: ObservableObject {
    // MARK: - Variables
    @Published var events: [Event] = []
    @Published var errorMsg: String?
    @Published var searchText: String = ""
    
    private var cachedProfilePictureUrls: [String: String] = [:]
    
    private let geocoder = CLGeocoder()
    
    var filteredEvents: [Event] {
        guard !searchText.isEmpty else { return events }
        return events.filter { event in
            event.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
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
    
    // MARK: - Fonctions
    
    func fetchEvents() {
        eventService.fetchEvents { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventsRaw):
                    self.convertEventImageUrls(for: eventsRaw) { updatedEventWithPictures in
                        self.loadCreatorProfilePicture(for: updatedEventWithPictures) { finalEvents in
                            self.events = finalEvents
                        }
                    }
                case .failure(let error):
                    self.errorMsg = "Failed to fetch events: \(error.localizedDescription)"
                    print("\(String(describing: self.errorMsg))")
                }
            }
        }
    }
    
    
    private func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void) {
        let storageRef = Storage.storage().reference(forURL: gsUrl)
        storageRef.downloadURL { url, error in
            if let error = error {
                print("Erreur lors de la récupération de l'URL: \(error.localizedDescription)")
                completion("")
            } else if let url = url {
                completion(url.absoluteString)
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
            
            if let cachedUrl = cachedProfilePictureUrls[event.createdBy] {
                var updatedEvent = event
                updatedEvent.profilePictureUrl = cachedUrl
                updatedEvents.append(updatedEvent)
                group.leave()
            } else {
                fetchAndConvertProfilePicture(for: event) { updatedEvent in
                    updatedEvents.append(updatedEvent)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.cachedProfilePictureUrls.removeAll()
            completion(updatedEvents)
        }
    }
    
    private func fetchAndConvertProfilePicture( for event: Event, completion: @escaping (Event) -> Void) {
        self.eventService.fetchUserProfilPicture(forUID: event.createdBy) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profilePictureUrl):
                    self.convertFirebaseURL(profilePictureUrl) { httpUrl in
                        var updatedEvent = event
                        updatedEvent.profilePictureUrl = !httpUrl.isEmpty ? httpUrl : nil
                        completion(updatedEvent)
                    }
                case .failure:
                    print("Failed to load profile picture for event : \(event.title)")
                    completion(event)
                }
            }
        }
    }
    
    
    
    
    private func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Erreur lors de la géolocalisation : \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                let coordinate = location.coordinate
                completion(coordinate)
            } else {
                print("Impossible de trouver un emplacement pour l'adresse donnée.")
                completion(nil)
            }
        }
    }
    
    
    func addEvent(event: EventRaw) {
        eventService.addEvent(event: event) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.fetchEvents()
                    print("Event add successfully")
                case .failure(let error):
                    self.errorMsg = error.localizedDescription
                }
            }
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
            let storageRef = Storage.storage().reference().child("eventImages/\(UUID().uuidString).jpg")
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            completion(.failure(error))
                        } else if let url = url {
                            completion(.success(url.absoluteString))
                        }
                    }
                }
            } else {
                completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image conversion to JPEG failed."])))
            }
        }

        func createEvent(with title: String, description: String, date: Date, time: Date, address: String, imageUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let currentUser = Auth.auth().currentUser else {
                completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
                return
            }

            let newEventRaw = EventRaw(
                id: UUID().uuidString,
                title: title,
                description: description,
                date: self.formattedDate(from: date),
                time: self.formattedTime(from: time),
                createdBy: currentUser.uid,
                location: address,
                imageUrl: imageUrl
            )
            
            addEvent(event: newEventRaw)
            completion(.success(()))
        }
}

