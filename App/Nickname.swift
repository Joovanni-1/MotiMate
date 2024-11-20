//
//  Untitled.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 14/11/24.
//
import SwiftUI


struct Nickname: View{
    @State var nickname: String = ""
    @State var globalName: String = ""
    @State var cognome: String = ""
    @State var age: Int = 15
    @State var showPicker: Bool = false
    var body: some View {
        
        
        ZStack{
            Color.bluino
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                    .frame(height:130)
                Text("Iniziamo...")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("Avenir", size: 36))
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding(.leading,20)
                Spacer()
                    .frame(height:200)
                
                TextField("Nickname", text: $nickname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Inserisci il tuo nome", text: $globalName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Inserisci il tuo cognome", text: $cognome)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack { Text("Età: \(age)")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        showPicker.toggle()
                    }, label: {
                        Text("Seleziona la tua età")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    })
                       }
                                }
                                .padding(.horizontal)
                                .padding(.bottom,450)
                                
                                
                                if showPicker  {
                                    Picker("Età", selection: $age) {
                                        ForEach(0..<100) { number in
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .background(Color.white)
                                    .padding(.top)
                                    .frame(height: 90)
                                    .cornerRadius(8)
                                   // .onChange(of: age){_ in showPicker = false}
                                    
                                }
            
                                
                                Spacer()
                }
                
            }
            
        }
        
        
    
    
    
    
    
    
    
    





#Preview {
    Nickname()
}
