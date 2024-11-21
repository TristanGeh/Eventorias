//
//  ImageButtonsView.swift
//  Eventorias
//

import SwiftUI

struct ImageButtonsView: View {
    @Binding var showImagePicker: Bool
    @Binding var useCamera: Bool
    @ObservedObject var cameraHandler: CameraAccessHandler
    
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                cameraHandler.checkCameraAuthorization { authorized in
                    if authorized {
                        useCamera = true
                        showImagePicker = true
                    } else {
                        showImagePicker = false
                    }
                }
            } label: {
                Image(systemName: "camera")
                    .foregroundColor(.black)
                    .frame(width: 52, height: 52)
                    .background(.white)
                    .cornerRadius(10)
                
            }
            
            Button {
                useCamera = false
                showImagePicker = true
            } label: {
                Image(systemName: "folder")
                    .foregroundColor(.white)
                    .frame(width: 52, height: 52)
                    .background(Color("MainRed"))
                    .cornerRadius(10)
            }
            
            
        }
    }
}
