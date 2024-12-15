//
//  Streak.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 11/12/24.
//

import SwiftUI
import Foundation


struct Streak: View {
    @EnvironmentObject var viewModel: AbitudiniViewModel

    let calendar = Calendar.current

    private var giorniDelMese: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: viewModel.giornoCorrente),
              let primoGiorno = calendar.date(from: calendar.dateComponents([.year, .month], from: viewModel.giornoCorrente)) else {
            return []
        }
        return range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: primoGiorno) }
    }

    private func meseCorrenteInItaliano() -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "it_IT")
            formatter.dateFormat = "LLLL"
            return formatter.string(from: viewModel.giornoCorrente).capitalized
        }
    var body: some View {
        ZStack{
            //Image("prato").resizable().scaledToFit().ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
            
            Text("Streak")
                .font(.largeTitle)
                .bold()
                .padding(.top, 25)
            
            
            Text("Mese di \(meseCorrenteInItaliano())")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(giorniDelMese, id: \ .self) { giorno in
                    let questione = viewModel.streakGiorni.contains(where: { Calendar.current.isDate($0, inSameDayAs: giorno) })
                    Circle()
                        .stroke(questione ? Color.clear : Color.gray, lineWidth: 1)
                        .background( questione ? Image("tronchetto").resizable().scaledToFill().frame(width:55) : nil )
                    
                    
                        .overlay(
                            Text("\(calendar.component(.day, from: giorno))")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        )
                        .frame(width: 38)
                    
                        .onTapGesture {
                            viewModel.giornoSelezionato = giorno
                        }
                    
                    
                }
            }
            HStack{
                Spacer()
                VStack(alignment: .center, spacing: 20) {
                    
                    
                    // Cerchio centrale per lo streak
                    ZStack {
                        Circle()
                            .stroke(Color.pink.opacity(0.3), lineWidth: 15)
                            .frame(width: 120, height: 120)
                        Circle()
                            .trim(from: 0, to: CGFloat(min(Double(viewModel.calcolaStreakConsecutivo()) / 30.0, 1.0))) // Massimo 30 giorni
                            .stroke(Color.pink, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                            .frame(width: 150, height: 150)
                            .rotationEffect(Angle(degrees: -90))
                        VStack {
                            Text("\(viewModel.calcolaStreakConsecutivo())")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.pink)
                            Text("Giorni")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 20)
                }
                VStack {
                    Image(systemName: "checklist") // Puoi sostituirlo con un'icona personalizzata
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                    
                    Text("\(viewModel.totaleHabitsCompletate())")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Habits Done")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                
                Spacer()
                
            }
            HStack{
                Spacer()
                VStack{
                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 57, height: 57)
                        .foregroundStyle( RadialGradient(colors: [Color.yellow, Color.orange, Color.red, Color.red], center: .init(x: 0.5, y:0.7), startRadius: 0, endRadius: 45)
                        )
                        .overlay( Text(" \(viewModel.maxStreak) ")
                            .font(.title)
                            .bold()
                            .offset(y: 13))
                    
                    
                    Text("Massimo Streak: \(viewModel.maxStreak) ")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(10)
                    
                }
                Spacer()
            }
            /*Button(action: {
             viewModel.resetHabitsDone()
             }, label: {
             Text("Reset Habits Done")
             .foregroundColor(.red)
             .padding()
             .background(Capsule().stroke(Color.red, lineWidth: 2))
             })
             .padding(.top, 20)*/
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear{
            viewModel.aggiornaStreak()
        }
            
        }
        
        
    }
}




#Preview {
    Goals(selected:1)
        .environmentObject(AppVariables())
     .environmentObject(AbitudiniViewModel())
}



