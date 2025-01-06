//
//  SwiftUIView.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 06/01/25.
//

import SwiftUI

struct SfideView: View {
    @StateObject private var sfideManager = SfideManager() // Utilizzo della classe SfideManager
    @State private var nuovaSfida: String = ""
    @State private var giorniSfida: String = ""
    @State private var showAlert = false
    @State private var mostraSfideCompletate = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color("bluino"), Color("moss")], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text("Challenge")
                        .font(.title)
                        .bold()

                    // Campo per aggiungere nuove sfide
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("Inserisci una nuova sfida", text: $nuovaSfida)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            TextField("Giorni da conseguire", text: $giorniSfida)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)

                        Button(action: aggiungiSfida) {
                            Text("Aggiungi")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.trailing)
                    }
                    .frame(width: 390, height: 110)
                    .background(Color.blue.opacity(0.5))
                    .cornerRadius(20)

                    // Elenco sfide
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(sfideManager.sfide) { sfida in
                                SfidaRow(sfida: sfida, completaGiorno: completaGiorno, eliminaSfida: eliminaSfida)
                            }
                        }
                        .padding()
                    }

                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { mostraSfideCompletate = true }) {
                            Text("Completate")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .sheet(isPresented: $mostraSfideCompletate) {
                    SfideCompletateView(sfideCompletate: sfideManager.sfideCompletate)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Errore"),
                        message: Text("Inserisci un nome valido e un numero di giorni per la sfida"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }

     func aggiungiSfida() {
        guard
            !nuovaSfida.isEmpty,
            let giorni = Int(giorniSfida),
            giorni > 0
        else {
            showAlert = true
            return
        }

        let nuova = Sfida(nome: nuovaSfida, giorniTotali: giorni, giorniCompletati: 0)
        sfideManager.sfide.append(nuova)
        nuovaSfida = ""
        giorniSfida = ""
    }

    func completaGiorno(_ id: UUID) {
        if let index = sfideManager.sfide.firstIndex(where: { $0.id == id }) {
            sfideManager.sfide[index].giorniCompletati += 1

            // Se la sfida è completata, spostala in "sfide completate"
            if sfideManager.sfide[index].giorniCompletati >= sfideManager.sfide[index].giorniTotali {
                let completata = sfideManager.sfide.remove(at: index)
                sfideManager.sfideCompletate.append(completata)
            }
        }
    }

     func eliminaSfida(_ id: UUID) {
        sfideManager.sfide.removeAll { $0.id == id }
    }
}


struct Sfida: Identifiable , Codable {
    let id = UUID()
    var nome: String
    var giorniTotali: Int
    var giorniCompletati: Int
}

struct SfidaRow: View {
    var sfida: Sfida
    var completaGiorno: (UUID) -> Void
    var eliminaSfida: (UUID) -> Void

    var body: some View {
        HStack {
            // Nome della sfida e giorni completati
            VStack(alignment: .leading) {
                Text(sfida.nome)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("Giorni completati: \(sfida.giorniCompletati) / \(sfida.giorniTotali)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Pulsante "Completa un giorno"
            Button(action: { completaGiorno(sfida.id) }) {
                Text("Completa giorno")
                    .padding(8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Pulsante "Elimina"
            Button(action: { eliminaSfida(sfida.id) }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.system(size: 20))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct SfideCompletateView: View {
    var sfideCompletate: [Sfida]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sfide Completate")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(sfideCompletate) { sfida in
                            HStack {
                                Text(sfida.nome)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Spacer()

                                Text("\(sfida.giorniTotali) giorni")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding()
                }

                Spacer()
            }
           
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Chiudi") {
                        if let root = UIApplication.shared.windows.first?.rootViewController {
                            root.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Goals(selected:2)
        .environmentObject(AppVariables())
     .environmentObject(AbitudiniViewModel())
     .environmentObject(RisparmioViewModel())
     .environmentObject(HabitsManager())
     
}



