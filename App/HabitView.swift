//
//  Attività fisica.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 27/11/24.
//


import SwiftUI
import Charts

// problema: disconessione tra rettangolo bianco e grafico e giorno all'inizio dell'apertura della schermata
// il grafico funziona però fa una media in base a quante abitudini hai inserito

// Modello per una singola abitudine
struct Abitudine: Identifiable {
    let id = UUID()
    var nome: String
    var orario: String
    var giorno: Date
    var completata: Bool
    var daysOfWeek : [Bool]
    var completamentiGiorni :[Bool]
    var completamentiDate: [Date: Bool] = [:]
    var dataFineValidita: Date?
    var macroAbitudine: String
}
 
// ViewModel per gestire le abitudini
class AbitudiniViewModel: ObservableObject {
    @Published var abitudini : [Abitudine] = []
    
    init() {
        aggiungiAbitudine(nome: "Esercizi mattutini", orario: "07:00", giorno: Date(), giorniSelezionati: [true, true, true, true, false, true, true],  macroAbitudine: "Attività Fisica")
        }
    
    func aggiungiAbitudine(nome: String, orario: String, giorno: Date, giorniSelezionati: [Bool], macroAbitudine: String){
 
        let nuovaAbitudine = Abitudine(
            nome: nome,
            orario: orario,
            giorno: giorno,
            completata: false,
            daysOfWeek : giorniSelezionati,
            completamentiGiorni: [false],
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
            // Rimuove la validità solo per il giorno specifico
            // credo che qua sta il problema
            abitudini[index].completamentiDate[giorno] = true
        }
    }
    
    func spuntaAbitudine(id: UUID, giorno: Date) {
        if let index = abitudini.firstIndex(where: { $0.id == id }) {
            // Verifica lo stato attuale e alterna
            let attualeStato = abitudini[index].completamentiDate[giorno] ?? false
            abitudini[index].completamentiDate[giorno] = !attualeStato
            
        }
    }
    
    
    
}
class Constants {
    static let giorniSettimana = ["Lun", "Mar", "Mer", "Gio", "Ven", "Sab", "Dom"]
}

struct HabitView: View {
    
