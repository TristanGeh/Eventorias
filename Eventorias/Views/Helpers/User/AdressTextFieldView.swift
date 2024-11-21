//
//  AdressTextFieldView.swift
//  Eventorias
//

import SwiftUI
import MapKit
import UIKit

struct AddressTextFieldView: View {
    @Binding var address: String
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var completer = MKLocalSearchCompleter()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Address")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            TextField("", text: $address)
                .onChange(of: address) { newValue in
                    completer.queryFragment = newValue
                }
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color("SecondColor"))
                .cornerRadius(5)
            
            List(searchResults, id: \.title) { result in
                Text(result.title)
                    .onTapGesture {
                        address = result.title
                        searchResults = []
                    }
            }
        }
        .onAppear {
            completer.delegate = AddressCompletionDelegate(searchResults: $searchResults)
        }
    }
}


class AddressCompletionDelegate: NSObject, MKLocalSearchCompleterDelegate {
    @Binding var searchResults: [MKLocalSearchCompletion]
    
    init(searchResults: Binding<[MKLocalSearchCompletion]>) {
        _searchResults = searchResults
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}

