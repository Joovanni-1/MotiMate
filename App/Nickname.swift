//
//  Untitled.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 14/11/24.
//
import SwiftUI


struct Nickname: View{
    //MARK: VARIABILI
    @State private var nickname: String = "" {
            didSet {
                print("Nickname aggiornato a: \(nickname)")
            }
        }
    @StateObject var variables = AppVariables()
    @State var showPicker1: Bool = false
    @State var showPicker2: Bool = false
    @State var click: Bool = false
    @State var showAlert: Bool = false
    let genders: [String]=["" ,"Maschio","Femmina","Altro  "]
    
    //MARK: STRUTTURA
    var body: some View {
        ZStack{
            //backgroung
            Color.bluino
                .edgesIgnoringSafeArea(.all)
            ZStack{
                ZStack{
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 47, height: 47)
                        .offset(x: 20,y: -257)
                    VStack{
                        Spacer().frame(height: 100)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.8))
                            .stroke( Color.white, lineWidth: 5)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                        Image("castoro_nickname")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .offset(y: -467)
                    }
                }
                .padding(8)
            // foreground
            VStack{
                Spacer()
                    .frame(height:130)
                Text("Iniziamo...")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("Avenir", size: 36))
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding(.leading,5)
               
                    .frame(height:300)
                
                TextField("Nickname", text: $variables.nickname )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Inserisci il tuo nome", text: $variables.globalName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Inserisci il tuo cognome", text: $variables.cognome)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack { Text("Età: \(variables.age)")
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
                HStack { Text("Genere: \(variables.sex)")
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
                Button(action: {
                    if !variables.nickname.isEmpty && !variables.globalName.isEmpty && !variables.cognome.isEmpty &&
                        !variables.sex.isEmpty{
                      
                        let isSaved = UserDefaultsManager.shared.saveUser(variables)
                        if isSaved {
                            click.toggle()
                            print("Nickname salvato: \(nickname)")
                    }else{
                        showAlert = true
                    }
                } else{
                    showAlert = true
                }}, label: {
                    VStack{
                        Image(systemName:"arrowshape.forward")
                        Text("Avanti")
                    }
                })
                .frame(width:200,height:80)
                
                .background( !variables.nickname.isEmpty && !variables.globalName.isEmpty && !variables.cognome.isEmpty &&
                             !variables.sex.isEmpty ? Color.blue : Color.gray)
                .cornerRadius(20)
                .shadow(radius: 50)
                .offset(y:50)
                .font(.system(size:26))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.top,100)
                .alert(isPresented: $showAlert) {
                    Alert( title: Text("Attenzione, compila tutti i campi o usa un nickname diverso!"),  message: Text(""), dismissButton: .default(Text("OK")))}
                
            }  //fine VStack
            .padding(.horizontal)
            .offset(y:-200)
        }
            ZStack {
                if click {
                    Goals()
                        .environmentObject(variables)
                        .transition(.move(edge: .trailing))
                        .zIndex(1)
                }
            }
            .animation(.easeInOut, value: click)
            
            Pickers
        }
    }
    
    
    
    //MARK: PICKERS
    var Pickers:some View{
        VStack{
            Spacer()
            if showPicker2  {
            Picker("Sesso", selection: $variables.sex) {
                    ForEach(genders, id:\.self) { gender in
                        Text(gender)
                            .tag(gender)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .background(Color.white)
                .cornerRadius(10)
                .padding(.all,60)
                .onChange(of: variables.sex){_ in showPicker2 = false }
            }
            if showPicker1  {
                Picker("Età", selection: $variables.age) {
                    ForEach(0..<100) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .background(Color.white)
                .cornerRadius(10)
                .padding(.all,60)
                .onChange(of: variables.age){_ in showPicker1 = false}
            }
        }
    }
}


#Preview {
    Nickname()
          .environmentObject(AppVariables())
       .environmentObject(AbitudiniViewModel())
       .environmentObject(RisparmioViewModel())
       .environmentObject(HabitsManager())
}
