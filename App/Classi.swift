//
//  Classi.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 04/12/24.
//

import Foundation


class AppVariables: ObservableObject{
    @Published var globalName: String = ""
    @Published var cognome: String = ""
    @Published var age: Int = 15
    @Published var sex: String = ""
    @Published var nickname: String = ""
    
}
class AbitudiniViewModel: ObservableObject {
    @Published var abitudini : [Abitudine] = [] {
            didSet {
                salvaDati()
                        }
            }
        

    @Published var isDeleting: Bool = false
    
    init() {
            caricaDati()
        }
   /* init() {
        aggiungiAbitudine(nome: "Esercizi mattutini", orario: "07:00", giorno: Date(), giorniSelezionati: [true, true, true, true, false, true, true],  macroAbitudine: "Attività Fisica")
        }*/
    
    func aggiungiAbitudine(nome: String, orario: String, giorno: Date, giorniSelezionati: [Bool], macroAbitudine: String){
 
        let nuovaAbitudine = Abitudine(
            nome: nome,
            orario: orario,
            giorno: giorno,
            completata: false,
            daysOfWeek : giorniSelezionati,
            completamentiGiorni: Array(repeating: false, count: giorniSelezionati.filter { $0 }.count),
            macroAbitudine: macroAbitudine
        )
        abitudini.append(nuovaAbitudine)
        
    }
    
    func eliminaAbitudine(id: UUID, daData data: Date) {
        if let index = abitudini.firstIndex(where: { $0.id == id }) {
            // Imposta la data di fine validità
            abitudini[index].dataFineValidita = data - 1
            
        }
    }
    
    func eliminaSoloPerUnGiorno(id: UUID, giorno: Date) {
        if let index = abitudini.firstIndex(where: { $0.id == id }) {
            
            abitudini[index].dataFineValidita = giorno - 1
            salvaDati()
            
        }
    }
    
    func spuntaAbitudine(id: UUID, giorno: Date) {
        if let index = abitudini.firstIndex(where: { $0.id == id }) {
            // Verifica lo stato attuale e alterna
            
            let attualeStato = abitudini[index].completamentiDate[giorno] ?? false
            abitudini[index].completamentiDate[giorno] = !attualeStato
           
           
            salvaDati()
            
        }
    }
   
    
    private func caricaDati() {
        if let dati = UserDefaults.standard.data(forKey: "abitudini"),
                   let abitudiniDecodificate = try? JSONDecoder().decode([Abitudine].self, from: dati) {
            DispatchQueue.main.async{
                self.abitudini = abitudiniDecodificate
            }
        } else{
            self.abitudini = []
        }
        }
    
    private func salvaDati() {
        if let dati = try? JSONEncoder().encode(abitudini) {
            UserDefaults.standard.set(dati, forKey: "abitudini")
        }
    }
    
}


