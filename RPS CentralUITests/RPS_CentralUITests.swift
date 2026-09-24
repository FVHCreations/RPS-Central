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
    func testLoginFormAppearsOnLaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITestingSignedOut"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Sign in"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.textFields["Email"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        XCTAssertTrue(app.buttons["Sign in"].exists)
        XCTAssertFalse(app.buttons["Flight logging"].exists)
    }

    @MainActor
    func testHubShowsLogoAndOpensFlightLogging() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITestingSignedIn"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Welcome Pilot"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["pilot@rootpulse.example"].exists)
        XCTAssertTrue(app.buttons["Account menu"].exists)
        XCTAssertFalse(app.buttons["Sign out"].exists)
        app.buttons["Flight logging"].tap()

        let preflight = app.descendants(matching: .any)["Preflight checks"]
        XCTAssertTrue(preflight.waitForExistence(timeout: 5))
        XCTAssertTrue(app.descendants(matching: .any)["Post-flight logs"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["Maintenance"].exists)
    }

    @MainActor
    func testAccountMenuShowsSettingsAndSignsOut() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITestingSignedIn"]
        app.launch()

        app.buttons["Account menu"].tap()
        XCTAssertTrue(app.images["RootPulse Solutions"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.textFields["Display name"].exists)
        XCTAssertTrue(app.buttons["Save"].exists)
        XCTAssertTrue(app.buttons["Sign out"].exists)
        XCTAssertTrue(app.staticTexts["pilot@rootpulse.example"].exists)

        app.buttons["Sign out"].tap()
        XCTAssertTrue(app.staticTexts["Sign in"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