    var macroAbitudine: String
    @State private var dataCorrente = Date()
    @State private var nomeAbitudine = ""
    @State private var orarioAbitudine = ""
    @StateObject var viewModel = AbitudiniViewModel()
    @State private var giornoSelezionato: Date? = Date()
    let calendar = Calendar.current
    @State var newhabit: Bool = false
    @State private var abitudineDaModificare: Abitudine?
    
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
            }
        }
        .environmentObject(viewModel)
    }
    // MARK: Componenti Estratti
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
            ForEach(filtraAbitudiniPerGiornoSelezionato(giornoSelezionato)) { abitudine in
                singolaAbitudine(abitudine: abitudine)
            }
            Spacer().frame(height: 80)
        }
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
                        .foregroundColor(.blue)
                }
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 10) {
                    ForEach(0..<7) { index in
                        let giorno = getStartOfWeek(for: dataCorrente).addingTimeInterval(Double(index * 86400))
                        giornoCalendario(giorno: giorno)
                    }
                }
                Button(action: {
                    cambiaSettimana(delta: 1)
                }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            }
        }
    }
    func giornoCalendario(giorno: Date) -> some View {
        VStack {
            Text(dayOfWeek(for: giorno))
                .font(.headline)
                .foregroundColor(.blue)
            Text(dayNumber(for: giorno))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .background(
            calendar.isDate(giorno, inSameDayAs: giornoSelezionato ?? Date())
                ? Color.blue.opacity(0.4)
                : Color.clear
        )
        .cornerRadius(10)
        .onTapGesture {
            giornoSelezionato = giorno
        }
    }
    func cambiaSettimana(delta: Int) {
        dataCorrente = Calendar.current.date(byAdding: .weekOfYear, value: delta, to: dataCorrente)!
        giornoSelezionato = getStartOfWeek(for: dataCorrente)
    }
    
    func singolaAbitudine(abitudine: Abitudine) -> some View {
        HStack {
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
            Spacer()
            menuAbitudine(abitudine: abitudine)
        }
        .padding()
        .background(
            (giornoSelezionato != nil &&
             (abitudine.completamentiDate[giornoSelezionato!] ?? false))
                ? Color.pink.opacity(0.4)
                : Color.white
        )
        .cornerRadius(30)
        .shadow(radius: 5)
        .onTapGesture {
            if let giornoSelezionato = giornoSelezionato {
                viewModel.spuntaAbitudine(id: abitudine.id, giorno: giornoSelezionato)
            }
        }
    }
    
    func menuAbitudine(abitudine: Abitudine) -> some View {
        Menu {
            Button(role: .destructive) {
                viewModel.eliminaAbitudine(id: abitudine.id, daData: giornoSelezionato ?? Date())
            } label: {
                Label("Elimina per sempre", systemImage: "trash")
            }
            Button {
                if let giornoSelezionato = giornoSelezionato {
                    viewModel.eliminaSoloPerUnGiorno(id: abitudine.id, giorno: giornoSelezionato)
                }
            } label: {
                Label("Elimina solo oggi", systemImage: "calendar.badge.minus")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
    }

/*struct HabitView: View {
    
    var macroAbitudine: String
    
    @State private var dataCorrente = Date()
    @State private var nomeAbitudine = ""
    @State private var orarioAbitudine = ""
    @StateObject var viewModel = AbitudiniViewModel()
    @State private var giornoSelezionato: Date? = Date()
    let calendar = Calendar.current
   
    @State var newhabit: Bool = false
    @State private var abitudineDaModificare: Abitudine?
    
    var body: some View {
       
        NavigationView{
                ZStack{
                    LinearGradient(colors: [Color("verdino"),Color("bluino")], startPoint: .bottomLeading, endPoint: .topTrailing)
                        .edgesIgnoringSafeArea(.all)
                    ScrollView{
                    VStack {
                        
                        Text(macroAbitudine)
                            .font(.largeTitle)
                            .bold()
                        // Calendario settimanale
                        calendarioSettimana
                        
                        
                        // Sezione per aggiungere nuove abitudini
                        Button(action:{
                            newhabit.toggle()
                            
                        },label:{
                            Image(systemName:"plus")
                            
                        }).sheet(isPresented: $newhabit) {
                            CreateHabitView(viewModel: viewModel, macroAbitudine: macroAbitudine)
                        }
                        
                       
                         
                        VStack {
                            ForEach(filtraAbitudiniPerGiornoSelezionato(giornoSelezionato)) { abitudine in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(abitudine.nome)
                                            .font(.headline)
                                        Text("Orario: \(abitudine.orario)")
                                            .font(.subheadline)
                                        
                                        let selectedIndices = abitudine.daysOfWeek.indices.filter { abitudine.daysOfWeek[$0] }
                                        let giorniNomi = selectedIndices.map { Constants.giorniSettimana[$0] }
                                        let giorni = giorniNomi.joined(separator: ", ")
 
                                        Text("Giorni selezionati: \(giorni)")
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                    Menu {
                                        Button(role: .destructive) {
                                            viewModel.eliminaAbitudine(id: abitudine.id, daData: giornoSelezionato ?? Date())
                                        } label: {
                                            Label("Elimina per sempre", systemImage: "trash")
                                        }
                                        Button {
                                                if let giornoSelezionato = giornoSelezionato {
                                                    viewModel.eliminaSoloPerUnGiorno(id: abitudine.id, giorno: giornoSelezionato)
                                                }
                                            } label: {
                                                Label("Elimina solo oggi", systemImage: "calendar.badge.minus")
                                            }
                                        // se hai tempo da perdere caèisci come funziona
                                        /*Button {
                                            abitudineDaModificare = abitudine
                                            newhabit = true
                                        } label: {
                                            Label("Modifica", systemImage: "pencil")
                                        }*/
                                    } label: {
                                        Image(systemName: "ellipsis.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                    }
                                    
                                }
                                .padding()
                                .background(
                                    (giornoSelezionato != nil &&
                                     (abitudine.completamentiDate[giornoSelezionato!] ?? false))
                                        ? Color.pink.opacity(0.4)
                                        : Color.white
                                )
                                // .animation(.easeInOut(duration: 0.3),value : abitudine.completata)
                                .cornerRadius(30)
                                .shadow(radius: 5)
                                .onTapGesture{
                                    if let giornoSelezionato = giornoSelezionato {
                                            viewModel.spuntaAbitudine(id: abitudine.id, giorno: giornoSelezionato)
                                        }
                                }
                                .sheet(isPresented: $newhabit) {
                                    CreateHabitView(viewModel: viewModel)
                                        
                                }
                            }
                            Spacer()
                                .frame(height: 80)
                            graficoPercentualeCompletamento
                        }
                        .padding()
                        
                        
     
                    }
                    .onAppear {
                        
                        giornoSelezionato = Date()
                       
                        
                                    }
                    
                    
                }.scrollIndicators(.hidden)
      }
}
        .environmentObject(viewModel)
    }
    //MARK: VAR
    // Sezione del calendario settimanale
    var calendarioSettimana: some View {
        VStack {
            Text("\(formattedDate(dataCorrente))"+" \(formattedAnno(dataCorrente)) ")
              .font(.headline)
            HStack {
                Button(action: {
                    dataCorrente = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: dataCorrente)!
                    giornoSelezionato = getStartOfWeek(for: dataCorrente)
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
                
               // Spacer()
                    
                // Griglia settimanale
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 10) {
                    ForEach(0..<7) { index in
                        
                        let giorno = getStartOfWeek(for: dataCorrente).addingTimeInterval(Double(index * 86400)) // Aggiungiamo 86400 secondi (1 giorno)
                       
                        VStack {
                            Text(dayOfWeek(for: giorno))
                                .font(.headline)
                                .foregroundColor(.blue)
                                
                            
                            Text(dayNumber(for: giorno))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .background(
                            
                            calendar.isDate(giorno, inSameDayAs: giornoSelezionato ?? Date())
                                ? Color.blue.opacity(0.4)
                                : Color.clear
                        )
                        
                        .cornerRadius(10)
                        .onTapGesture {
                            giornoSelezionato = giorno
                        }
                    }
                }
                
               
               
                
              //  Spacer()
                
                Button(action: {
                    dataCorrente = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: dataCorrente)!
                    giornoSelezionato = getStartOfWeek(for: dataCorrente)
                }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            
            
        }
    }
 */
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
    
       
    // MARK: - FUNCTIONS
    
    
    func calcolaPercentualeCompletamentoSettimanale() -> [DailyHabitCompletion] {
        let startOfWeek = getStartOfWeek(for: dataCorrente)
        // Genera i giorni della settimana
        let giorniSettimana = (0..<7).map { startOfWeek.addingTimeInterval(Double($0 * 86400)) }
     
        return giorniSettimana.enumerated().map { index, giorno in
            // Filtra completamenti per il giorno
            let completamenti = viewModel.abitudini.filter {
                $0.completamentiDate[giorno] == true
            }
            // Calcola la percentuale
            let percentuale = completamenti.isEmpty ? 0 : (Double(completamenti.count) / Double(viewModel.abitudini.count)) * 100
            return DailyHabitCompletion(
                day: Constants.giorniSettimana[index],
                completion: percentuale
            )
        }
    }
    
    
    
    // Ottenere la data del lunedì della settimana corrente
    func getStartOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let firstWeekday = calendar.firstWeekday
        let daysToSubtract = (weekday - firstWeekday + 7) % 7
        return calendar.date(byAdding: .day, value: -daysToSubtract, to: date)!
    }
    
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
        let startOfWeek = getStartOfWeek(for: date)
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
        return (startOfWeek, endOfWeek)
    }
    
    
    
    func filtraAbitudiniPerGiornoSelezionato(_ giornoSelezionato: Date?) -> [Abitudine] {
        guard let giornoSelezionato = giornoSelezionato else { return [] }
     
        // Filtra per macro abitudine
        let macroFiltered = viewModel.abitudini.filter { $0.macroAbitudine == macroAbitudine }
        
        return macroFiltered.filter { abitudine in
                
                let isDateValid = abitudine.dataFineValidita == nil || giornoSelezionato <= abitudine.dataFineValidita!
                return isDateValid
            }
    }
}
 
#Preview {
    HabitView(macroAbitudine: "Attività Fisica") // Passa un valore di esempio per macroAbitudine
             
    }


          
struct DailyHabitCompletion: Identifiable {
    let id = UUID()
    let day: String
    let completion: Double
}
