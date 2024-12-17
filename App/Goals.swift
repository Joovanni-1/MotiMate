//
//  Goals.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 22/11/24.
//

import SwiftUI

struct Goals: View {
    /*
     creare un array con tutte le abitudini principali
     bottone riferito ad ogni singolo array(foreach)
     funzione che richiama la possibilità di aggiungere nell'array  un'altra abitudine
     */
    // ricordati che Risparmiare avrà un altra schermata
    
    @State var selected: Int = 0
    @State private var showTabView = true
    var body: some View {
        
        NavigationStack{
            if showTabView {
                TabView(selection: $selected){
                    Home(showTabView: $showTabView)
                        .tabItem{
                            VStack{
                                
                                Image(systemName: "house")
                                
                                
                            }
                        }.tag(0)
                    Streak()
                        .tabItem{
                            VStack{
                                
                                Image(systemName: "flame.fill")
                                
                                
                            }
                        }.tag(1)
                    Profile()
                        .tabItem{
                            VStack {
                                Spacer() .frame(height: 20)
                                Image(systemName: "person")
                                
                            }
                        }.tag(2)
                    Settings()
                        .tabItem{
                            VStack {Spacer().frame(height: 20)
                                Image(systemName: "gear")
                            }
                        }.tag(3)
                }.accentColor(Color.black)
            } else {
                    EmptyView() // Nasconde la TabView
                }
                
            
        }
    }
    
}

#Preview {
    Goals().environmentObject(AppVariables())
        .environmentObject(AbitudiniViewModel())
        .environmentObject(RisparmioViewModel())
}
