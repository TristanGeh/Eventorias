//
//  ValidateButtonView.swift
//  Eventorias
//

import SwiftUI

struct ValidateButtonView: View {
    @EnvironmentObject var eventListViewModel: EventListViewModel
    
    var title: String
    var description: String
    var date: Date
    var time: Date
    var address: String
    @Binding var selectedImage: UIImage?
    
    
    var body: some View {
        Button {
            guard let image = selectedImage else {
                print("No image selected")
                return
            }
            
            eventListViewModel.uploadImage(image: image) { result in
                switch result {
                case .success(let imageUrl):
                    eventListViewModel.createEvent(with: title, description: description, date: date, time: time, address: address, imageUrl: imageUrl) { eventResult in
                        switch eventResult {
                        case .success:
                            print("Event successfully created")
                        case .failure(let error):
                            print("Failed to create event: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Failed to upload image: \(error.localizedDescription)")
                }
            }
        } label: {
            Text("Validate")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("MainRed"))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
