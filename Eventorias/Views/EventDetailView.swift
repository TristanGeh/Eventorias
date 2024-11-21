//
//  EventDetailView.swift
//  Eventorias
//

import SwiftUI

struct EventDetailView: View {
    var event: Event
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color("Main").edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 15) {
                AsyncImage(url: URL(string: event.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(15)
                        .frame(height: 358)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray)
                        .cornerRadius(15)
                        .frame(height: 358)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "calendar")
                            Text(event.date)
                        }
                        HStack {
                            Image(systemName: "clock")
                            Text(event.time)
                        }
                    }
                    
                    Spacer()
                    
                    AsyncImage(url: URL(string: event.profilePictureUrl ?? "")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 60, height: 60)
                    }
                }
                
                Text(event.description)
                
                AdressView(event: event)
                
            }
            .foregroundColor(.white)
            .padding()
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text(event.title)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                }

            }
        }
    }
}

#Preview {
    let mockEventRaw = EventRaw(id: "1", title: "Mock Event", description: "Mock Description", date: "December 5, 2024", time: "10:30 AM", createdBy: "mockUser", location: "Boulevard des Belges, 69006 Lyon", imageUrl: "https://firebasestorage.googleapis.com/v0/b/eventorias.appspot.com/o/profileImages%2FimageAct1.jpeg?alt=media&token=568a738f-7da7-452e-abd6-8415410c5f5f")
    let mockEvent = Event(eventRaw: mockEventRaw)
    EventDetailView(event: mockEvent)
}
