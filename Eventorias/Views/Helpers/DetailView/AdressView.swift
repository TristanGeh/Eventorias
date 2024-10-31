//
//  AdressView.swift
//  Eventorias
//

import SwiftUI

struct AdressView: View {
    var event: Event
    var body: some View {
        HStack(alignment: .top) {
            Text(event.location)
            
            Spacer()
            
            MapView(address: event.location)
                .cornerRadius(15)
        }
    }
}

#Preview {
    let mockEventRaw = EventRaw(id: "1", title: "Mock Event", description: "Mock Description", date: "December 5, 2024", time: "10:30 AM", createdBy: "mockUser", location: "Boulevard des Belges, 69006 Lyon", imageUrl: "https://firebasestorage.googleapis.com/v0/b/eventorias.appspot.com/o/profileImages%2FimageAct1.jpeg?alt=media&token=568a738f-7da7-452e-abd6-8415410c5f5f")
    let mockEvent = Event(eventRaw: mockEventRaw)
    AdressView(event: mockEvent)
}
