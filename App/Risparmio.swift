//
//  Risparmio.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 07/12/24.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

struct CompletedGoal: Codable {
    let goalAmount: Double
    let currentSavings: Double
}
struct Risparmio: View {
    @EnvironmentObject var viewModel: RisparmioViewModel
    @State private var newGoalAmount: String = ""
    @State private var savingAmount: String = ""
    @State private var isNavigatingToHistory = false
    @State private var showGif: Bool
    
    init(showGif: Bool = false) { // Costruttore per la preview
        _showGif = State(initialValue: showGif)
    }
    //MARK: STRUTTURA
    var body: some View {
        NavigationView {
            ZStack{
                RadialGradient(gradient: Gradient(colors: [.blue,.green, .white]),  center: .bottomLeading, startRadius: 0,endRadius: 1500).edgesIgnoringSafeArea(.all)
                VStack {
                    if viewModel.goalAmount == nil{ CreateGoalView(newGoalAmount: $viewModel.newGoalAmount, setGoal: viewModel.setGoal) }else {
                        // Visualizzazione dell'obiettivo corrente
                        CurrentGoalView(
                            goalAmount: viewModel.goalAmount!,
                            currentSavings: $viewModel.currentSavings,
                            savingAmount: $viewModel.savingAmount,
                            addSavings: viewModel.addSavings,
                            showGif: $viewModel.showGif,
                            resetGoal: viewModel.resetGoal
                        )
                    }
                    Spacer()
                    // Cronologia degli obiettivi completati
                    NavigationLink(destination: HistoryView(completedGoals: $viewModel.completedGoals), isActive: $viewModel.isNavigatingToHistory) {
                        EmptyView()
                    }
                    Button(action: {
                        viewModel.isNavigatingToHistory = true
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
                    .disabled(viewModel.completedGoals.isEmpty)
                }
                .navigationTitle("Risparmio")
                .background(Color.purple.opacity(0.05).edgesIgnoringSafeArea(.all)) // Sfondo dinamico
            }
        }
    }
}
//MODO ALTERNATIVO PER VEDERE LA PREVIEW SUL CANVA
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Risparmio(showGif: false)
            .environmentObject(RisparmioViewModel())
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
                .multilineTextAlignment(.center)
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
        .background(Color.white.opacity(0.5))
        
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
    @State private var audioPlayer: AVAudioPlayer?
    
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
                    playSound()
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
   
    private func playSound() {
            guard let path = Bundle.main.path(forResource: "coins", ofType: "mp3") else {
                print("File audio non trovato!")
                return
            }
            let url = URL(fileURLWithPath: path)

            do {
                // Inizializza e riproduce l'audio
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Errore durante la riproduzione del suono: \(error.localizedDescription)")
            }
        }
}

//MARK: CRONOLOGIA
struct HistoryView: View {
    @Binding var completedGoals: [CompletedGoal]
    
    
    var body: some View {
        ZStack {
            //Background
            ZStack{
                
                VStack{
                    ForEach(0..<7){_ in
                        HStack(spacing: 30){
                            Text("💰").font(.system(size: 50))
                            Text("💸").font(.system(size: 50))
                            Text("💰").font(.system(size: 50))
                            Text("💸").font(.system(size: 50))
                            Text("💰").font(.system(size: 50))
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        HStack(spacing: 70){
                            Text("💸").font(.system(size: 25))
                            Text("💰").font(.system(size: 25))
                            Text("💸").font(.system(size: 25))
                            Text("💰").font(.system(size: 25))
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                Color.bluino.opacity(0.6)
            }.ignoresSafeArea()
            
        VStack {
            Text("Cronologia Risparmi")
                .font(.largeTitle)
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
                    
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .listStyle(PlainListStyle())
                
                .padding()
                
            }
        }
        
        }
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
