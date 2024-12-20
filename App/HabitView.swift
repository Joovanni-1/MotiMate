//
//  Attività fisica.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 27/11/24.
//


import SwiftUI
import Charts
// Modello per una singola abitudine
struct Abitudine: Identifiable, Codable  {
    var id = UUID()
    var nome: String
    var orario: String
    var giorno: Date
    var completata: Bool
    var daysOfWeek : [Bool]
    var completamentiGiorni : [Bool]
    var completamentiDate: [Date: Bool] = [:]
    var dataFineValidita: Date?
    var macroAbitudine: String
    var giorniEsclusi: [Date] = []
    var giorniCompletati: [Date] = []
    
  //inizializzazione
    init(nome: String, orario: String, giorno: Date, completata: Bool, daysOfWeek: [Bool], completamentiGiorni: [Bool], macroAbitudine: String) {
            self.id = UUID()
            self.nome = nome
            self.orario = orario
            self.giorno = giorno
            self.completata = completata
          
            self.daysOfWeek = daysOfWeek
            self.completamentiGiorni = completamentiGiorni
            self.completamentiDate = [:]
            self.dataFineValidita = nil
            self.macroAbitudine = macroAbitudine
        }
}
class Constants {
    static let giorniSettimana = ["Lun", "Mar", "Mer", "Gio", "Ven", "Sab", "Dom"]
}
  

struct HabitView: View {
    //MARK: VARIABILI
    var macroAbitudine: String
    @State private var dataCorrente = Date()
    @State private var nomeAbitudine = ""
    @State private var orarioAbitudine = ""
    @EnvironmentObject var viewModel: AbitudiniViewModel
   
    //@State private var giornoSelezionato: Date? = Date()
    let calendar = Calendar.current
    @State var newhabit: Bool = false
    @State private var abitudineDaModificare: Abitudine?
    @State private var mostraConfettiView = false
    @State private var mostraFraseView = false
    
    //MARK: STRUTTURA HABITVIEW
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color("verdino"), Color("bluino")], startPoint: .bottomLeading, endPoint: .topTrailing)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        Text(macroAbitudine)
                            .font(.largeTitle)
                            .bold()
                        // Calendario settimanale
                        calendarioSettimana
                        // Pulsante per aggiungere una nuova abitudine
                        pulsanteAggiungiAbitudine
                        // Lista delle abitudini
                        listaAbitudini
                        // Grafico percentuale completamento
                        graficoPercentualeCompletamento
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
   
