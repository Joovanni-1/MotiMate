//
//  Risparmio.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 07/12/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct Risparmio: View {
    @State private var goalAmount: Double? = nil // L'importo dell'obiettivo
    @State private var currentSavings: Double = 0 // Il totale dei risparmi accumulati
    @State private var newGoalAmount: String = "" // Input per il nuovo obiettivo
    @State private var savingAmount: String = "" // Input per aggiungere risparmi
    @State private var completedGoals: [(goalAmount: Double, currentSavings: Double)] = [] // Cronologia obiettivi completati
    
    @State private var isNavigatingToHistory = false
    @State private var showGif : Bool
    
    init(showGif: Bool = false) { // Costruttore per la preview
           _showGif = State(initialValue: showGif)
       }


    var body: some View {
        NavigationView {
            ZStack{
                RadialGradient(gradient: Gradient(colors: [.blue,.green, .white]),  center: .bottomLeading, startRadius: 0,endRadius: 1500).edgesIgnoringSafeArea(.all)
                VStack {
                    if goalAmount == nil{ CreateGoalView(newGoalAmount: $newGoalAmount, setGoal: setGoal) }else {
                        // Visualizzazione dell'obiettivo corrente
                        CurrentGoalView(
                            goalAmount: goalAmount!,
                            currentSavings: $currentSavings,
                            savingAmount: $savingAmount,
                            addSavings: addSavings,
                            showGif: $showGif,
                            resetGoal: resetGoal
                        )
                    }
                    Spacer()
                    // Cronologia degli obiettivi completati
                    NavigationLink(destination: HistoryView(completedGoals: $completedGoals), isActive: $isNavigatingToHistory) {
                                        EmptyView()
                                    }
                    Button(action: {
                        isNavigatingToHistory = true
                    }) {
                        Text("Cronologia")
                            .frame(width: 100, height: 20)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.top)
                    .disabled(completedGoals.isEmpty)
                                    
                                    
                }
                .navigationTitle("Risparmio")
                .background(Color.purple.opacity(0.05).edgesIgnoringSafeArea(.all)) // Sfondo dinamico
            }
        }
    }
    
    // Imposta un nuovo obiettivo
    func setGoal() {
        if let amount = Double(newGoalAmount), amount > 0 {
            goalAmount = amount
            currentSavings = 0
            newGoalAmount = ""
        }
    }
    
    // Aggiungi risparmio all'obiettivo corrente
    func addSavings() {
        if let amount = Double(savingAmount), amount > 0 {
            currentSavings += amount // Aggiungi l'importo inserito al totale
            savingAmount = "" // Resetta il campo di input
        }
    }
    
    // Resetta l'obiettivo una volta raggiunto
    func resetGoal() {
        // Aggiungi l'obiettivo completato alla cronologia
        if let completedGoalAmount = goalAmount {
            completedGoals.append((goalAmount: completedGoalAmount, currentSavings: currentSavings))
        }
        
        // Resetta il goal e i risparmi
        goalAmount = nil
        currentSavings = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Risparmio(showGif: false)
    }
}
//MARK: CREA OBIETTIVO
struct CreateGoalView: View {
    @Binding var newGoalAmount: String
    let setGoal: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Crea la tua abitudine di Risparmio")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            TextField("Inserisci somma obiettivo (€)", text: $newGoalAmount)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 10)
            Button(action: setGoal) {
                Text("Imposta Obiettivo")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .disabled(newGoalAmount.isEmpty || Double(newGoalAmount) == nil)
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
// MARK: OBIETTIVO CORRENTE
struct CurrentGoalView: View {
    let goalAmount: Double
    @Binding var currentSavings: Double
    @Binding var savingAmount: String
    let addSavings: () -> Void
    @Binding var showGif: Bool
    let resetGoal: () -> Void

    var body: some View {
        VStack {
            Text("Obiettivo Attuale")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            HStack {
                VStack(spacing: 20) {
                    Text("Obiettivo: ")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text("€\(goalAmount, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text("Risparmiati:")
                        .font(.subheadline)
                    Text("€\(currentSavings, specifier: "%.2f")")
                        .font(.subheadline)
                }
                Spacer()
                Gif(showGif: $showGif)
                    .offset(x: 20)
                    .overlay(Rectangle()
                        
                        .fill(Color.white)
                        .frame(width: 100, height: 50)
                        .offset(x: 40, y: -98)
                    )
            }
            ProgressView(value: currentSavings / goalAmount)
                .padding(.vertical)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
            HStack {
                TextField("Inserisci risparmio (€)", text: $savingAmount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                Button(action: {
                    addSavings()
                    showGif = true
                }) {
                    Text("Aggiungi")
                        .frame(width: 80, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .disabled(savingAmount.isEmpty || Double(savingAmount) == nil)
            }
            .padding(.horizontal)
            if currentSavings >= goalAmount {
                VStack {
                    Text("🎉 Obiettivo Raggiunto! 🎉")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.vertical)
                    Button(action: resetGoal) {
                        Text("Crea Nuovo Obiettivo")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                .padding(.top)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

//MARK: CRONOLOGIA
struct HistoryView: View {
    @Binding var completedGoals: [(goalAmount: Double, currentSavings: Double)]
    
    
    var body: some View {
        VStack {
            Text("Cronologia Obiettivi Completati")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            if completedGoals.isEmpty {
                Text("Non hai ancora completato nessun obiettivo.")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                List(completedGoals, id: \.goalAmount) { goal in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Obiettivo: €\(goal.goalAmount, specifier: "%.2f")")
                                .font(.headline)
                            Text("Risparmiati: €\(goal.currentSavings, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .listStyle(PlainListStyle())
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 10)
        .navigationTitle("Cronologia")
    }
}



struct Gif: View {
    
    @Binding  var showGif : Bool // Stato che determina se la GIF è visibile o meno

                var body: some View {
                    VStack {
                        // Mostra la GIF se showGif è true
                        if showGif {
                            AnimatedImage(name: "piggy-bank.gif") // Usa il nome del tuo file GIF
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .onAppear {
                                    // Nascondi la GIF dopo un breve periodo (ad esempio 2 secondi)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showGif = false
                                    }
                                }
                        } else {
                            // Puoi mostrare un'immagine statica o nulla mentre la GIF non è visibile
                            Image("maialino") // Puoi mostrare un'immagine di fallback
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }

                    }
                    .padding()
                }
}
