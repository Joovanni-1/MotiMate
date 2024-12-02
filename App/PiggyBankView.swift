//
//  PiggyBankView.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 30/11/24.
//

import SwiftUI

struct PiggyBankView: View {
    @State private var coinsAdded: Int = 0
    @State private var piggyColor: Color = Color.pink
 
    var body: some View {
        VStack(spacing: 20) {
            Text("Riempimento Salvadanio")
                .font(.title)
                .fontWeight(.bold)
 
            // Salvadanio (porcellino rosa)
            ZStack {
                Image(systemName: "house")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .foregroundColor(piggyColor)
                    .animation(.easeInOut, value: coinsAdded) // Animazione del cambio colore
            }
            // Testo per il numero di monete
            Text("Monete nel salvadanaio: \(coinsAdded)")
                .font(.headline)
 
            // Pulsante per aggiungere monete
            Button(action: {
                addCoin()
            }) {
                Text("Aggiungi Moneta")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
 
    // Funzione per aggiungere una moneta
    private func addCoin() {
        coinsAdded += 1
 
        // Cambiare gradualmente il colore del salvadanaio
        withAnimation {
            piggyColor = Color(
                red: Double(255 - coinsAdded * 10).clamp(0, 255) / 255.0,
                green: Double(182 + coinsAdded * 5).clamp(0, 255) / 255.0,
                blue: Double(193 - coinsAdded * 5).clamp(0, 255) / 255.0
            )
        }
    }
}
 
// Estensione per limitare i valori
extension Double {
    func clamp(_ min: Double, _ max: Double) -> Double {
        return Swift.max(min, Swift.min(max, self))
    }
}
 
// Anteprima
struct PiggyBankView_Previews: PreviewProvider {
    static var previews: some View {
        PiggyBankView()
    }
}


