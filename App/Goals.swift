//
//  Goals.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 22/11/24.
//

import SwiftUI

struct Goals: View {
    
    @State var selected: Int = 0 {
        didSet {
            print("Tab selezionato: \(selected)")
        }
    }
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
                    SfideView()
                        .tabItem{
                            VStack{
                                Image(systemName: "trophy.fill")
                            }
                        }.tag(2)
                    Profile()
                        .tabItem{
                            VStack {
                                Spacer() .frame(height: 20)
                                Image(systemName: "person")
                                
                            }
                        }.tag(3)
                    Settings()
                        .tabItem{
                            VStack {Spacer().frame(height: 20)
                                Image(systemName: "gear")
                            }
                        }.tag(4)
                }.accentColor(Color.black)
                    .onAppear{
                        print("Goals View onAppear")
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
        .environmentObject(RisparmioViewModel())
        .environmentObject(HabitsManager())
}
