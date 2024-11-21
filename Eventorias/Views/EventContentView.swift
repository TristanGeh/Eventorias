//
//  EventContentView.swift
//  Eventorias
//

import SwiftUI

struct EventContentView: View {
    @EnvironmentObject var eventListViewModel: EventListViewModel
    
    @State private var viewStyle: ViewStyle = .list
    
    enum ViewStyle: String, CaseIterable {
        case list = "list.bullet"
        case calendar = "calendar"
    }
    
    var body: some View {
        ZStack {
            VStack {
                SearchBarView(searchText: $eventListViewModel.searchText)
                
                Picker("View Style", selection: $viewStyle) {
                    ForEach(ViewStyle.allCases, id: \.self) { style in
                            Image(systemName: style.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if viewStyle == .list {
                    ScrollView {
                        EventListView()
                            .environmentObject(eventListViewModel)
                    }
                } else if viewStyle == .calendar {
                    ScrollView {
                        CalendarView()
                            .environmentObject(eventListViewModel)
                    }
                }
                
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                        NavigationLink {
                            AddEventView()
                                .environmentObject(eventListViewModel)
                        } label: {
                            AddEventButtonView()
                                .padding()
                        }
                }
            }
        }
        .onAppear {
            eventListViewModel.fetchEvents()
        }
    }
}

#Preview {
    let viewModel = EventListViewModel()
    EventContentView()
        .environmentObject(viewModel)
}
