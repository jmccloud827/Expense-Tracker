import Foundation
import SwiftData

@Model class AppModel: Identifiable {
    var id = UUID()
    var income: Double = 0
    var incomeType: IncomeType = IncomeType.yearly
    var paychecks: [Double] = []
    var monthlyExpenses: [RecurringExpense] = []
    var years: [Year] = []
    var dateCreated = Date.now
    
    init() {}
    
    var currentYear: Year? {
        years.first(where: { $0.id == Calendar.current.component(.year, from: Date.now) })
    }
    
    var currentMonth: Month? {
        currentYear?.months.first(where: { $0.integer == Calendar.current.component(.month, from: Date.now) })
    }
    
    var monthlyIncome: Double {
        switch incomeType {
        case .yearly:
            return income / 12
        case .monthly:
            return income
        }
    }
    
    var averagePaycheck: Double {
        paychecks.reduce(0, +) / Double(paychecks.count)
    }
    
    var totalMonthlyExpenses: Double {
        monthlyExpenses.reduce(0) { $0 + $1.cost }
    }
    
    func addYearOrMonthIfDoesNotExists() {
        let currentYearID = Calendar.current.component(.year, from: Date.now)
        let currentMonthID = Calendar.current.component(.month, from: Date.now)
        if let currentYear = years.first(where: { $0.id == currentYearID }) {
            let lastMonthIDInDatabase = currentYear.sortedMonths.first?.integer
            if let lastMonthIDInDatabase,
               lastMonthIDInDatabase < currentMonthID {
                for month in (lastMonthIDInDatabase + 1) ... currentMonthID {
                    currentYear.months.append(
                        .init(integer: month,
                              income: monthlyIncome,
                              expenses: monthlyExpenses.map { .init(recurringExpense: $0) })
                    )
                }
            }
        } else {
            let year = Year(id: currentYearID)
            year.months.append(
                .init(integer: currentMonthID,
                      income: monthlyIncome,
                      expenses: monthlyExpenses.map { .init(recurringExpense: $0) })
            )
            years.append(year)
        }
    }
    
    func getExpensesFor(recurringExpense: RecurringExpense) -> [(year: Int, months: [(month: String, cost: Double)])] {
        var expenses: [(year: Int, months: [(month: String, cost: Double)])] = []
        for year in years {
            var monthExpenses: [(month: String, cost: Double)] = []
            for month in year.months {
                monthExpenses.append(contentsOf: month.expenses.filter {
                    $0.recurringExpense?.id == recurringExpense.id
                }.map {
                    (month.name, $0.expense.cost)
                })
            }
            
            expenses.append((year.id, monthExpenses))
        }
        
        return expenses
    }
    
    static var sample: AppModel {
        let model = AppModel()
        model.income = 90_000
        model.incomeType = .yearly
        model.monthlyExpenses = RecurringExpense.samples
        model.addYearOrMonthIfDoesNotExists()
        
        return model
    }
}

enum IncomeType: String, CaseIterable, Codable {
    case yearly = "Yearly"
    case monthly = "Monthly"
}
