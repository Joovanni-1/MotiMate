//
//  Profile.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 04/12/24.
//

import SwiftUI




struct Profile: View {
    @EnvironmentObject var variables: AppVariables
    var sfondoP: Color = Color("azzurrino")
    @State private var photoImage: Image = Image(systemName: "person")
    @State private var isPickerPresented: Bool = false // Stato per il picker
 
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 650)
                .frame(maxWidth: .infinity)
                .foregroundColor(sfondoP)
                .cornerRadius(30)
                .padding()
                .offset(y: 20)
            Circle()
                .stroke(sfondoP, lineWidth: 10)
                .background(Color.white)
                .frame(width: 150, height: 150)
                .cornerRadius(150)
                .foregroundColor(Color.white)
                .offset(y: -280)
                .overlay(
                    photoImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle()) // Per mantenere l'aspetto circolare
                        .offset(y: -280)
                )
            ZStack{
                Button(action: {
                isPickerPresented = true // Mostra il photo picker
            }, label: {
                Image(systemName: "camera")
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
            }.offset(x: 48, y: -230)
            VStack(spacing: 30) {
                capsuletta.overlay(Text(variables.globalName))
                capsuletta.overlay(Text(variables.cognome))
                capsuletta.overlay(Text(variables.sex))
                capsuletta.overlay(Text("\(variables.age)"))
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            ProfileImagePickerView { selectedImage in
                if let selectedImage = selectedImage {
                    photoImage = Image(uiImage: selectedImage)
                }
            }
        }
        .shadow(radius: 5)
    }
    var capsuletta: some View {
        Capsule()
            .frame(width: 300, height: 40)
            .foregroundColor(Color.white)
    }
}
 
// MARK: - Photo Picker View
struct ProfileImagePickerView: View {
    let onImageSelected: (UIImage?) -> Void
    @Environment(\.presentationMode) var presentationMode
    let availableImages: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "8")!,
        UIImage(named: "9")!,
        UIImage(named: "10")!,
        UIImage(named: "11")!,
        UIImage(named: "12")!,
        UIImage(named: "13")!,
        UIImage(named: "14")!,
        UIImage(named: "16")!,
        UIImage(named: "17")!,
        UIImage(named: "22")!,
        UIImage(named: "15")! // Aggiungi le immagini che vuoi mostrare
    ]
    var body: some View {
        VStack {
            Text("Seleziona un'immagine")
                .font(.headline)
                .padding()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(availableImages, id: \.self) { image in
                        Button(action: {
                            onImageSelected(image)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(uiImage: image)
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

