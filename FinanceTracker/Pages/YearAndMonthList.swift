import SwiftData
import SwiftUI

struct YearAndMonthList: View {
    @Environment(\.modelContext) private var modelContext
    
    @Environment(IncomeAndMonthlyExpenses.self) private var incomeAndExpenseModel
    
    @Query(sort: \Year.id, order: .reverse) private var years: [Year]
    
    var body: some View {
        List {
            ForEach(years, id: \.id) { year in
                Section(String(year.id)) {
                    ForEach(year.sortedMonths, id: \.id) { month in
                        Text(month.name)
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
            addMonthIfDoesNotExists(currentYear: currentYear)
        } else {
            let year = Year(id: currentYearID)
            addMonthIfDoesNotExists(currentYear: year)
            modelContext.insert(year)
        }
    }
    
    private func addMonthIfDoesNotExists(currentYear: Year) {
        let currentMonthID = Calendar.current.component(.month, from: Date.now)
        for month in (currentYear.sortedMonths.first?.integer ?? currentMonthID) ... currentMonthID {
            currentYear.months.append(
                .init(integer: month,
                      income: incomeAndExpenseModel.monthlyIncome,
                      expenses: incomeAndExpenseModel.expenses.map { .init(recurringExpense: $0) })
            )
        }
    }
}

#Preview {
    NavigationStack {
        YearAndMonthList()
    }
    .modelContainer(App.previewContainer)
    .environment(IncomeAndMonthlyExpenses.sample)
}
