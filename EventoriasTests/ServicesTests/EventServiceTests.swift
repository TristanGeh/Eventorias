//
//  EventServiceTests.swift
//  EventoriasTests
//

import XCTest
@testable import Eventorias

final class EventServiceTests: XCTestCase {
    
    var eventService: EventServiceProtocol!
    var mockEventService: MockEventService!
    var eventListViewModel: EventListViewModel!
    
    override func setUp() {
        super.setUp()
        mockEventService = MockEventService()
        eventService = mockEventService
        eventListViewModel = EventListViewModel(eventService: mockEventService)
    }
    
    override func tearDown() {
        eventService = nil
        mockEventService = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    func testAddEventSuccess() {
        mockEventService.shouldSucceed = true
        let expectation = self.expectation(description: "Add event success")
        
        let newEvent = EventRaw(
            id: UUID().uuidString,
            title: "Test Event",
            description: "Description of test event",
            date: "2024-10-31",
            time: "10:00 AM",
            createdBy: "mockUser",
            location: "123 Test Street",
            imageUrl: "gs://eventorias.appspot.com"
        )
        
        eventService.addEvent(event: newEvent) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testAddEventFailure() {
        mockEventService.shouldSucceed = false
        let expectation = self.expectation(description: "Add event failure")
        
        let newEvent = EventRaw(
            id: UUID().uuidString,
            title: "Test Event",
            description: "Description of test event",
            date: "2024-10-31",
            time: "10:00 AM",
            createdBy: "mockUser",
            location: "123 Test Street",
            imageUrl: "gs://eventorias.appspot.com"
        )
        
        eventService.addEvent(event: newEvent) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Mock add event error")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchEventsSuccess() {
        mockEventService.shouldSucceed = true
        
        let event1 = EventRaw(
            id: UUID().uuidString,
            title: "Event 1",
            description: "Description for event 1",
            date: "2024-10-31",
            time: "10:00 AM",
            createdBy: "mockUser",
            location: "123 Test Street",
            imageUrl: "gs://eventorias.appspot.com"
        )
        
        let event2 = EventRaw(
            id: UUID().uuidString,
            title: "Event 2",
            description: "Description for event 2",
            date: "2024-11-01",
            time: "11:00 AM",
            createdBy: "mockUser2",
            location: "456 Test Avenue",
            imageUrl: "gs://eventorias.appspot.com"
        )
        
        mockEventService.eventsDatabase[event1.id] = event1
        mockEventService.eventsDatabase[event2.id] = event2
        
        let expectation = self.expectation(description: "Fetch events success")
        
        eventService.fetchEvents { result in
            switch result {
            case .success(let events):
                XCTAssertEqual(events.count, 2, "Expected 2 events")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchEventsFailure() {
        mockEventService.shouldSucceed = false
        let expectation = self.expectation(description: "Fetch events failure")
        
        eventService.fetchEvents { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to fetch events")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchUserProfilPictureSuccess() {
        mockEventService.shouldSucceed = true
        let expectation = self.expectation(description: "Fetch user profile picture success")
        
        eventService.fetchUserProfilPicture(forUID: "mockUser") { result in
            switch result {
            case .success(let profilePictureUrl):
                XCTAssertEqual(profilePictureUrl, "gs://eventorias.appspot.com")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchUserProfilPictureFailure() {
        mockEventService.shouldSucceed = false
        let expectation = self.expectation(description: "Fetch user profile picture failure")
        
        eventService.fetchUserProfilPicture(forUID: "mockUser") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to fetch user name")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
