//
//  GeoQuebecUnitTests.swift
//  GeoQuebecTests
//
//  Created by Eric Chandonnet on 2023-10-15.
//

import XCTest
@testable import GeoQuebec

final class when_loading_viewmodel: XCTestCase {
    
    func test_should_load_areas_correctly() {
        let viewModel = ViewModel()
        let expectation = XCTestExpectation()
        
        DispatchQueue.main.async {
            XCTAssertGreaterThan(viewModel.areas.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

final class when_playing_game: XCTestCase {

    func test_should_add_choice_correctly() {
        let viewModel = ViewModel()
        let expectation = XCTestExpectation()
        let testUuid = UUID()
        
        DispatchQueue.main.async {
            viewModel.addChoice(areaId: 2, answerId: testUuid)
            XCTAssertEqual(viewModel.choices.count, 1)
            XCTAssertEqual(viewModel.choices[2], testUuid)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func test_should_remove_choice_correctly() {
        let viewModel = ViewModel()
        let expectation = XCTestExpectation()
        let testUuid = UUID()
        
        DispatchQueue.main.async {
            viewModel.addChoice(areaId: 2, answerId: testUuid)
            XCTAssertEqual(viewModel.choices.count, 1)
            viewModel.removeChoice(areaId: 2)
            XCTAssertEqual(viewModel.choices.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
