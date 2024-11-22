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
    
    @State var habits:[String] = ["Attività Fisica ","Salute Mentale","Alimentazione e Idratazione","Studio e Creatività", "Risparmiare"]
    var body: some View {
        NavigationView{
            ScrollView{
            ForEach (habits, id:\.self){item in
                RoundedRectangle(cornerRadius:20)
                    .fill(Color.mint)
                    .stroke(Color.black, lineWidth:2)
                    .overlay( Text(item)
                        .font(.title)
                        
                        )
                    .frame(maxWidth:.infinity)
                    .frame(height:180)
               
            }
            }.navigationTitle("Benvenuto:\(variables.globalName)")
        }
    }
}

#Preview {
    Goals(selected:1)
        .environmentObject(AppVariables())

}
