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
    
    var body: some View {
        
        ZStack {
            
            Color("Main").edgesIgnoringSafeArea(.all)
            
            VStack {
                CustomTextFieldView(title: "Title", text: $title)
                
                CustomTextFieldView(title: "Description", text: $description)
                
                HStack {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .foregroundColor(.white)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                        .foregroundColor(.white)
                }
                
                
                AddressTextFieldView(address: $address)
                frame(height: 40)
                    .padding(.horizontal, 10)
                    .background(Color("SecondColor"))
                    .cornerRadius(5)
                
                
                HStack(spacing: 15) {
                    Button {
                        useCamera = true
                        showingImagePicker = true
                    } label: {
                        Image(systemName: "camera")
                            .foregroundColor(.black)
                            .frame(width: 52, height: 52)
                            .background(.white)
                            .cornerRadius(10)
                        
                    }
                    
                    Button {
                        useCamera = false
                        showingImagePicker = true
                    } label: {
                        Image(systemName: "folder")
                            .foregroundColor(.white)
                            .frame(width: 52, height: 52)
                            .background(Color("MainRed"))
                            .cornerRadius(10)
                    }
                    
                    
                }
                
                Button {
                    if let image = selectedImage {
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
                    } else {
                        print("No image selected")
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
    AddEventView()
}
