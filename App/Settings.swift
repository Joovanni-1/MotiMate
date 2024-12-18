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
    @EnvironmentObject var variables: AppVariables
    @State private var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    @State private var showAboutUs: Bool = false
    @State private var showReminderScreen: Bool = false
    
    @State private var showGIF = false // Stato per mostrare la GIF
    @State private var displayedMessage = "" // Messaggio visualizzato progressivamente
    @State private var fullMessage: String = UserDefaults.standard.string(forKey: "savedFullMessage") ?? "Guarda il castoro in azione!"
    @State private var reminders: [Reminder] = Reminder.loadFromUserDefaults()
    @State private var buttonEnabled = true // Stato per controllare il bottone
    @State private var hasClicked: Bool = UserDefaults.standard.bool(forKey: "hasClicked") // Stato per il primo clic
    @State private var showSheet = false // Stato per mostrare il foglio modale (sheet)
    @State private var firstTypingEffectDone = false

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
                    if !hasClicked {
                        showGIF = true
                        hasClicked = true
                        saveHasClicked()
                        fullMessage = "\(variables.globalName), sei pronto a fare un altro passo verso il tuo obiettivo?" // Messaggio iniziale
                        typeMessage()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 17.0) {
                            showReminderScreen = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                            showGIF = true
                            fullMessage = "Ogni notifica è li per ricordarti la promessa che hai fatto a te stesso. Non fermarti ora!!"
                            typeMessage()
                            saveMessage()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {showGIF = true}
                        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {showGIF = false}
                    } else {
                        // Nei click successivi, mostra direttamente il foglio modale
                        fullMessage = "Ogni notifica è li per ricordarti la promessa che hai fatto a te stesso. Non fermarti ora!!"
                        
                        showReminderScreen = true
                    }
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

               Button(action: {
                    resetHasClicked()
                }) {
                    Text("Reset HasClicked")
                        
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Castoro
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
                        title: Text("Chi siamo❓"),
                        message: Text("Siamo un team di studenti di ingegneria Informatica che ha come obiettivo quello di motivare gli utenti a sviluppare sane abitudini per condurre una vita più.... "),
                        dismissButton: .default(Text("Close"))
                    )
                }

                Spacer()
            }
            .padding()
            .onAppear{loadMessage()}
        
    }

    var Castoro : some View{
        ZStack {
            HStack {
                ZStack {
                    Image("castoro_static") // Immagine statica iniziale
                        .resizable()
                        .scaledToFit()
                    if showGIF {
                        AnimatedImage(name: "castoro.gif")
                            .resizable()
                            .scaledToFit()
                            
                    }
                    if !displayedMessage.isEmpty {
                        ZStack {
                            Image("rb_115959") // Nuvoletta di fumetto caricata
                                .resizable()
                                .frame(width: 300, height: 200) // Dimensione della nuvoletta
                            Text(displayedMessage) // Testo sopra la nuvoletta
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .padding(.leading,30)
                                .frame(width: 150, height: 200)
                                
                                // Dimensione del testo
                        }
                        .offset(x: 170, y: 10) // Posiziona la nuvoletta sopra il castoro
                    }
                }
                .frame(width: 200, height: 200)
                .padding()
                Spacer()
                    .frame(width: 200)
            }
        }
    }
    
    private func saveDarkModePreference() {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
        private func saveHasClicked() {
            UserDefaults.standard.set(hasClicked, forKey: "hasClicked")
        }
    private func saveMessage() {
        UserDefaults.standard.set(fullMessage, forKey: "savedFullMessage")
        UserDefaults.standard.set(displayedMessage, forKey: "savedDisplayedMessage")
    }
    func loadMessage() {
        fullMessage = UserDefaults.standard.string(forKey: "savedFullMessage") ?? ""
        displayedMessage = UserDefaults.standard.string(forKey: "savedDisplayedMessage") ?? ""
    }
    func typeMessage() {
        displayedMessage = ""
        for (index, char) in fullMessage.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                displayedMessage.append(char)
                saveMessage()
            }
        }
    }
    private func shareApp() {
        let appLink = "https://www.motimate.com"
        let activityVC = UIActivityViewController(activityItems: ["Scarica questa fantastica app per le abitudini", appLink], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
    func resetHasClicked() {
        UserDefaults.standard.removeObject(forKey: "hasClicked") // Rimuove il valore salvato
        hasClicked = false // Aggiorna lo stato locale
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
        Reminder.saveToUserDefaults(reminders)
        notificationName = ""
        showTimePicker = false
    }

    private func deleteReminderAt(indexSet: IndexSet) {
            for index in indexSet {
                let reminder = reminders[index]
                deleteReminder(reminder)
            }
        Reminder.saveToUserDefaults(reminders)
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

struct Reminder: Identifiable, Codable {
    let id = UUID()
    let name: String
    let time: Date
    
    static func loadFromUserDefaults() -> [Reminder] {
        if let data = UserDefaults.standard.data(forKey: "reminders"),
           let reminders = try? JSONDecoder().decode([Reminder].self, from: data) {
            return reminders
        }
        return []
    }
    static func saveToUserDefaults(_ reminders: [Reminder]) {
        if let data = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(data, forKey: "reminders")
        }
    }
}
#Preview {
    Goals(selected:3)
        .environmentObject(AppVariables())
     .environmentObject(AbitudiniViewModel())
     .environmentObject(RisparmioViewModel())
     .environmentObject(HabitsManager())
}
