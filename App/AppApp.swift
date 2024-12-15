//
//  AppApp.swift
//  App
//
//  Created by Giovanni Gaudiuso on 13/11/24.
//

import SwiftUI

@main
struct AppApp: App {
    @StateObject private var abitudiniViewModel = AbitudiniViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(abitudiniViewModel)
                
                
        }
    }
}
