//
//  Classi.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 04/12/24.
//

import Foundation


//MARK: VARIABILI GLOBALI
class AppVariables: ObservableObject {
    @Published var globalName: String = "" {
        didSet {
            print("globalName cambiato a: \(globalName)")
            saveToUserDefaults() }
    }
    @Published var cognome: String = "" {
        didSet {
            print("cognome cambiato a: \(cognome)")
            saveToUserDefaults() }
    }
    @Published var age: Int = 15 {
        didSet {
            print("age cambiato a: \(age)")
            saveToUserDefaults() }
    }
    @Published var sex: String = "" {
        didSet {
            print("sex cambiato a: \(sex)")
            saveToUserDefaults() }
    }
    @Published var nickname: String = "" {
        didSet {
            print("nickname cambiato a: \(nickname)")
            saveToUserDefaults() }
    }
    
    init() {
        print("Inizializzazione AppVariables")
        if let savedUserData = UserDefaults.standard.dictionary(forKey: "currentUser") {
            self.nickname = savedUserData["nickname"] as? String ?? ""
            self.globalName = savedUserData["globalName"] as? String ?? ""
            self.cognome = savedUserData["cognome"] as? String ?? ""
            self.sex = savedUserData["sex"] as? String ?? ""
            self.age = savedUserData["age"] as? Int ?? 15
        } else {
            print("Nessun dato trovato in UserDefaults")
      }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "nickname": nickname,
            "globalName": globalName,
            "cognome": cognome,
            "sex": sex,
            "age": age
        ]
    }
    
     func saveToUserDefaults() {
        let userDictionary = toDictionary()
        UserDefaults.standard.set(userDictionary, forKey: "currentUser")
         print("Dati salvati in UserDefaults: \(userDictionary)")
    }


     
        // Funzione statica per creare un'istanza AppVariables da un dizionario
        static func fromDictionary(_ dictionary: [String: Any]) -> AppVariables {
            let user = AppVariables()
            user.nickname = dictionary["nickname"] as? String ?? ""
            user.globalName = dictionary["globalName"] as? String ?? ""
            user.cognome = dictionary["cognome"] as? String ?? ""
            user.sex = dictionary["sex"] as? String ?? ""
            user.age = dictionary["age"] as? Int ?? 0
            return user
        }
}

//MARK: DATABASE UTENTI
class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userKey = "savedUsers"
    private let firstLaunchKey = "isFirstLaunch"
    
    private init() {}
    
    // Recupera tutti gli utenti salvati
    func getAllUsers() -> [AppVariables] {
        guard let savedData = UserDefaults.standard.array(forKey: userKey) as? [[String: Any]] else {
            return []
        }
        return savedData.map { AppVariables.fromDictionary($0) }
    }
    
    // Salva un nuovo utente
    func saveUser(_ user: AppVariables) -> Bool {
        var users = getAllUsers()
        
        // Verifica l'unicità del nickname
        if users.contains(where: { $0.nickname == user.nickname }) {
            return false // Nickname già esistente
        }
        
        users.append(user)
        
        // Converti gli utenti in dizionari e salva nei UserDefaults
        let userDictionaries = users.map { $0.toDictionary() }
        UserDefaults.standard.set(userDictionaries, forKey: userKey)
        return true
    }
   
        func isFirstLaunch() -> Bool {
            return UserDefaults.standard.bool(forKey: firstLaunchKey) == false
        }
     
        func setFirstLaunchDone() {
            UserDefaults.standard.set(true, forKey: firstLaunchKey)
        }
}



// MARK: ABITUDINI
class AbitudiniViewModel: ObservableObject {
    @Published var abitudini : [Abitudine] = [] {
        didSet {
            print("Abitudini aggiornate: \(abitudini)")
            salvaDati()
        }
    }
    
    
    
