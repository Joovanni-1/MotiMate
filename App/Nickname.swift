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
    @State var age: Int = 0
    @State var sex: String = ""
    @State var showPicker1: Bool = false
    @State var showPicker2: Bool = false
    let genders: [String]=["Maschio","Femmina","Altro  "]
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
                        showPicker1.toggle()
                        if showPicker1 { showPicker2 = false }
                    }, label: {
                        Text("Seleziona la tua età")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    })
                }
                
                
                
                
                HStack { Text("Sesso: \(sex)")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        showPicker2.toggle()
                        if showPicker2 { showPicker1 = false }
                    }, label: {
                        Text("Seleziona il tuo sesso")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    })
                }

                
                
                
                
                    
                 
                
                
            }  //fine VStack
            .padding(.horizontal)
            .offset(y:-200)
         
            
            VStack{
                Spacer()
                if showPicker2  {
                    Picker("Sesso", selection: $sex) {
                        ForEach(genders, id:\.self) { gender in
                            Text("\(gender)")
                               .tag(gender)
                        }
                    }
                  .pickerStyle(MenuPickerStyle())
                    //.background(Color.white)
                    .padding()
                   
                    .frame(height: 90)
                    .cornerRadius(8)
                    .onChange(of: sex){_ in showPicker2 = false }
                    .offset(x:-20,y:-258.4)
                   //.offset(y:-200)
                }
                    
                
                // func
                if showPicker1  {
                    Picker("Età", selection: $age) {
                        ForEach(0..<100) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    .background(Color.white)
                   
                    .cornerRadius(10)
                    
                    .padding(.all,60)
                    
                    .onChange(of: age){_ in showPicker1 = false}
                    
                } //fine
                
                
            }
            
            
        }
    }
    
    
   
            
        }
        
        
    
    
    
    
    
    
    
    





#Preview {
    Nickname()
}
