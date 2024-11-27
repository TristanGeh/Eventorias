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
            
            eventListViewModel.addEvent(title: title,
                                        description: description,
                                        date: date,
                                        time: time,
                                        address: address,
                                        image: image)
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
