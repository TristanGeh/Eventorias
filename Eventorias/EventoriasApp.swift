//
//  EventoriasApp.swift
//  Eventorias
//

import SwiftUI

@main
struct EventoriasApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
