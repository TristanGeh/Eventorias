//
//  EventTileView.swift
//  Eventorias
//

import SwiftUI

struct EventTileView: View {
    var event: Event
    
    var body: some View {
        
        ZStack {
            Color("SecondColor")
                .cornerRadius(12)
            
            
            HStack {
                AsyncImage(url: URL(string: event.profilePictureUrl ?? "")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 40, height: 40)
                }
                
                .padding(.leading, 20)
                
                VStack(alignment: .leading) {
                    Text(event.title)
                    Text(event.date)
                        .font(.caption)
                }
                .foregroundColor(.white)
                .padding(.leading, 20)
                
                Spacer()
                
                AsyncImage(url: URL(string: event.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 130, height: 80)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 130, height: 80)
                }
                .cornerRadius(8)
            }
        }
        .frame(height: 80)
        .padding(.horizontal)
    }
}

#Preview {
    let mockEventRaw = EventRaw(id: "1", title: "Mock Event", description: "Mock Description", date: "December 5, 2024", time: "10:30 AM", createdBy: "mockUser", location: "Boulevard des Belges, 69006 Lyon", imageUrl: "https://firebasestorage.googleapis.com/v0/b/eventorias.appspot.com/o/profileImages%2FimageAct1.jpeg?alt=media&token=568a738f-7da7-452e-abd6-8415410c5f5f")
    let mockEvent = Event(eventRaw: mockEventRaw)
    EventTileView(event: mockEvent)
}
