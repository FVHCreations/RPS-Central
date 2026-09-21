//
//  RPS_CentralUITests.swift
//  RPS CentralUITests
//
//  Created by Floris van Hengel on 22/09/2026.
//

import XCTest

final class RPS_CentralUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testHubShowsLogoAndOpensFlightLogging() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.images["RootPulse Solutions"].waitForExistence(timeout: 5))
        app.buttons["Flight logging"].tap()
        XCTAssertTrue(app.staticTexts["Preflight checks"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Post-flight logs"].exists)
        XCTAssertTrue(app.staticTexts["Maintenance"].exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
