//
//  ContentView.swift
//  App
//
//  Created by Giovanni Gaudiuso on 13/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var isTrue :Bool = false
    
    var body: some View {
        
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
                            
                                .background(Color("marrone_scuro")
                                            //.opacity(0.85)
                                )
                            
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
                                    .onDisappear{
                                        UserDefaultsManager.shared.setFirstLaunchDone()
                                }
                            })
                    }
                }
            }.frame(width: geometry.size.width)
                .edgesIgnoringSafeArea(.all)
                .scrollIndicators(.hidden)
        }
    }
        
    }
    


#Preview {
    ContentView()
        .environmentObject(AbitudiniViewModel())
        .environmentObject(RisparmioViewModel())
}
