//
//  AddEventView.swift
//  Eventorias
//

import SwiftUI

struct AddEventView: View {
    @EnvironmentObject var eventListViewModel: EventListViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date = Date()
    @State private var time = Date()
    @State private var address: String = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var useCamera = false
    
    @StateObject private var cameraHandler = CameraAccessHandler()
    
    var body: some View {
        
        ZStack {
            
            Color("Main").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                CustomTextFieldView(title: "Title", text: $title)
                
                CustomTextFieldView(title: "Description", text: $description)
                
                HStack {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .foregroundColor(.white)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                        .foregroundColor(.white)
                }
                
                
                CustomTextFieldView(title: "Address", text: $address)
                
                ImageButtonsView(showImagePicker: $showingImagePicker, useCamera: $useCamera, cameraHandler: cameraHandler)
                
                Spacer()
                
                ValidateButtonView(title: title,
                                   description: description,
                                   date: date,
                                   time: time,
                                   address: address,
                                   selectedImage: $selectedImage
                )
                .environmentObject(eventListViewModel)
            }
            .padding()
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(sourceType: useCamera ? .camera : .photoLibrary, image: $selectedImage)
            }
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
                        Text("Creation of an event")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                }
                
            }
        }
    }
}

#Preview {
    let viewModel = EventListViewModel()
    AddEventView()
        .environmentObject(viewModel)
}
