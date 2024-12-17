//
//  Home.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 22/11/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var variables: AppVariables
    @Binding var showTabView: Bool
    @EnvironmentObject var viewModel: AbitudiniViewModel
    @EnvironmentObject var viewModel1: RisparmioViewModel
    @State var habits:[String] = ["Risparmio", "Attività Fisica","Salute Mentale","Alimentazione e Idratazione","Studio e Creatività"]
    @State var newHabit: String = ""
    @State var isAddingNewHabit: Bool = false
    @State var page1: Bool = false
    var body: some View {
        
            
            ScrollView{
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Benvenuto:\(variables.nickname)")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 32)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                
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
                .offset(x: 150,y:-107)
                
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
                            habits.append(newHabit)
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
                    
                    //fine v stack
                }
                
                
                
                ForEach (habits, id:\.self){ habit in
                    
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
                                                        .offset(x:-90, y:-74 )
                                                }
                                                
                                                Text(habit)
                                                    .font(.system(size: 26))
                                                    .bold()
                                                
                                                
                                            }
                                        }
                                        
                                        Spacer()
                                        //SVGtoSwiftUIView(divisions:5, completation: 3)
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

                                    
                                   
                                    

#Preview {
    Goals(selected:0)
        .environmentObject(AppVariables())
     .environmentObject(AbitudiniViewModel())
     .environmentObject(RisparmioViewModel())
    /*Home(
            selected: .constant(0), // Tab selezionato di default
            showTabView: .constant(true) // TabView visibile di default
        )
        .environmentObject(AbitudiniViewModel())
        .environmentObject(AppVariables())*/

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


/*struct ProgressCircle: View {
    var progress: Double
 
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(.gray)
 
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(progress >= 1.0 ? .green : .blue)
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut, value: progress)
 
            Text("\(Int(progress * 100))%")
                .font(.headline)
                .bold()
        }
    }
}
*/
