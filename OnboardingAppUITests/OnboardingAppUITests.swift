//
//  OnboardingAppUITests.swift
//  OnboardingAppUITests
//
//  Created by Shotaro Doi on 2024/01/31.
//

import XCTest

final class OnboardingAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginFail() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let emailField = app.textFields["email"]
        let passwordSecureTextField = app.secureTextFields["password"]
        let loginBtn = app.buttons["Login"].staticTexts["Login"]

        emailField.tap()
        emailField.typeText(UUID().uuidString)
        app.typeText("\n")
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        app.typeText("\n")
        loginBtn.tap()

        XCTAssertEqual(app.alerts.element.label, "Server error occured")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
//
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
