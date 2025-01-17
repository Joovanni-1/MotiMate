//
//  ContentView.swift
//  App
//
//  Created by Giovanni Gaudiuso on 13/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var isTrue :Bool = false {
        didSet {
            print("isTrue cambiato a: \(isTrue)")
        }
    }
    @State private var isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    var body: some View {
        if isFirstLaunch {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        ZStack{
                            Image("1schermata")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: 1200)
                                .clipped()
                            ZStack{
                                Image("Moti Mate")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:400,height:250)
                                    .offset(x: -5, y: 98)
                                ZStack {
                                    Text("Ciao, benvenuto su MotiMate!")
                                        .frame(width:300,height:100)
                                    
                                        .background(Color("marrone_scuro"))
                                    
                                        .cornerRadius(5)
                                        .shadow(radius: 50)
                                    
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                }
                            }.padding(.bottom,400)
                            Image(systemName:"chevron.down.2")
                                .font(.system(size:60))
                                .foregroundColor(.white)
                                .padding(.top,350)
                            
                            Button(action: {
                                print("Pulsante INIZIA cliccato")
                                isTrue.toggle()
                            }, label: {Text("INIZIA")
                                
                            })
                            .frame(width:100,height:50)
                            
                            .background(Color.blue)
                            .cornerRadius(20)
                            .shadow(radius: 50)
                            
                            .font(.system(size:26))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.top,800)
                            .fullScreenCover(isPresented:$isTrue,content:{
                                Nickname()
                                    .onAppear {
                                        print("Schermata Nickname mostrata")
                                    }
                                    .onDisappear{
                                        UserDefaultsManager.shared.setFirstLaunchDone()
                                        print("Schermata Nickname chiusa")
                                    }
                            })
                        }
                    }
                }.frame(width: geometry.size.width)
                    .edgesIgnoringSafeArea(.all)
                    .scrollIndicators(.hidden)
            }
        }else{
            Goals().environmentObject(AppVariables())
                .environmentObject(AbitudiniViewModel())
                .environmentObject(RisparmioViewModel())
                .environmentObject(HabitsManager())
        }
    }
        
    }
#Preview {
    ContentView()
        .environmentObject(AppVariables())
     .environmentObject(AbitudiniViewModel())
     .environmentObject(RisparmioViewModel())
     .environmentObject(HabitsManager())
}
