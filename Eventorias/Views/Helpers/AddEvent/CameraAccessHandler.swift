//
//  CameraAccessHandler.swift
//  Eventorias
//
import AVFoundation
import SwiftUI

class CameraAccessHandler: ObservableObject {
    
    @Published var isCameraAuthorized: Bool = false
    
    func checkCameraAuthorization(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
            
        case .denied, .restricted:
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }
}


