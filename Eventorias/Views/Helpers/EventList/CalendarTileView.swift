//
//  CalendarTileView.swift
//  Eventorias
//

import SwiftUI

struct CalendarTileView: View {
    var event: Event
    
    var body: some View {
        
        ZStack {
            Color("SecondColor")
                .cornerRadius(12)
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: event.imageUrl)) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 100)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 200, height: 100)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text(event.title)
                    
                    Text(event.date)
                }
                .foregroundColor(.white)
                .padding(.leading, 15)
                .padding(.bottom, 25)
            }
            .frame(width: 200,height: 150)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

#Preview {
    let mockEventRaw = EventRaw(id: "1", title: "Mock Event", description: "Mock Description", date: "December 5, 2024", time: "10:30 AM", createdBy: "mockUser", location: "Boulevard des Belges, 69006 Lyon", imageUrl: "https://firebasestorage.googleapis.com/v0/b/eventorias.appspot.com/o/profileImages%2FimageAct1.jpeg?alt=media&token=568a738f-7da7-452e-abd6-8415410c5f5f")
    let mockEvent = Event(eventRaw: mockEventRaw)
    CalendarTileView(event: mockEvent)
}
