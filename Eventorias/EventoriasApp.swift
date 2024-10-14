//
//  EventoriasApp.swift
//  Eventorias
//
//  Created by Tristan Géhanne on 14/10/2024.
//

import SwiftUI
import Firebase

@main
struct EventoriasApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
