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
    
    var body: some View {
        TabView(selection: $selected){
            Home(selected:$selected)
                .tabItem{
                    VStack{
                        
                        Image(systemName: "house")
                            
                        
                    }
                }
           Text("Ciauuuuu")
                .tabItem{
                    VStack {Spacer() .frame(height: 20)
                        Image(systemName: "person")
                        
                    }
                }
            Text("Ciauuuuu")
                .tabItem{
                    VStack {Spacer().frame(height: 20)
                        Image(systemName: "gear")
                    }
                    }
                
            
        }
    }
    
}

#Preview {
    Goals( ).environmentObject(AppVariables())
}
