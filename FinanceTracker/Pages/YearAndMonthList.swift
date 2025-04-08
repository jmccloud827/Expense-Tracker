import SwiftUI
import SwiftData

struct YearAndMonthList: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Year.id, order: .reverse) private var years: [Year]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(years, id: \.id) { year in
                    Section(String(year.id)) {
                        ForEach(year.sortedMonths, id: \.id) { month in
                            Text(month.name)
                        }
                    }
                }
            }
        }
        .onAppear {
            addYearOrMonthIfDoesNotExists()
        }
    }
    
    private func addYearOrMonthIfDoesNotExists() {
        let currentYearID = Calendar.current.component(.year, from: Date.now)
        if let currentYear = years.first(where: { $0.id == currentYearID }) {
            let currentMonthID = Calendar.current.component(.month, from: Date.now)
            for month in (currentYear.sortedMonths.first?.integer ?? currentMonthID) ... currentMonthID {
                currentYear.months.append(.init(integer: month))
            }
        } else {
            modelContext.insert(Year(id: currentYearID))
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Year.self, configurations: config)
    
    return YearAndMonthList()
        .modelContainer(container)
}
