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
        eventListViewModel = EventListViewModel(eventService: mockEventService)
    }

    override func tearDown() {
        eventListViewModel = nil
        mockEventService = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testFetchEventsSuccess() {
        mockEventService.shouldSucceed = true
        let expectation = self.expectation(description: "Fetch events success")

        eventListViewModel.fetchEvents()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.eventListViewModel.events.isEmpty)
            XCTAssertNil(self.eventListViewModel.errorMsg)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testFetchEventsFailure() {
        mockEventService.shouldSucceed = false
        let expectation = self.expectation(description: "Fetch events failure")

        eventListViewModel.fetchEvents()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.eventListViewModel.events.isEmpty)
            XCTAssertNotNil(self.eventListViewModel.errorMsg)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testAddEventSuccess() {
        mockEventService.shouldSucceed = true
        let expectation = self.expectation(description: "Add event success")

        let newEventRaw = EventRaw(
            id: "1",
            title: "Test Event",
            description: "This is a test event",
            date: "October 31, 2024",
            time: "10:00 AM",
            createdBy: "mockUser",
            location: "Test Location",
            imageUrl: "testImageUrl"
        )

        eventListViewModel.addEvent(event: newEventRaw)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.eventListViewModel.events.isEmpty)
            XCTAssertNil(self.eventListViewModel.errorMsg)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testAddEventFailure() {
        mockEventService.shouldSucceed = false
        let expectation = self.expectation(description: "Add event failure")

        let newEventRaw = EventRaw(
            id: "1",
            title: "Test Event",
            description: "This is a test event",
            date: "October 31, 2024",
            time: "10:00 AM",
            createdBy: "mockUser",
            location: "Test Location",
            imageUrl: "testImageUrl"
        )

        eventListViewModel.addEvent(event: newEventRaw)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.eventListViewModel.events.isEmpty)
            XCTAssertNotNil(self.eventListViewModel.errorMsg)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUploadImageSuccess() {
        mockEventService.shouldSucceed = true
        let expectation = self.expectation(description: "Upload image success")
        let image = UIImage(named: "testImage")!

        eventListViewModel.uploadImage(image: image) { result in
            switch result {
            case .success(let imageUrl):
                XCTAssertFalse(imageUrl.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }

        waitForExpectations(timeout: 1.0)
    }

    func testUploadImageFailure() {
        mockEventService.shouldSucceed = false
        let expectation = self.expectation(description: "Upload image failure")
        let image = UIImage(named: "testImage")!

        eventListViewModel.uploadImage(image: image) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1.0)
    }
}

