//
//  UserViewModel.swift
//  Eventorias
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var nameToEdit: String = ""
    @Published var emailToEdit: String = ""
    @Published var notificationEnabled: Bool = false
    @Published var selectedImage: UIImage?
    @Published var showingImagePicker: Bool = false
    @Published var errorMsg: String?
    
    private let userRepository: UserManager
    
    init(userRepository: UserManager = UserRepository()) {
        self.userRepository = userRepository
    }
    
    func fetchUser() {
        userRepository.fetchUser() { result in
            switch result {
            case .success(let user):
                self.userRepository.convertFirebaseURL(user.profilPicture) { convertedUrl in
                    var updatedUser = user
                    updatedUser.profilPicture = convertedUrl
                    self.user = updatedUser
                    self.nameToEdit = user.name
                    self.emailToEdit = user.email
                    self.notificationEnabled = user.notification
                }
            case .failure:
                self.errorMsg = "Failed to update user info"
            }
        }
    }
    
    func updateUserInfo() {
        guard var updatedUser = user else {
            self.errorMsg = "User not loaded"
            return
        }
        
        updatedUser.name = nameToEdit
        updatedUser.email = emailToEdit
        
        userRepository.updateUserInfo(user: updatedUser) { result in
            switch result {
            case .success:
                self.user = updatedUser
                print("User information updated successfully")
            case .failure(let error):
                self.errorMsg = error.localizedDescription
            }
        }
    }
    
    func updateUserNotificationPreference() {
        guard var updatedUser = user else {
            self.errorMsg = "User not loaded"
            return
        }
        
        updatedUser.notification = notificationEnabled
        print("Updating notificationEnabled to: \(notificationEnabled)")
        
        userRepository.updateUserNotificationPreference(user: updatedUser, enabled: notificationEnabled) { result in
            switch result {
            case .success:
                self.user = updatedUser
                print("User notification preference updated successfully")
            case .failure:
                self.errorMsg = "Failed to update user notification preference"
            }
        }
    }
    
    func updateUserImage() {
        guard let image = selectedImage, var updatedUser = user else {
            self.errorMsg = "Failed to update user image"
            return
        }
        userRepository.updateUserImage(user: updatedUser, image: image) { result in
            switch result {
            case .success:
                self.fetchUser()
                print("User profile picture updated successfully")
            case .failure(let error):
                self.errorMsg = error.localizedDescription
            }
        }
    }
}