    @Published var isDeleting: Bool = false
    @Published var giornoSelezionato: Date? = nil {
            didSet {
                print("Giorno selezionato aggiornato: \(giornoSelezionato?.description ?? "nil")")
            }
        }
    @Published var giornoCorrente: Date = Date()
    @Published var streakGiorni: [Date] = [] {
            didSet {
                print("Streak aggiornati: \(streakGiorni)")
            }
        }
    @Published var maxStreak: Int = 0 {
            didSet {
                print("Massimo streak aggiornato a: \(maxStreak)")
            }
        }
    @Published var mostraConfetti: Bool = false
    @Published var mostraFraseRandom: Bool = false
    
    init() {
        print("Inizializzazione AbitudiniViewModel")
        caricaDati()
        
        
    }
    
    private func caricaDati() {
        if let dati = UserDefaults.standard.data(forKey: "abitudini"),
           let abitudiniDecodificate = try? JSONDecoder().decode([Abitudine].self, from: dati) {
            DispatchQueue.main.async{
                self.abitudini = abitudiniDecodificate
                
            }
            print("Abitudini caricate da UserDefaults: \(abitudini)")
        } else{
            self.abitudini = []
            print("Nessuna abitudine trovata in UserDefaults")
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
            print("Abitudini salvate in UserDefaults")
        }
        if let giornoSelezionato = giornoSelezionato {
            UserDefaults.standard.set(giornoSelezionato, forKey: "giornoSelezionato")
        }
        if let streakDati = try? JSONEncoder().encode(streakGiorni) {
            UserDefaults.standard.set(streakDati, forKey: "streakGiorni")
        }
        UserDefaults.standard.set(maxStreak, forKey: "maxStreak")
        
       
    }
    
//FUNZIONI HABITVIEW

    func aggiungiAbitudine(nome: String, orario: String, giorno: Date, giorniSelezionati: [Bool], macroAbitudine: String){
        let giornoCorrente = Calendar.current.startOfDay(for: Date())
        let nuovaAbitudine = Abitudine(
            nome: nome,
            orario: orario,
            giorno: giornoCorrente ,
            completata: false,
            daysOfWeek : giorniSelezionati,
            completamentiGiorni: Array(repeating: false, count: giorniSelezionati.filter { $0 }.count),
            macroAbitudine: macroAbitudine
           
           
        )
        abitudini.append(nuovaAbitudine)
        print("Nuova abitudine aggiunta: \(nuovaAbitudine)")
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
            
            if abitudini[index].completamentiDate[giorno] == true {
                        mostraFraseRandom = true
                    }
            salvaDati()
            
            aggiornaStreak()
            aggiornaMaxStreak()
            
            
        }else {
            print("Errore: abitudine con ID \(id) non trovata.")
        }
    }
    
    // HOME
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
    
    //STREAK
    func calcolaStreakPerGiorno(giorno: Date) -> Bool {
            let abitudiniGiorno = abitudini.filter { abitudine in
                let weekdayIndex = (Calendar.current.component(.weekday, from: giornoSelezionato!) + 5) % 7
                let isScheduledForDay = abitudine.daysOfWeek[weekdayIndex]
                let isDateValid = abitudine.dataFineValidita == nil || giorno <= abitudine.dataFineValidita!
                return isScheduledForDay && isDateValid
            }

            let completate = abitudiniGiorno.filter { $0.completamentiDate[giorno] == true }.count
        print("Abitudini completate per il giorno \(giorno): \(completate) su \(abitudiniGiorno.count)")
            return completate == abitudiniGiorno.count && !abitudiniGiorno.isEmpty
        }

    func aggiornaStreak() {
        let completatoOggi = calcolaStreakPerGiorno(giorno: giornoCorrente)
        
        // Se il giorno corrente ha tutte le abitudini completate, aggiungilo allo streak
        if completatoOggi {
            if !streakGiorni.contains(where: { Calendar.current.isDate($0, inSameDayAs: giornoCorrente) }) {
                streakGiorni.append(giornoCorrente)
                print("Giorno aggiunto allo streak: \(giornoCorrente)")
            }
            
            if calcolaStreakConsecutivo() > 0 {
                        mostraConfetti = true
                    }
                } else {
                    streakGiorni.removeAll(where: { Calendar.current.isDate($0, inSameDayAs: giornoCorrente) })
                    print("Giorno rimosso dallo streak: \(giornoCorrente)")
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
        print("Streak consecutivo calcolato: \(streak)")
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
               print("Nuovo massimo streak: \(maxStreak)")
           }
       }
    //prova per resettare le abitudini dal database
    func resetHabitsDone() {
        for index in abitudini.indices {
            abitudini[index].completamentiDate.removeAll()
        }
        salvaDati()
    }
    
   

     func getStartOfWeek(for date: Date) -> Date {
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: date)
            let firstWeekday = calendar.firstWeekday
            let daysToSubtract = (weekday - firstWeekday + 7) % 7
            return calendar.date(byAdding: .day, value: -daysToSubtract, to: date)!
        }
}


 //MARK: RISPARMIO
