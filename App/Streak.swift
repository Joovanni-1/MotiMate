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
            LinearGradient(colors: [.moss, Color("bluino")], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 20) {
                Spacer().frame(height: 30)
                Text("Streak")
                    .font(.largeTitle)
                    .bold()
                    
                    .padding([.leading])
                
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .opacity(0.6)
                        .frame(maxWidth: .infinity)
                        .frame( height: 600)
                        .cornerRadius(20)
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Mese di \(meseCorrenteInItaliano())")
                            .font(.title)
                            .bold()
                            .padding(.top, 20)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                            ForEach(giorniDelMese, id: \ .self) { giorno in
                                let questione = viewModel.streakGiorni.contains(where: { Calendar.current.isDate($0, inSameDayAs: giorno) })
                                Circle()
                                    .stroke(questione ? Color.clear : Color.gray, lineWidth: 2)
                                    .background( questione ? Image("tronchetto").resizable().scaledToFill().frame(width:55) : nil )
                                   .shadow(radius: 3)
                                    
                                
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
                                        .stroke(Color("bluino").opacity(0.3), lineWidth: 15)
                                        .frame(width: 120, height: 120)
                                    Circle()
                                        .trim(from: 0, to: CGFloat(min(Double(viewModel.calcolaStreakConsecutivo()) / 30.0, 1.0)))
                                        .stroke(Color.ocean, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                        .frame(width: 150, height: 150)
                                        .rotationEffect(Angle(degrees: -90))
                                    VStack {
                                        Text("\(viewModel.calcolaStreakConsecutivo())")
                                            .font(.system(size: 40, weight: .bold))
                                            .foregroundColor(.ocean)
                                        Text("Giorni")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.bottom, 20)
                            }
                            VStack {
                                Image(systemName: "checklist")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.green)
                                
                                Text("\(viewModel.totaleHabitsCompletate())")
                                    .font(.largeTitle)
                                    .bold()
                                
                                Text("Abitudini ")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Text("completate")
                                    
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
                                    .foregroundColor(.gray)
                                    .padding(10)
                                
                            }
                            Spacer()
                        }
                        //bottone per resettare le abitudini completate
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
                }.padding()
        }
        .onAppear{
            viewModel.aggiornaStreak()
            print("StreakView onAppear: StreakGiorni=\(viewModel.streakGiorni), MaxStreak=\(viewModel.maxStreak)")
        }
            
        }
    }
}
#Preview {
    Goals(selected:1)
        .environmentObject(AppVariables())
     .environmentObject(AbitudiniViewModel())
     .environmentObject(RisparmioViewModel())
     .environmentObject(HabitsManager())
}




