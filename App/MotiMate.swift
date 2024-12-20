//
//  AppApp.swift
//  App
//
//  Created by Giovanni Gaudiuso on 13/11/24.
//

import SwiftUI
import UserNotifications

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
                        .environmentObject(AppVariables())
                     .environmentObject(AbitudiniViewModel())
                     .environmentObject(RisparmioViewModel())
                     .environmentObject(HabitsManager())
                } else {
                    // Mostra la schermata successiva se non è la prima volta
                    Goals(selected:0)
                        .environmentObject(AppVariables())
                     .environmentObject(AbitudiniViewModel())
                     .environmentObject(RisparmioViewModel())
                     .environmentObject(HabitsManager())
                     .onAppear {
                         requestNotificationPermissions()
                     }
                }
            }
        }
    //RICHIEDE IL PERMESSO PER LE NOTIFICHE 
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Errore nella richiesta di autorizzazione: \(error.localizedDescription)")
            } else if granted {
                print("Autorizzazione concessa")
            } else {
                print("Autorizzazione negata")
            }
        }
    }
}