class RisparmioViewModel: ObservableObject {
    // Variabili persistenti
    @Published var goalAmount: Double? = UserDefaults.standard.object(forKey: "goalAmount") as? Double
    @Published var currentSavings: Double = UserDefaults.standard.double(forKey: "currentSavings")
    @Published var completedGoals: [CompletedGoal] = {
        if let data = UserDefaults.standard.data(forKey: "completedGoals"),
           let decoded = try? JSONDecoder().decode([CompletedGoal].self, from: data) {
            return decoded
        }
        return []
    }()
    // Variabili temporanee
    @Published var newGoalAmount: String = ""
    @Published var savingAmount: String = ""
    @Published var showGif: Bool = false
    @Published var isNavigatingToHistory: Bool = false
 
    
   
    
    // Funzione per salvare lo stato
    func saveState() {
        if let goal = goalAmount {
            UserDefaults.standard.set(goal, forKey: "goalAmount")
        } else {
            UserDefaults.standard.removeObject(forKey: "goalAmount")
        }
        UserDefaults.standard.set(currentSavings, forKey: "currentSavings")
        if let encoded = try? JSONEncoder().encode(completedGoals) {
            UserDefaults.standard.set(encoded, forKey: "completedGoals")
        }
    }
 
    // Imposta un nuovo obiettivo
    func setGoal() {
        if let amount = Double(newGoalAmount), amount > 0 {
            goalAmount = amount
            currentSavings = 0
            newGoalAmount = ""
            saveState()
        }
    }
 
    // Aggiungi risparmio all'obiettivo corrente
    func addSavings() {
        if let amount = Double(savingAmount), amount > 0 {
            currentSavings += amount
            savingAmount = ""
            saveState()
        }
    }
 
    // Resetta l'obiettivo una volta raggiunto (prova)
    func resetGoal() {
        if let completedGoalAmount = goalAmount {
            completedGoals.append(CompletedGoal(goalAmount: completedGoalAmount, currentSavings: currentSavings))
        }
        goalAmount = nil
        currentSavings = 0
        saveState()
    }
}

//MARK: MACROCATEGORIA
class HabitsManager: ObservableObject {
    static let shared = HabitsManager()
    @Published var habits: [String] {
        didSet {
            UserDefaults.standard.set(habits, forKey: "userHabits")
        }
    }
    init() {
        // Carica le abitudini salvate, altrimenti usa quelle di default
        self.habits = UserDefaults.standard.array(forKey: "userHabits") as? [String] ?? ["Risparmio", "Attività Fisica", "Salute Mentale", "Alimentazione e Idratazione", "Studio e Creatività"]
    }
    func addHabit(_ habit: String) {
        if !habit.isEmpty && !habits.contains(habit) {
            habits.append(habit)
        }
    }
    // Prova per eliminare le macroabitudini
    func removeHabit(_ habit: String) {
        habits.removeAll { $0 == habit }
    }
}
