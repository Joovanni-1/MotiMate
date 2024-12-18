//
//  AppUITests.swift
//  AppUITests
//
//  Created by Giovanni Gaudiuso on 13/11/24.
//

import XCTest

@testable import MotiMate
 
final class MotiMateTests: XCTestCase {
 
    var abitudiniViewModel: AbitudiniViewModel!
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Initialize the ViewModel before each test
        abitudiniViewModel = AbitudiniViewModel()
        abitudiniViewModel.resetHabitsDone() // Ensure a clean state
    }
 
    override func tearDownWithError() throws {
        abitudiniViewModel = nil // Cleanup
        try super.tearDownWithError()
    }
 
    func testAddHabit() throws {
        // Add a habit
        let daysOfWeek = [true, false, true, false, true, false, false] // MWF
        abitudiniViewModel.aggiungiAbitudine(
            nome: "Test Habit",
            orario: "08:00",
            giorno: Date(),
            giorniSelezionati: daysOfWeek,
            macroAbitudine: "Salute Mentale"
        )
        XCTAssertEqual(abitudiniViewModel.abitudini.count, 1)
        XCTAssertEqual(abitudiniViewModel.abitudini.first?.nome, "Test Habit")
    }
 
    func testCompleteHabit() throws {
        // Add and complete a habit
        let habitId = UUID()
        abitudiniViewModel.abitudini = [
            Abitudine(
                id: habitId,
                nome: "Sample Habit",
                orario: "08:00",
                giorno: Date(),
                completata: false,
                daysOfWeek: [true, true, true, true, true, false, false],
                completamentiGiorni: [false, false, false],
                macroAbitudine: "Salute Mentale"
            )
        ]
 
        let selectedDay = Date()
        abitudiniViewModel.spuntaAbitudine(id: habitId, perGiorno: selectedDay)
        let completedStatus = abitudiniViewModel.abitudini.first?.completamentiDate[selectedDay]
 
        XCTAssertEqual(completedStatus, true)
    }
 
    func testCalculateStreak() throws {
        // Add multiple days of completion and validate streak calculation
        let habitId = UUID()
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
 
        abitudiniViewModel.abitudini = [
            Abitudine(
                id: habitId,
                nome: "Sample Habit",
                orario: "08:00",
                giorno: Date(),
                completata: false,
                daysOfWeek: [true, true, true, true, true, false, false],
                completamentiGiorni: [],
                macroAbitudine: "Salute Mentale"
            )
        ]
        abitudiniViewModel.spuntaAbitudine(id: habitId, perGiorno: yesterday)
        abitudiniViewModel.spuntaAbitudine(id: habitId, perGiorno: today)
        let streak = abitudiniViewModel.calcolaStreakConsecutivo()
        XCTAssertEqual(streak, 2)
    }
}


final class MotiMateUITests: XCTestCase {
 
    func testAddHabitUI() throws {
        let app = XCUIApplication()
        app.launch()
 
        // Navigate to habit creation
        app.buttons["Create Habit"].tap()
 
        // Enter habit details
        let habitNameField = app.textFields["Nome abitudine"]
        habitNameField.tap()
        habitNameField.typeText("Morning Yoga")
 
        app.switches["Reminder"].tap()
        app.buttons["Save"].tap()
 
        // Verify the habit appears in the list
        XCTAssertTrue(app.staticTexts["Morning Yoga"].exists)
    }
}




/*final class AppUITests: XCTestCase {

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
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}*/
