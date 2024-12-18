//
//  AppApp.swift
//  App
//
//  Created by Giovanni Gaudiuso on 13/11/24.
//

import SwiftUI

@main
struct MotiMate: App {
        @StateObject private var abitudiniViewModel = AbitudiniViewModel()
    @StateObject private var risparmioViewModel = RisparmioViewModel()
        // Flag per verificare se è la prima apertura
        @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
        var body: some Scene {
            WindowGroup {
                
                
                if UserDefaultsManager.shared.isFirstLaunch() {
                    // Mostra ContentView solo la prima volta
                    ContentView()
                        .environmentObject(abitudiniViewModel)
                        .environmentObject(RisparmioViewModel())
                } else {
                    // Mostra la schermata successiva se non è la prima volta
                    Goals(selected:0)
                        .environmentObject(AppVariables())
                     .environmentObject(AbitudiniViewModel())
                     .environmentObject(RisparmioViewModel())
                }
            }
        }
    }

