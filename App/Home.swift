//
//  Home.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 22/11/24.
//

import SwiftUI
class AppVariables: ObservableObject{
    @Published var globalName: String = ""
}
struct Home: View {
    @Binding var selected: Int
    @EnvironmentObject var variables: AppVariables
    @Binding var showTabView: Bool
    @StateObject var viewModel = AbitudiniViewModel()
    @State var habits:[String] = ["Attività Fisica","Salute Mentale","Alimentazione e Idratazione","Studio e Creatività", "Risparmiare"]
    @State var newHabit: String = ""
    @State var isAddingNewHabit: Bool = false
    @State var page1: Bool = false
    var body: some View {
        NavigationView{
            ScrollView{
                Button(action:{
                    isAddingNewHabit.toggle()
                },label:{ Image(systemName:"plus")
                        .accentColor(.white)
                        .bold()
                })
                .frame(width:40,height:40)
                .background(Color.mint)
                .cornerRadius(50)
                .shadow(radius: 5)
                .overlay(Circle().stroke(Color.black,lineWidth:0.5))
                .offset(x: 150,y:-120)
                
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
                            .background(Color.mint)
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
                     }
                     .onDisappear {
                         showTabView = true // Mostra TabView al ritorno
                     }, label: {
                        RoundedRectangle(cornerRadius:20)
                            .fill(Color.mint)
                            .stroke(Color.black, lineWidth:2)
                            .overlay(
                                HStack{
                                    Text(habit)
                                        .font(.title)
                                    
                                })
                            .frame(maxWidth:.infinity)
                            .frame(height:180)
                    }
       )
                }
                

                   /* per ogni macro categoria creare una pagina (che deve essere uguale per tutti)
                    con calendario, grafici, to-do list ()
                    nel caso di classifiche aggiungere nella tab view un icona
                    */
                
                
            
                
            }.navigationTitle("Benvenuto:\(variables.globalName)")
              //fine scroll
        }//fine nav
    }
    
    @ViewBuilder
    func destinationView(for habit: String) -> some View {
        HabitView(macroAbitudine: habit)// Passa il nome della macroabitudine
    }
   
}

                                    
                                   
                                    

#Preview {
    Goals(selected:1)
        .environmentObject(AppVariables())

}



