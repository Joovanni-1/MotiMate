//
//  CreateHabitView.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 27/11/24.
//


import SwiftUI
//import UserNotifications
 
struct CreateHabitView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AbitudiniViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var nomeAbitudine: String = ""
    
    
    @State private var orarioAbitudine: Date = Date()
    @State private var giorniSelezionati: [Bool] = Array(repeating: false, count: 7)
    @State private var reminderEnabled: Bool = false
    @State private var reminderTime: Date = Date()
    @State private var showAlert: Bool = false
    private var isFormValid: Bool {!nomeAbitudine.isEmpty && giorniSelezionati.contains(true) && reminderEnabled}
    var macroAbitudine: String
    
    func formattaOrario(_date: Date)-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: _date )
    }

    
    
    var body: some View {
        NavigationView {
                    VStack(spacing: 20) {
                        TextField("Nome abitudine", text: $nomeAbitudine)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                           
                        HStack {
                            Button(action: {
                                // Placeholder for an action (e.g., add icon)
                            }) {
                                Image(systemName: "bell")
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                            Button(action: {
                                // Placeholder for an action (e.g., pick color)
                            }) {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding(.horizontal)
                        VStack( spacing: 10) {
                            HStack {
                                Text("Seleziona i giorni")            .font(.headline)
                                Spacer()
                            }
                        
                            HStack(spacing: 10) {
                                ForEach(0..<Constants.giorniSettimana.count, id: \.self) { index in
                                    Button(action: {
                                        giorniSelezionati[index].toggle()
                                    },label: {
                                        Text(Constants.giorniSettimana[index])
                                            .frame(width: 42, height: 42)
                                            .background(giorniSelezionati[index] ? Color.blue : Color(UIColor.systemGray6))
                                            .foregroundColor(giorniSelezionati[index] ? .white : .black)
                                            .cornerRadius(16)
                                    })
                                }
                            }
                        }
                        // da modificare!!!
                        
                        
                        Toggle(isOn: $reminderEnabled) {
                            Text("Ricordami alle ore : ")
                                .font(.headline)
                        }
                        .padding()
                        if reminderEnabled {
                            DatePicker("Reminder Time", selection: $orarioAbitudine, displayedComponents: .hourAndMinute)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                        }
                        Spacer()
                        Button(action: {
                            
                            
                            // Se ha compilato tutti i campi aggiunge la nuova abitudine al ViewModel
                            if isFormValid {
                                viewModel.aggiungiAbitudine(
                                    nome: nomeAbitudine,
                                    orario: formattaOrario(_date: orarioAbitudine),
                                    giorno: Date(),
                                    giorniSelezionati: giorniSelezionati,
                                    macroAbitudine: macroAbitudine
                                )
                                
                                //scheduleNotification()
                                presentationMode.wrappedValue.dismiss()
                            }else{
                                showAlert = true
                            }},label: {
                            Text("Salva")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        })
                        .padding(.horizontal)
                        .alert(isPresented: $showAlert){
                            Alert( title: Text("Per favore, assicurati di aver compilato tutti i dati!"),  message: Text(""), dismissButton: .default(Text("OK")))}
                        
                    }
                    
                    .padding()
                    .navigationTitle("Crea un'abitudine")
                    .navigationBarItems(leading: Button("Annulla") {
                        presentationMode.wrappedValue.dismiss()
                    })
                    //.onAppear {requestNotificationPermission() // Richiede l'autorizzazione per le notifiche}
                }
            }
    
    
    
    //MARK: FUNZIONI
    // Funzione per programmare la notifica
     /*   func scheduleNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Promemoria Abitudine"
            content.body = "È ora di completare l'abitudine: \(nomeAbitudine)"
            content.sound = UNNotificationSound.default
            
            // Configura il trigger della notifica
            let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            
            // Crea la richiesta di notifica
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // Aggiungi la notifica al centro notifiche
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Errore nell'aggiunta della notifica: \(error.localizedDescription)")
                } else {
                    print("Notifica programmata con successo")
                }
            }
        }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Errore nella richiesta di autorizzazione: \(error.localizedDescription)")
            } else {
                print("Autorizzazione concessa: \(granted)")
            }
        }
    }*/
    
        }
 
 
 
#Preview {
    CreateHabitView(viewModel: AbitudiniViewModel(), macroAbitudine: "Attività Fisica")
}
