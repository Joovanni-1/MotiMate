//
//  AppTests.swift
//  AppTests
//
//  Created by Giovanni Gaudiuso on 13/11/24.
//
import Testing
import XCTest
@testable import MotiMate
 
struct AppTests {
    @Test func testUserDefaultsPersistence() async throws {
        // Create a test user
        let user = AppVariables()
        user.globalName = "Test"
        user.nickname = "Tester"
        user.sex = "M"
        user.age = 30
 
        // Save to UserDefaults
        user.saveToUserDefaults()
 
        // Retrieve from UserDefaults
        let loadedUser = AppVariables()
        XCTAssertEqual(loadedUser.globalName, "Test")
        XCTAssertEqual(loadedUser.nickname, "Tester")
        XCTAssertEqual(loadedUser.sex, "M")
        XCTAssertEqual(loadedUser.age, 30)
    }
 
    @Test func testAddHabitAndRetrieve() async throws {
        let viewModel = AbitudiniViewModel()
        viewModel.aggiungiAbitudine(
            nome: "Drink Water",
            orario: "07:00",
            giorno: Date(),
            giorniSelezionati: [true, false, true, false, true, false, false],
            macroAbitudine: "Salute Mentale"
        )
        XCTAssertEqual(viewModel.abitudini.count, 1)
        XCTAssertEqual(viewModel.abitudini.first?.nome, "Drink Water")
    }
    @Test func testHabitStreakUpdate() async throws {
        let viewModel = AbitudiniViewModel()
        let habitId = UUID()
        viewModel.abitudini = [
            Abitudine(
             //   id: habitId,
                nome: "Test Habit",
                orario: "09:00",
                giorno: Date(),
                completata: false,
                daysOfWeek: [true, true, true, true, true, false, false],
                completamentiGiorni: [false],
                macroAbitudine: "Salute Mentale"
            )
        ]
        let currentDate = Date()
        viewModel.spuntaAbitudine(id: habitId, perGiorno: currentDate)
        XCTAssertTrue(viewModel.calcolaStreakPerGiorno(giorno: currentDate))
    }
}









/*import Testing
@testable import App

struct AppTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}*/
