//
//  EventRepsitoryTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class EventRepsitoryTests: XCTestCase {
    
    var eventRepository: EventRepository!
    var mockEventService: MockEventService!
    
    override func setUp() {
        super.setUp()
        mockEventService = MockEventService()
        eventRepository = EventRepository(eventProvider: mockEventService)
    }
    
    override func tearDown() {
        eventRepository = nil
        mockEventService = nil
        super.tearDown()
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
        let image = UIImage()
        
        // When
        eventRepository.addEvent(title: title, description: description, date: date, time: time, address: address, image: image) { result in
            // Then
            switch result {
            case .success:
                XCTAssertEqual(self.mockEventService.events.count, 1, "Expected one event to be added successfully")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
    }
    
    func testAddEventFailure() {
        // Given
        mockEventService.shouldFail = true
        let title = "Test Event"
        let description = "Event Description"
        let date = Date()
        let time = Date()
        let address = "Test Address"
        let image = UIImage()
        
        // When
        eventRepository.addEvent(title: title, description: description, date: date, time: time, address: address, image: image) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to add event", "Expected failure message for adding event")
            }
        }
    }
    
    // MARK: - Tests for fetchEvents
    
    func testFetchEventsSuccess() {
        // Given
        mockEventService.shouldFail = false
        mockEventService.events = [
            EventRaw(id: "1", title: "Event 1", description: "Description 1", date: "December 12, 2024", time: "10:00 AM", createdBy: "User1", location: "Location 1", imageUrl: "https://mockurl.com/event1.jpg")
        ]
        
        // When
        eventRepository.fetchEvents { result in
            // Then
            switch result {
            case .success(let events):
                XCTAssertEqual(events.count, 1, "Expected one event to be fetched successfully")
                XCTAssertEqual(events.first?.title, "Event 1", "Expected event title to be 'Event 1'")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
    }
    
    func testFetchEventsFailure() {
        // Given
        mockEventService.shouldFail = true
        
        // When
        eventRepository.fetchEvents { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to fetch events", "Expected failure message for fetching events")
            }
        }
    }
    
    // MARK: - Tests for convertFirebaseURL
    
    func testConvertFirebaseURLSuccess() {
        // Given
        mockEventService.shouldFail = false
        let gsUrl = "gs://mockbucket/path/to/resource"
        
        // When
        eventRepository.convertFirebaseURL(gsUrl) { convertedUrl in
            // Then
            XCTAssertEqual(convertedUrl, "https://mockurl.com/convertedurl.jpg", "Expected URL to be converted successfully")
        }
    }
    
    func testConvertFirebaseURLFailure() {
        // Given
        mockEventService.shouldFail = true
        let gsUrl = "gs://mockbucket/path/to/resource"
        
        // When
        eventRepository.convertFirebaseURL(gsUrl) { convertedUrl in
            // Then
            XCTAssertEqual(convertedUrl, "", "Expected empty URL on failure")
        }
    }
}
