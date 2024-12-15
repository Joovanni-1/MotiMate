//
//  Classi.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 04/12/24.
//

import Foundation
import CoreData


class AppVariables: ObservableObject{
    @Published var globalName: String = ""
    @Published var cognome: String = ""
    @Published var age: Int = 15
    @Published var sex: String = ""
    @Published var nickname: String = ""
    
}


// codice user default
class AbitudiniViewModel: ObservableObject {
    @Published var abitudini : [Abitudine] = [] {
        didSet {
            salvaDati()
        }
    }
    
    
    
    @Published var isDeleting: Bool = false
    @Published var giornoSelezionato: Date? = nil
    @Published var giornoCorrente: Date = Date()
    @Published var streakGiorni: [Date] = []
    @Published var maxStreak: Int = 0 // Aggiungi questa variabile per il massimo streak
    
    init() {
        caricaDati()
        
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
        if let dataSelezionata = UserDefaults.standard.object(forKey: "giornoSelezionato") as? Date {
                self.giornoSelezionato = dataSelezionata
            } else {
                self.giornoSelezionato = Date()
            }
        if let streakDati = UserDefaults.standard.data(forKey: "streakGiorni"),
                   let streakDecodificati = try? JSONDecoder().decode([Date].self, from: streakDati) {
                    self.streakGiorni = streakDecodificati
                } else {
                    self.streakGiorni = []
                }

        if let savedMaxStreak = UserDefaults.standard.object(forKey: "maxStreak") as? Int {
                   self.maxStreak = savedMaxStreak // Carica il massimo streak salvato
               }
        
    }
    
    private func salvaDati() {
        if let dati = try? JSONEncoder().encode(abitudini) {
            UserDefaults.standard.set(dati, forKey: "abitudini")
        }
        if let giornoSelezionato = giornoSelezionato {
            UserDefaults.standard.set(giornoSelezionato, forKey: "giornoSelezionato")
        }
        if let streakDati = try? JSONEncoder().encode(streakGiorni) {
            UserDefaults.standard.set(streakDati, forKey: "streakGiorni")
        }
        UserDefaults.standard.set(maxStreak, forKey: "maxStreak")
    }
    
//MARK: FUNZIONI HABITVIEW

    func aggiungiAbitudine(nome: String, orario: String, giorno: Date, giorniSelezionati: [Bool], macroAbitudine: String){
        
        let nuovaAbitudine = Abitudine(
            nome: nome,
            orario: orario,
            giorno: giorno ,
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
    
    
   func spuntaAbitudine(id: UUID, perGiorno giorno: Date) {
        if let index = abitudini.firstIndex(where: { $0.id == id }) {
            // Verifica lo stato attuale e alterna
            if let statoCorrente = abitudini[index].completamentiDate[giorno] {
                abitudini[index].completamentiDate[giorno] = !statoCorrente
                print("Abitudine \(abitudini[index].nome) per il giorno \(giorno) aggiornata a: \(!statoCorrente)")
            } else {
                abitudini[index].completamentiDate[giorno] = true
                print("Abitudine \(abitudini[index].nome) per il giorno \(giorno) completata per la prima volta.")
            }
            
            
            salvaDati()
            
            aggiornaStreak()
            aggiornaMaxStreak()
        }else {
            print("Errore: abitudine con ID \(id) non trovata.")
        }
    }
    
    func progressForCategory(_ macroAbitudine: String, forDay giorno: Date) -> (completate: Int, totale: Int) {
        // Filtra le abitudini per la macrocategoria
        let abitudiniFiltrate = abitudini.filter { $0.macroAbitudine == macroAbitudine }

        // Filtra le abitudini valide per il giorno specifico
        let abitudiniValide = abitudiniFiltrate.filter { abitudine in
            let weekdayIndex = (Calendar.current.component(.weekday, from: giornoSelezionato!) + 5) % 7
            let isScheduledForDay = abitudine.daysOfWeek[weekdayIndex]
            let isDateValid = abitudine.dataFineValidita == nil || giorno <= abitudine.dataFineValidita!
            return isScheduledForDay && isDateValid
        }

        // Calcola le abitudini completate
        let completate = abitudiniValide.filter { $0.completamentiDate[giorno] == true }.count

        return (completate, abitudiniValide.count)
    }
    func resetGiornoSelezionato() {
            giornoSelezionato = giornoCorrente
        }
    
    func calcolaStreakPerGiorno(giorno: Date) -> Bool {
            let abitudiniGiorno = abitudini.filter { abitudine in
                let weekdayIndex = (Calendar.current.component(.weekday, from: giornoSelezionato!) + 5) % 7
                let isScheduledForDay = abitudine.daysOfWeek[weekdayIndex]
                let isDateValid = abitudine.dataFineValidita == nil || giorno <= abitudine.dataFineValidita!
                return isScheduledForDay && isDateValid
            }

            let completate = abitudiniGiorno.filter { $0.completamentiDate[giorno] == true }.count
            return completate == abitudiniGiorno.count && !abitudiniGiorno.isEmpty
        }

    func aggiornaStreak() {
        let completatoOggi = calcolaStreakPerGiorno(giorno: giornoCorrente)
        
        // Se il giorno corrente ha tutte le abitudini completate, aggiungilo allo streak
        if completatoOggi {
            if !streakGiorni.contains(where: { Calendar.current.isDate($0, inSameDayAs: giornoCorrente) }) {
                streakGiorni.append(giornoCorrente)
            }
        } else {
            // Rimuovi il giorno corrente dallo streak se non è completo
            streakGiorni.removeAll(where: { Calendar.current.isDate($0, inSameDayAs: giornoCorrente) })
        }
        
        salvaDati()
    }
    
    func calcolaStreakConsecutivo() -> Int {
        var streak = 0
        var giornoCorrente = Date()
       
        // Itera indietro fino a quando le abitudini sono completate per ogni giorno consecutivo
           while streakGiorni.contains(where: { Calendar.current.isDate($0, inSameDayAs: giornoCorrente) }) {
               streak += 1
               if let giornoPrecedente = Calendar.current.date(byAdding: .day, value: -1, to: giornoCorrente) {
                   giornoCorrente = giornoPrecedente
               } else {
                   break
               }
           }
        return streak
    }
    func totaleHabitsCompletate() -> Int {
            return abitudini.reduce(0) { $0 + $1.completamentiDate.filter { $0.value == true }.count }
        }
    
    func aggiornaMaxStreak() {
           let streakAttuale = calcolaStreakConsecutivo()
           
           // Se lo streak attuale è maggiore del massimo precedente, aggiorna il massimo
           if streakAttuale > maxStreak {
               maxStreak = streakAttuale
               salvaDati() // Salva il nuovo massimo streak
           }
       }
    
    func resetHabitsDone() {
        for index in abitudini.indices {
            abitudini[index].completamentiDate.removeAll()
        }
        salvaDati()
    }
}

