//
//  Home.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 22/11/24.
//

import SwiftUI

struct Home: View {
   //MARK: VARIABILI
    @EnvironmentObject var variables: AppVariables
    @Binding var showTabView: Bool
    @EnvironmentObject var viewModel: AbitudiniViewModel
    @EnvironmentObject var viewModel1: RisparmioViewModel
    @EnvironmentObject var habitsManager: HabitsManager
    @State var newHabit: String = ""
    @State var isAddingNewHabit: Bool = false
    @State var page1: Bool = false
    @State private var showHelp = false
    
    //MARK: STRUTTURA HOME
    var body: some View {
            ScrollView{
                
                VStack(alignment: .leading, spacing: 1) {
                    HStack{
                        Button(action: {  showHelp.toggle()}) {
                            Image(systemName: "questionmark.circle")
                                .font(.title)
                            .foregroundColor(.blue)}
                        
                        Spacer()
                        
                        Button(action:{
                            isAddingNewHabit.toggle()
                        },label:{ Image(systemName:"plus")
                                .accentColor(.white)
                                .bold()
                        })
                        .frame(width:40,height:40)
                        .background(Color.moss)
                        .cornerRadius(50)
                        .shadow(radius: 5)
                        .overlay(Circle().stroke(Color.black,lineWidth:0.5))
                        .padding(.trailing)
                    }
                    Text("Benvenuto:\(variables.nickname)")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 32)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .fullScreenCover(isPresented: $showHelp) {
                    InfoScreen()
                }
                
                
                if isAddingNewHabit {
                    TextField("Inserisci nuova abitudine", text: $newHabit)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    
                    Button(action: {
                        // Aggiungi la nuova abitudine in coda alla lista
                        if !newHabit.isEmpty {
                            habitsManager.addHabit(newHabit)
                            newHabit = "" // Reset del campo di testo
                            isAddingNewHabit = false // Nascondi il campo di inserimento
                        }
                    }, label: {
                        Text("Aggiungi")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.moss)
                            .cornerRadius(10)
                    })
                    .padding(.horizontal)
                    Button(action: {
                        // Annulla l'inserimento della nuova abitudine
                        newHabit = ""
                        isAddingNewHabit = false
                    }, label: {
                        Text("Annulla")
                            .foregroundColor(.red)
                    })
                    .padding(.horizontal)
                }
//Iterazione macroabitudine
                ForEach (habitsManager.habits, id:\.self){ habit in
                    
                    NavigationLink(destination: destinationView(for: habit)
                        .onAppear {
                            showTabView = false // Nascondi TabView
                            viewModel.resetGiornoSelezionato()
                        }
                        .onDisappear {
                            showTabView = true // Mostra TabView al ritorno
                        }, label: {
                            
                            RoundedRectangle(cornerRadius:20)
                                .fill(Color.moss)
                                .stroke(Color.black, lineWidth:2)
                                .overlay(
                                    HStack{
                                        Spacer()
                                        
                                        VStack{
                                            ZStack {
                                                if habit == "Risparmio" {
                                                    ZStack{ Image("new")
                                                            .resizable()
                                                            .scaledToFit()
                                                    }.frame(width: 100)
                                                        .offset(x:-100, y:-74 )
                                                }
                                                Text(habit)
                                                    .font(.system(size: 26))
                                                    .bold()
                                            }
                                        }
                                        
                                        Spacer()
                                        if habit == "Risparmio" { VStack {
                                            Text("€\(viewModel1.currentSavings, specifier: "%.2f") / €\(viewModel1.goalAmount ?? 0, specifier: "%.2f")")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            ProgressView(value: viewModel1.goalAmount != nil ? viewModel1.currentSavings / viewModel1.goalAmount! : 0)
                                                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                                .frame(width: 100)
                                        }.padding([.trailing])
                                            
                                        }else{
                                            let progress = viewModel.progressForCategory(habit, forDay: viewModel.giornoCorrente)
                                            SVGtoSwiftUIView(divisions: progress.totale, completation: progress.completate)
                                            
                                        }
                                    })
                                .frame(maxWidth:.infinity)
                                .frame(height:180)
                                .padding([.leading, .trailing], 9)
                        }
                    )
                }
            }
    }
    
    @ViewBuilder
    func destinationView(for habit: String) -> some View {
        switch habit {
        case "Risparmio":
            Risparmio()
        default:
            HabitView(macroAbitudine: habit)// Passa il nome della macroabitudine
        }
    
    }
   
}
struct SVGtoSwiftUIView: View {
    var divisions: Int  // Numero di divisioni del cerchio
    var completation: Int
        var body: some View {
            ZStack {
                // Cerchio principale
                Circle()
                    .strokeBorder(Color.white, lineWidth: 13)
                    .frame(width: 110, height: 110)

                // Divisioni del cerchio
                ForEach(0..<divisions) { index in
                    Path { path in
                        let angle = Angle.degrees(Double(index) * (360.0 / Double(divisions)))
                        let radius: CGFloat = 66.5 // Raggio del cerchio
                        let startX = 93 + cos(angle.radians) * radius
                        let startY = 93 + sin(angle.radians) * radius
                        path.move(to: CGPoint(x: 93, y: 93)) // Centro
                        path.addLine(to: CGPoint(x: startX, y: startY))
                    }
                    .stroke(Color.moss, lineWidth: 8)
                    .overlay(Text("\(completation) / \(divisions)")
                        .font(.system(size: 20))
                        .bold()
                    )
                }
            }
            .frame(width: 186, height: 186)
        }
    }



