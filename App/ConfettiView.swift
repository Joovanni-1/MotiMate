//
//  ConfettiView.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 17/12/24.
//

import SwiftUI
import AVFoundation
 
struct ConfettiView: View {
    @State private var showConfetti = false
    @State private var player: AVAudioPlayer?
 
    var body: some View {
        ZStack {
            Color.ocean.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
 
            
            ZStack {
                
                VStack {
                    Spacer()
                    
                    Text("Ben fatto! Hai completato tutte le attività previste per oggi 🥳🥳🥳")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                }
            }
 
            if showConfetti {
                ConfettiEffect()
                
                    .ignoresSafeArea()
            }
        }
        .onAppear(perform: startCelebration)
    }
 
    func startCelebration() {
        showConfetti = true
        playSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            showConfetti = false
        }
    }
 
    func playSound() {
        if let url = Bundle.main.url(forResource: "cheers", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("Error loading sound: \(error)")
            }
        }
    }
}
 
struct ConfettiEffect: View {
    @State private var particles: [Particle] = []
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 3)) {
                    generateParticles(in: geometry.size)
                }
            }
        }
    }
 
    func generateParticles(in size: CGSize) {
        for _ in 0..<200 {
            let particle = Particle(
                id: UUID(),
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height / 2)
                ),
                color: Color(
                    hue: Double.random(in: 0...1),
                    saturation: 1,
                    brightness: 1
                ),
                size: CGFloat.random(in: 5...10),
                opacity: Double.random(in: 0.5...1.0)
            )
            particles.append(particle)
        }
    }
}
 
struct Particle: Identifiable {
    let id: UUID
    var position: CGPoint
    var color: Color
    var size: CGFloat
    var opacity: Double
}
#Preview{
    ConfettiView()
    
}

#Preview{
    RandomPhraseView()
    
}

struct RandomPhraseView: View {
    // Vettore di frasi
   
    @State private var phrases: [String] = [
        "La costanza è ciò che trasforma le azioni quotidiane in risultati straordinari", "Un piccolo miglioramento ogni giorno porta a grandi risultati nel tempo", "Non si tratta di essere  perfetti, ma di essere migliori di ieri", "Le abitudini sane non sono un sacrificio, ma un investimento in te stesso", "Ogni scelta che fai oggi crea la persona che sarai domani", "Il segreto del tuo futuro si nasconde nella tua routine quotidiana", "Non aspettare di sentirti motivato; inizia e la motivazione arriverà", "La disciplina è la madre di tutte le abitudini sane", "Anche il più lungo dei viaggi inizia con un passo. Fai quel passo ogni giorno", "L'equilibrio non si raggiunge, si costruisce un'azione alla volta", "Non fermarti quando sei stanco, fermati quando hai finito", "Ogni piccolo passo che fai oggi ti porta più vicino al tuo obiettivo", " Credi in te stesso: sei più forte di quanto pensi e più capace di quanto immagini", "Il successo è la somma dei piccoli sforzi ripetuti giorno dopo giorno", "Non guardare quanto è lontana la meta, concentrati sul prossimo passo", "Le grandi cose richiedono tempo. Continua, il tuo impegno sarà ripagato", "Chi non si arrende non perde mai", "La disciplina è il ponte tra i tuoi obiettivi e i tuoi risultati", "Oggi è un'opportunità per essere migliore di ieri", "Se credi in te stesso, nulla è impossibile"
    ]
    // Stato per la frase attuale
    
    @State private var showFrase = false
    @State private var currentPhrase: String = ""

        var body: some View {
            ZStack {
                Color.clear .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    Spacer()
                   
                        
                        ZStack{
                            Image( "spunta")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .shadow(radius: 10)
                        }.offset(x: -130, y: 90)
                        
                        ZStack{ Image("Completata")
                            
                                .resizable()
                                .scaledToFill()
                                .frame(width: 400, height: 300)
                                .shadow(radius: 10)
                        }
                    
                    ZStack{
                        
                        Rectangle().frame(width: 370, height: 150)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                        Text(currentPhrase) // Mostra la frase randomica
                            .font(.title)
                            .foregroundColor(Color.black)
                            
                            .multilineTextAlignment(.center)
                            .padding()

                    }.offset(y: -30)
                    
                }
               
            }
            .onAppear {
                // Genera una frase randomica quando la view appare
                if let randomPhrase = phrases.randomElement() {
                    currentPhrase = randomPhrase
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        showFrase = false
                    }
                }
            }
        .padding()
    }
}
