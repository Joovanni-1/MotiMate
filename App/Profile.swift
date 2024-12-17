//
//  Profile.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 04/12/24.
//

import SwiftUI




struct Profile: View {
    @EnvironmentObject var variables: AppVariables
    var sfondoP: Color = Color(.white)
    @State private var photoImage: Image = Image(systemName: "person") // Immagine di default
    @State private var isPickerPresented: Bool = false // Stato per il picker
 
    // Chiave per UserDefaults
    private let profileImageKey = "profileImageKey"
 
    var body: some View {
        ZStack {
            LinearGradient(colors: [.moss, Color("bluino")], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            ZStack {
                Rectangle()
                    .frame(height: 450)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(sfondoP)
                    .cornerRadius(30)
                    .padding()
 
                Circle()
                    .stroke(sfondoP, lineWidth: 10)
                    .background(Color.white)
                    .frame(width: 150, height: 150)
                    .cornerRadius(150)
                    .foregroundColor(Color.white)
                    .offset(y: -250)
                    .overlay(
                        photoImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .offset(y: -250)
                    )
 
                ZStack {
                    Button(action: {
                        isPickerPresented = true // Mostra il photo picker
                    }, label: {
                        Image(systemName: "camera")
                            .accentColor(.black)
                            .background(
                                Circle()
                                    .stroke(sfondoP, lineWidth: 1)
                                    .frame(width: 30, height: 30)
                                    .background(Color.white)
                                    .cornerRadius(150)
                            )
                            .frame(width: 100, height: 100)
                            .cornerRadius(150)
                    })
                }.offset(x: 48, y: -200)
 
                VStack(spacing: 30) {
                    capsuletta.overlay(Text(variables.globalName))
                    capsuletta.overlay(Text(variables.cognome))
                    capsuletta.overlay(Text(variables.sex))
                    capsuletta.overlay(Text("\(variables.age)"))
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                ProfileImagePickerView { selectedImageName in
                    if let selectedImageName = selectedImageName {
                        saveImageName(selectedImageName) // Salva il nome dell'immagine selezionata
                        photoImage = Image(selectedImageName)
                    }
                }
            }
            .shadow(radius: 5)
            .onAppear {
                loadImageName() // Carica il nome dell'immagine salvata all'avvio
            }
        }
    }
 
    var capsuletta: some View {
        Capsule()
            .frame(width: 300, height: 40)
            .foregroundColor(Color.white)
    }
 
    // MARK: - Salvataggio nome immagine
    private func saveImageName(_ imageName: String) {
        UserDefaults.standard.set(imageName, forKey: profileImageKey)
    }
 
    // MARK: - Caricamento nome immagine
    private func loadImageName() {
        if let savedImageName = UserDefaults.standard.string(forKey: profileImageKey) {
            photoImage = Image(savedImageName)
        }
    }
}
 
// MARK: - Photo Picker View
struct ProfileImagePickerView: View {
    let onImageSelected: (String?) -> Void
    @Environment(\.presentationMode) var presentationMode
    let availableImages: [String] = [
        "1", "2", "3", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "16", "17", "22", "15"
    ] // Nomi delle immagini disponibili nell'app
    var body: some View {
        VStack {
            Text("Seleziona un'immagine")
                .font(.headline)
                .padding()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(availableImages, id: \.self) { imageName in
                        Button(action: {
                            onImageSelected(imageName) // Passa il nome dell'immagine selezionata
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .padding()
                        }
                    }
                }
            }
            Button("Annulla") {
                onImageSelected(nil)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}


// MARK: - Anteprima

#Preview {
    Goals(selected:2)
        .environmentObject(AppVariables())
     .environmentObject(AbitudiniViewModel())
   
   // Profile()
      //  .environmentObject(AppVariables())
    // .environmentObject(AbitudiniViewModel())
}