#Preview {
    Goals(selected:0)
        .environmentObject(AppVariables())
     .environmentObject(AbitudiniViewModel())
     .environmentObject(RisparmioViewModel())
     .environmentObject(HabitsManager())
    
}


#Preview {
    
    InfoScreen()
}
struct InfoScreen: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            VStack {
                Button(action: {
                    dismiss() // Torna alla schermata precedente
                }, label: {
                    Text("Indietro")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(height: 20)
                        
                        .background(Color.white)
                        .cornerRadius(10)
                })
                
            }.offset(x:-140,y: 0)
            VStack(alignment: .leading, spacing: 20) {
                
                // Titolo
                Text("Come funziona MotiMate?")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)

                // Sezione "Funzionalità"
                sezioneFunzionalita

                Divider().padding(.vertical)

                // Sezione "Consigli"
                sezioneConsigli

                Divider().padding(.vertical)

                // Sezione "Esempi pratici"
                sezioneEsempiPratici
            }
            .padding()
        }
        
    }

    var sezioneFunzionalita: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Funzionalità principali")
                .font(.title2)
                .bold()
            funzioneRiga(
                icona: "plus.circle",
                titolo: "Crea abitudini personalizzate",
                descrizione: "Aggiungi abitudini scegliendo nome, orario e giorni."
            )
            funzioneRiga(
                icona: "chart.bar.fill",
                titolo: "Monitora i progressi",
                descrizione: "Controlla il tuo avanzamento con grafici e statistiche."
            )
            funzioneRiga(
                icona: "star.fill",
                titolo: "Ottieni premi motivazionali",
                descrizione: "Celebra i tuoi successi con notifiche e animazioni."
            )
        }
    }

    var sezioneConsigli: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Consigli per iniziare")
                .font(.title2)
                .bold()
            consiglioRiga(
                titolo: "Inizia con pochi obiettivi",
                descrizione: "Non sovraccaricarti. Concentrati su 1-2 abitudini alla volta."
            )
            consiglioRiga(
                titolo: "Fai piccoli passi",
                descrizione: "Anche 5 minuti al giorno possono fare la differenza."
            )
            consiglioRiga(
                titolo: "Premiati per i progressi",
                descrizione: "Datti una piccola ricompensa per mantenere alta la motivazione."
            )
            consiglioRiga(
                titolo: "Non abbatterti per un errore",
                descrizione: "Un giorno saltato non compromette il tuo successo."
            )
        }
    }

    var sezioneEsempiPratici: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Esempi pratici")
                .font(.title2)
                .bold()
            esempioRiga(
                titolo: "Obiettivo: Fare attività fisica",
                descrizione: "Inizia con 10 minuti al giorno, 3 volte a settimana."
            )
            esempioRiga(
                titolo: "Obiettivo: Migliorare la concentrazione",
                descrizione: "Dedica 5 minuti alla meditazione prima di iniziare a lavorare."
            )
            esempioRiga(
                titolo: "Obiettivo: Bere più acqua",
                descrizione: "Usa un promemoria ogni 2 ore per ricordarti di bere."
            )
        }
    }

    func funzioneRiga(icona: String, titolo: String, descrizione: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icona)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(titolo)
                    .font(.headline)
                Text(descrizione)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

    func consiglioRiga(titolo: String, descrizione: String) -> some View {
        VStack(alignment: .leading) {
            Text(titolo)
                .font(.headline)
            Text(descrizione)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }

    func esempioRiga(titolo: String, descrizione: String) -> some View {
        VStack(alignment: .leading) {
            Text(titolo)
                .font(.headline)
            Text(descrizione)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