//Mostra frasi motivazionali dopo aver spuntato un'abitudine
                if mostraConfettiView {
                               ConfettiView()
                                   .transition(.opacity)
                                   .onAppear {
                                       mostraFraseView = false
                                       DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                           mostraConfettiView = false
                                       }
                                   }
                           }
                if mostraFraseView && !mostraConfettiView {
                    RandomPhraseView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                mostraFraseView = false
                            }
                        }
                }
            }
            .onReceive(viewModel.$mostraConfetti) { value in
                           mostraConfettiView = value
                           if value {
                               DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                   viewModel.mostraConfetti = false
                               }
                           }
            }
            .onReceive(viewModel.$mostraFraseRandom){ value in
                mostraFraseView = value
                if value {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        viewModel.mostraFraseRandom = false
                    }
                }
            }
        }
        .environmentObject(viewModel)
        .onAppear{
             viewModel.giornoSelezionato = Date()
            print("HabitView onAppear: \(viewModel.abitudini)")
        }
        
    }
        
    // MARK: Componenti habit view
    var pulsanteAggiungiAbitudine: some View {
        Button(action: {
            newhabit.toggle()
        }) {
            Image(systemName: "plus").padding()
        }
        .sheet(isPresented: $newhabit) {
            CreateHabitView(viewModel: viewModel, macroAbitudine: macroAbitudine)
        }
    }
    var listaAbitudini: some View {
        VStack {
                let abitudiniMostrate = filtraAbitudiniPerGiornoSelezionato(_giornoSelezionato: viewModel.giornoSelezionato)
               // print("Caricamento lista abitudini: \(abitudiniMostrate.map { $0.nome })") // Aggiungi questo
                ForEach(abitudiniMostrate) { abitudine in
                    singolaAbitudine(abitudine: abitudine)
                }
            }
            .id(viewModel.giornoSelezionato) // Forza il refresh
        
    }
    
    // MARK: Calendario
    var calendarioSettimana: some View {
        VStack {
            Text("\(formattedDate(dataCorrente)) \(formattedAnno(dataCorrente))")
                .font(.headline)
            HStack {
                Button(action: {
                    cambiaSettimana(delta: -1)
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.ocean)
                }
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 10) {
                    ForEach(0..<7) { index in
                        let giorno = viewModel.getStartOfWeek(for: dataCorrente).addingTimeInterval(Double(index * 86400))
                        giornoCalendario(giorno: giorno)
                            
                    }
                }
                Button(action: {
                    cambiaSettimana(delta: 1)
                }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.ocean)
                }
            }
        }
    }
    func giornoCalendario(giorno: Date) -> some View {
        VStack {
            Text(dayOfWeek(for: giorno))
                .font(.headline)
                .foregroundColor(.black)
            Text(dayNumber(for: giorno))
                .font(.subheadline)
                .foregroundColor(.black)
               
        }
        .background(
            calendar.isDate(giorno, inSameDayAs: viewModel.giornoSelezionato ?? Date())
                ? Color.blue.opacity(0.4)
                : Color.clear
        )
        .cornerRadius(10)
        .onTapGesture {
            viewModel.giornoSelezionato = giorno
            print("giorno selezionato: \(giorno)")
            aggiornaAbitudini()
        }
    }
    func cambiaSettimana(delta: Int) {
        dataCorrente = Calendar.current.date(byAdding: .weekOfYear, value: delta, to: dataCorrente)!
        viewModel.giornoSelezionato = viewModel.getStartOfWeek(for: dataCorrente)
    }
    
    func singolaAbitudine(abitudine: Abitudine) -> some View {
        HStack {
            Button(action: {
                viewModel.spuntaAbitudine(id: abitudine.id, perGiorno: viewModel.giornoSelezionato ?? Date())
                
                
                    }) {
                        Image(systemName: abitudine.completamentiDate[viewModel.giornoSelezionato ?? Date()] == true
                            ? "checkmark.circle.fill"
                            : "circle")
                        .accentColor(Color.black)
                           
                            
                    }
            VStack(alignment: .leading) {
                Text(abitudine.nome)
                    .font(.headline)
                Text("Orario: \(abitudine.orario)")
                    .font(.subheadline)
                let giorniNomi = abitudine.daysOfWeek.enumerated()
                    .filter { $0.element }
                    .map { Constants.giorniSettimana[$0.offset] }
                    .joined(separator: ", ")
                Text("Giorni selezionati: \(giorniNomi)")
                    .font(.subheadline)
            }
            .foregroundColor(Color.black)
            Spacer()
            menuAbitudine(abitudine: abitudine)
        }
        
        .padding()
        .background(
            abitudine.completamentiDate[viewModel.giornoSelezionato ?? Date()] == true
                       ? Color.green.opacity(0.3)
            : Color.white
        )
        .cornerRadius(30)
        .shadow(radius: 5)
       
    }
    
    func menuAbitudine(abitudine: Abitudine) -> some View {
        Menu {
            Button(role: .destructive) {
                viewModel.eliminaAbitudine(id: abitudine.id, daData: viewModel.giornoSelezionato ?? Date())
            } label: {
                Label("Elimina per sempre", systemImage: "trash")
            }
            Button {
                if let giorno = viewModel.giornoSelezionato {
                    viewModel.eliminaSoloPerUnGiorno(id: abitudine.id, giorno: giorno)
                }
            } label: {
                Label("Elimina solo oggi", systemImage: "calendar.badge.minus")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }.accentColor(Color.black)
    }
 
 //MARK: GRAFICO SETTIMANALE
    var graficoPercentualeCompletamento: some View {
            VStack {
                Text("Percentuale di Completamento Settimanale")
                    .font(.headline)
                let completamenti = calcolaPercentualeCompletamentoSettimanale()
                Chart(completamenti) { dataPoint in
                    LineMark(
                        x: .value("Giorno", dataPoint.day),
                        y: .value("Completamento", dataPoint.completion)
                    )
                    .foregroundStyle(.blue)
                    .symbol(Circle())
                    PointMark(
                        x: .value("Giorno", dataPoint.day),
                        y: .value("Completamento", dataPoint.completion)
                    )
                    .foregroundStyle(.blue)
                }
                
                .chartYAxis{
                    AxisMarks(position: .leading)
                        
                }
                .chartYScale(domain: 0...100)
                .frame(height: 300)
                .padding()
            }
        }
   
    func calcolaPercentualeCompletamentoSettimanale() -> [DailyHabitCompletion] {
        let startOfWeek = viewModel.getStartOfWeek(for: dataCorrente)
    // Genera i giorni della settimana
    let giorniSettimana = (0..<7).map{ startOfWeek.addingTimeInterval(Double($0 *
    86400)) }
    let abitudiniFiltrate = viewModel.abitudini.filter{$0.macroAbitudine == macroAbitudine && $0.dataFineValidita.map{$0>=startOfWeek} ?? true}
    return giorniSettimana.enumerated().map{ index, giorno in
            // Filtra completamenti per il giorno
            let completamenti = abitudiniFiltrate.filter { abitudine in
                // Controlla se l'abitudine è attiva per quel giorno
                let weekdayIndex = (Calendar.current.component(.weekday, from: giorno) + 5) % 7
                let isScheduledForDay = abitudine.daysOfWeek[weekdayIndex]
                let isDateValid = abitudine.dataFineValidita == nil || giorno <= abitudine.dataFineValidita!
                return isScheduledForDay && isDateValid && abitudine.completamentiDate[giorno] == true
            }
            // Calcola la percentuale in base alle abitudini attive in quella giornata
            let abitudiniGiornaliere = abitudiniFiltrate.filter { abitudine in
                let weekdayIndex = (Calendar.current.component(.weekday, from: giorno) + 5) % 7
                let isScheduledForDay = abitudine.daysOfWeek[weekdayIndex]
                let isDateValid = abitudine.dataFineValidita == nil || giorno <= abitudine.dataFineValidita!
                return isScheduledForDay && isDateValid
            }
            // Calcola la percentuale
            let percentuale = abitudiniFiltrate.isEmpty ? 0 : (Double(completamenti.count) / Double(abitudiniFiltrate.count)) * 100
            return DailyHabitCompletion(day: Constants.giorniSettimana[index], completion: percentuale)
        }
    }
    // MARK: - FUNCTIONS
    
    // Formattazione della data (giorno e mese)
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = Locale(identifier: "it_IT") // Imposta la lingua su italiano
        return formatter.string(from: date)
            .uppercased()
    }
    
    func formattedAnno(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.locale = Locale(identifier: "it_IT") // Imposta la lingua su italiano
        return formatter.string(from: date)
    }
    
    // Ottenere il giorno della settimana (lunedì, martedì, ecc.)
    func dayOfWeek(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "it_IT")
        return formatter.string(from: date)
            .capitalized
    }
    
    // Ottenere solo il numero del giorno (es. 25)
    func dayNumber(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    func getWeekRange(for date: Date) -> (startOfWeek: Date, endOfWeek: Date) {
        let startOfWeek = viewModel.getStartOfWeek(for: date)
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
        return (startOfWeek, endOfWeek)
    }
    
    
//MARK: FUNZIONE DI FILTRAGGIO PER GIORNO E MACROABITUDINE
func filtraAbitudiniPerGiornoSelezionato(_giornoSelezionato: Date?) -> [Abitudine] {
        // Filtra per macro abitudine
        let macroFiltered = viewModel.abitudini.filter { $0.macroAbitudine == macroAbitudine }
    guard let giornoSelezionato = viewModel.giornoSelezionato else {
        print ("nessun giorno selezionato. Ritorno lista vuota")
        return []
    }
        let filtrate = macroFiltered.filter { abitudine in
            let weekdayIndex = (Calendar.current.component(.weekday, from: giornoSelezionato) + 5) % 7
            let isScheduledForDay = abitudine.daysOfWeek[weekdayIndex]
            let isStartDateValid = giornoSelezionato >= abitudine.giorno
            let isDateValid = abitudine.dataFineValidita == nil || giornoSelezionato <= abitudine.dataFineValidita!
 
            return isDateValid && isScheduledForDay && isStartDateValid
        }
    print("abitudini filtrate per giorno \(giornoSelezionato) : \(filtrate.map{$0.nome})")
    return filtrate
    }
    
    func aggiornaAbitudini() {
            withAnimation {
                viewModel.abitudini = viewModel.abitudini
            }
        }
}
 
#Preview {
    HabitView(macroAbitudine: "Attività Fisica").environmentObject(AbitudiniViewModel())
    }

struct DailyHabitCompletion: Identifiable, Codable {
    let id = UUID()
    let day: String
    let completion: Double
}
