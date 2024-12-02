//
//  CreateHabitView.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 27/11/24.
//


import SwiftUI
 
struct CreateHabitView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AbitudiniViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var nomeAbitudine: String = ""
    
    
    @State private var orarioAbitudine: Date = Date()
    @State private var giorniSelezionati: [Bool] = Array(repeating: false, count: 7)
    @State private var reminderEnabled: Bool = false
    @State private var reminderTime: Date = Date()
    
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
                                Text("Seleziona i giorni")                                .font(.headline)
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
                            
                           // Aggiunge la nuova abitudine al ViewModel
                            guard !nomeAbitudine.isEmpty else { return }
                            viewModel.aggiungiAbitudine(
                                nome: nomeAbitudine,
                                orario: formattaOrario(_date: orarioAbitudine),
                                giorno: Date(),
                                giorniSelezionati: giorniSelezionati,
                                macroAbitudine: macroAbitudine
                                )
                            presentationMode.wrappedValue.dismiss()
                        },label: {
                            Text("Salva")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        })
                        .padding(.horizontal)
                        
                    }
                    
                    .padding()
                    .navigationTitle("Create a Habit")
                    .navigationBarItems(leading: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }
    
    
    
    
    
    
        }
 
 
 
#Preview {
    CreateHabitView(viewModel: AbitudiniViewModel(), macroAbitudine: "Attività Fisica")
}
