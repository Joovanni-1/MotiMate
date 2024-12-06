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
    @State var selected1: Int = 1
    @State private var showTabView = true
    var body: some View {
        
        NavigationStack{
            if showTabView {
                TabView(selection: $selected){
                    Home(selected:$selected, showTabView: $showTabView)
                        .tabItem{
                            VStack{
                                
                                Image(systemName: "house")
                                
                                
                            }.tag(0)
                        }
                    Profile() 
                        .tabItem{
                            VStack {Spacer() .frame(height: 20)
                                Image(systemName: "person")
                                
                            }
                        }.tag(1)
                    Settings()
                        .tabItem{
                            VStack {Spacer().frame(height: 20)
                                Image(systemName: "gear")
                            }
                        }.tag(2)
                }
            } else {
                    EmptyView() // Nasconde la TabView
                }
                
            
        }
    }
    
}

#Preview {
    Goals().environmentObject(AppVariables())
        .environmentObject(AbitudiniViewModel())
}
