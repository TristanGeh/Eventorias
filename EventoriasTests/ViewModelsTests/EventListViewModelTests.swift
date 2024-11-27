//
//  EventListViewModelTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class EventListViewModelTests: XCTestCase {
    
    var eventListViewModel: EventListViewModel!
    var mockEventService: MockEventService!
    
    override func setUp() {
        super.setUp()
        mockEventService = MockEventService()
        let mockEventRepository = EventRepository(eventProvider: mockEventService)
        eventListViewModel = EventListViewModel(eventRepository: mockEventRepository)
    }
    
    override func tearDown() {
        eventListViewModel = nil
        mockEventService = nil
        super.tearDown()
    }
    
    // MARK: - Tests for fetchEvents
    
    func testFetchEventsSuccess() {
        // Given
        mockEventService.shouldFail = false
        mockEventService.events = [
            EventRaw(id: "1", title: "Event 1", description: "Description 1", date: "December 12, 2024", time: "10:00 AM", createdBy: "User1", location: "Location 1", imageUrl: "https://mockurl.com/event1.jpg")
        ]
        
        let expectation = self.expectation(description: "Events should be fetched successfully")
        
        // When
        eventListViewModel.fetchEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Then
            XCTAssertEqual(self.eventListViewModel.events.count, 1, "Expected one event to be fetched successfully")
            XCTAssertEqual(self.eventListViewModel.events.first?.title, "Event 1", "Expected event title to be 'Event 1'")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchEventsFailure() {
        // Given
        mockEventService.shouldFail = true
        
        let expectation = self.expectation(description: "Events fetching should fail")
        
        // When
        eventListViewModel.fetchEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then
            XCTAssertEqual(self.eventListViewModel.errorMsg, "Failed to fetch events: Failed to fetch events", "Expected failure message for fetching events")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: - Tests for addEvent
    
    func testAddEventSuccess() {
        // Given
        mockEventService.shouldFail = false
        let title = "Test Event"
        let description = "Event Description"
        let date = Date()
        let time = Date()
        let address = "Test Address"
        
        // Charger l'image de test depuis les assets du projet
        guard let testImage = UIImage(named: "testImage") else {
            XCTFail("Expected testImage to be found in assets")
            return
        }
                
        // When
        eventListViewModel.addEvent(title: title, description: description, date: date, time: time, address: address, image: testImage)
        
        
        // Then
        XCTAssertNil(self.eventListViewModel.errorMsg, "No error message expected for successful addEvent")
    }
    
    func testAddEventFailure() {
        // Given
        mockEventService.shouldFail = true
        let title = "Test Event"
        let description = "Event Description"
        let date = Date()
        let time = Date()
        let address = "Test Address"
        
        // Charger l'image de test depuis les assets du projet
        guard let testImage = UIImage(named: "testImage") else {
            XCTFail("Expected testImage to be found in assets")
            return
        }
        
        let expectation = self.expectation(description: "Adding event should fail")
        
        // When
        eventListViewModel.addEvent(title: title, description: description, date: date, time: time, address: address, image: testImage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Then
            XCTAssertEqual(self.eventListViewModel.errorMsg, "Failed to create event: Failed to add event", "Expected failure message for adding event")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
