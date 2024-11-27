//
//  UserProfileView.swift
//  Eventorias
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var sourceType: ImagePicker.SourceType = .photoLibrary
    
    var body: some View {
        VStack {
            HStack {
                Text("User Profile")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                if let profilePicture = viewModel.user?.profilPicture {
                    AsyncImage(url: URL(string: profilePicture)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 40, height: 40)
                    }
                    .onTapGesture {
                        showingImagePicker = true
                    }
                }
            }
            
            VStack(spacing: 15) {
                CustomTextFieldView(title: "Name", text: $viewModel.nameToEdit)
                CustomTextFieldView(title: "E-mail", text: $viewModel.emailToEdit)
                
                HStack {
                    Toggle(isOn: $viewModel.notificationEnabled) {
                        EmptyView()
                    }
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                    .onChange(of: viewModel.notificationEnabled) {
                        viewModel.updateUserNotificationPreference()
                    }
                    
                    Text("Notifications")
                        .foregroundColor(.white)
                    Spacer()
                }
                
            }
            
            Button(action: {
                viewModel.updateUserInfo()
            }) {
                Text("Save Changes")
                    .padding()
                    .background(Color("MainRed"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 125)
        }
        .padding()
        Spacer()
        
        
            .onAppear {
                viewModel.fetchUser()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(sourceType: sourceType, image: $selectedImage)
            }
            .onChange(of: selectedImage) { newImage in
                if let newImage = newImage {
                    viewModel.selectedImage = newImage
                    viewModel.updateUserImage()
                }
            }
    }
}

#Preview {
    @Previewable @State var viewModel = UserViewModel(userRepository: UserRepository())
    UserProfileView()
        .environmentObject(viewModel)
}
