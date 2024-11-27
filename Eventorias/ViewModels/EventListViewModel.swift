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
    
    private let eventRepository: EventManager
    
    init(eventRepository: EventManager = EventRepository()) {
        self.eventRepository = eventRepository
    }
    
    var filteredEvents: [Event] {
        guard !searchText.isEmpty else { return events }
        return events.filter { event in
            event.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    // MARK: - Fonctions
    func fetchEvents() {
        eventRepository.fetchEvents { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self.events = events
                case .failure(let error):
                    self.errorMsg = "Failed to fetch events: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func addEvent(title: String, description: String, date: Date, time: Date, address: String, image: UIImage) {
        eventRepository.addEvent(title: title,
                                 description: description,
                                 date: date,
                                 time: time,
                                 address: address,
                                 image: image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Event successfully created")
                case .failure(let error):
                    self.errorMsg = "Failed to create event: \(error.localizedDescription)"
                    print("Failed to create event: \(error.localizedDescription)")
                }
            }
        }
    }
}

