//
//  MapView.swift
//  Eventorias
//

import SwiftUI
import MapKit

struct MapView: View {
    var address: String
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), // Valeurs par défaut (Paris)
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var coordinate: CoordinateItem?

    private let geocoder = CLGeocoder()
    
    var body: some View {
        VStack {
            if let coordinate = coordinate {
                Map(coordinateRegion: $region, annotationItems: [coordinate]) { location in
                    MapPin(coordinate: location.coordinate, tint: .red)
                }
                .frame(width: 150, height: 75)
                .onAppear {
                    setRegion(coordinate.coordinate)
                }
                .onTapGesture {
                    print("Carte tapée")
                }
            } else {
                Text("Chargement de l'adresse...")
                    .onAppear {
                        geocodeAddress(address: address)
                    }
            }
        }
    }
    
    private func geocodeAddress(address: String) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Erreur lors de la géolocalisation : \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                let coordinateItem = CoordinateItem(id: UUID(), coordinate: location.coordinate)
                self.coordinate = coordinateItem
                setRegion(location.coordinate)
            } else {
                print("Impossible de trouver un emplacement pour l'adresse donnée.")
            }
        }
    }

    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
}

struct CoordinateItem: Identifiable {
    var id: UUID
    var coordinate: CLLocationCoordinate2D
}
