//
//  Settings.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 05/12/24.
//

import SwiftUI
import SwiftUI
import UserNotifications
import SDWebImageSwiftUI

struct Settings: View {
    @State private var isDarkMode: Bool = false
    @State private var showAboutUs: Bool = false
    @State private var showReminderScreen: Bool = false
    @State private var reminders: [Reminder] = []

    var body: some View {
       
           
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                Text("Impostazioni")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 32)
            }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,3)
                // Set Reminder Button
                Button(action: {
                    showReminderScreen.toggle()
                }) {
                    HStack {
                        Image(systemName: "bell")
                        Text("Imposta Notifiche")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.thickMaterial)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .sheet(isPresented: $showReminderScreen) {
                    ReminderView(reminders: $reminders)
                }

                // List of Reminders

                // Theme Toggle
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tema")
                        .font(.headline)
                    Toggle(isOn: $isDarkMode) {
                        Text("Modalità scura")
                    }
                    .onChange(of: isDarkMode) { newValue in
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)

                
                Spacer()
                    .frame(height: 250)
                // Share App Bottone
                Button(action: {
                    shareApp()
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Condividi App")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                // About Us Button
                Button(action: {
                    showAboutUs.toggle()
                }) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Chi siamo")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .alert(isPresented: $showAboutUs) {
                    Alert(
                        title: Text("About Us"),
                        message: Text("We are a team dedicated to helping you build and track your habits for a better life."),
                        dismissButton: .default(Text("Close"))
                    )
                }

                Spacer()
            }
            .padding()
            
        
    }

    
    
    private func shareApp() {
        let appLink = "https://www.yourapp.com"
        let activityVC = UIActivityViewController(activityItems: ["Check out this amazing Habit Tracker app!", appLink], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

struct ReminderView: View {
    @Binding var reminders: [Reminder]
    @State private var notificationName: String = ""
    @State private var notificationTime: Date = Date()
    @State private var showTimePicker: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Notifiche")
                .fontWeight(.bold)
                .font(.system(size: 35))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading, .trailing])

                
            TextField("Titolo della notifica", text: $notificationName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                

            Button(action: {
                showTimePicker.toggle()
            }) {
                HStack {
                    Text(showTimePicker ? "Nascondi orario" : "Imposta orario")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }

            if showTimePicker {
                DatePicker("", selection: $notificationTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
            }

            Button(action: {
                addReminder()
            }) {
                Text("Salva Notifica")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            List {
                ForEach(reminders) { reminder in
                    HStack {
                        Text(reminder.name)
                        Spacer()
                        Text(reminder.time, style: .time)
                    }
                }
                .onDelete(perform: deleteReminderAt)
            }

            Spacer()
        }
        .padding()
        
    }

    private func addReminder() {
        let newReminder = Reminder(name: notificationName.isEmpty ? "Reminder" : notificationName, time: notificationTime)
        reminders.append(newReminder)
        scheduleNotification(for: newReminder)
        notificationName = ""
        showTimePicker = false
    }

    private func deleteReminderAt(indexSet: IndexSet) {
            for index in indexSet {
                let reminder = reminders[index]
                deleteReminder(reminder)
            }
        }
    private func deleteReminder(_ reminder: Reminder) {
           reminders.removeAll { $0.id == reminder.id }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
       }
    private func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = reminder.name
        content.body = "It's time for your habit!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
}

struct Reminder: Identifiable {
    let id = UUID()
    let name: String
    let time: Date
}





#Preview {
    Goals(selected:3)
        .environmentObject(AppVariables())
     .environmentObject(AbitudiniViewModel())
}
