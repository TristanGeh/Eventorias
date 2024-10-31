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
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMsg = "No user is logged in"
            return
        }
        userService.fetchUser(withID: uid) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.convertFirebaseURL(user.profilPicture) { convertedUrl in
                        var updatedUser = user
                        updatedUser.profilPicture = convertedUrl
                        self.user = updatedUser
                        self.nameToEdit = user.name
                        self.emailToEdit = user.email
                        self.notificationEnabled = user.notification
                    }
                case .failure(let error):
                    self.errorMsg = error.localizedDescription
                }
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
        
        userService.updateUserInfo(user: updatedUser) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.user = updatedUser
                    print("User information updated successfully")
                case .failure(let error):
                    self.errorMsg = error.localizedDescription
                }
            }
        }
    }
    
    func updateUserNotificationPreference() {
        guard var updatedUser = user else {
            self.errorMsg = "User not loaded"
            return
        }
        
        updatedUser.notification = notificationEnabled
        
        userService.updateUserNotificationPreference(user: updatedUser, enabled: notificationEnabled) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.user = updatedUser
                    print("User notification preference updated successfully")
                case .failure(let error):
                    self.errorMsg = error.localizedDescription
                }
            }
        }
    }
    
    func updateUserImage() {
        guard let image = selectedImage, var updatedUser = user else {
            self.errorMsg = "User not loaded or no image selected"
            return
        }
        userService.updateUserImage(user: updatedUser, image: image) { result in
            DispatchQueue.main.async {
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
    
    private func convertFirebaseURL(_ gsUrl: String, completion: @escaping (String) -> Void) {
        let storageRef = Storage.storage().reference(forURL: gsUrl)
        storageRef.downloadURL { url, error in
            if let error = error {
                print("Erreur lors de la récupération de l'URL: \(error.localizedDescription)")
                completion("")
            } else if let url = url {
                completion(url.absoluteString)
            }
        }
    }
}
