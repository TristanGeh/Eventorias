//
//  EventListViewModelMock.swift
//  EventoriasTests
//

import Foundation
@testable import Eventorias

class MockEventListViewModel: EventListViewModel {
    init() {
        super.init(eventRepository: MockEventRepository())
    }
}
