//
//  EventModel.swift
//  Eventorias
//

import Foundation
import FirebaseFirestore

struct EventRaw: Identifiable {
    var id: String
    var title: String
    var description: String
    var date: String
    var time: String
    var createdBy: String
    var location: String
    var imageUrl: String
}

struct Event: Identifiable {
    var id: String { eventRaw.id }
    var title: String { eventRaw.title }
    var description: String { eventRaw.description }
    var date: String { eventRaw.date }
    var time: String { eventRaw.time }
    var createdBy: String { eventRaw.createdBy }
    var location: String { eventRaw.location }
    var imageUrl: String
    var profilePictureUrl: String?

    private let eventRaw: EventRaw
    
    init(eventRaw: EventRaw) {
        self.eventRaw = eventRaw
        self.imageUrl = eventRaw.imageUrl
        self.profilePictureUrl = nil
    }
}
