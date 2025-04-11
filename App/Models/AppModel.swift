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
        model.monthlyExpenses = [
            .init(name: "Mortgage", cost: 2_000, type: .fixed),
            .init(name: "Water", cost: 50, type: .variable),
            .init(name: "Credit Card", cost: 5_500, type: .variable)
        ]
        let currentYearID = Calendar.current.component(.year, from: Date.now)
        let currentYear = Year(id: currentYearID)
        let currentMonthID = Calendar.current.component(.month, from: Date.now)
        for monthID in 1 ... currentMonthID {
            let month = Month(integer: monthID, income: model.monthlyIncome, expenses: model.monthlyExpenses.map { .init(recurringExpense: $0) })
            for expenseModel in month.expenses {
                if let recurringExpense = expenseModel.recurringExpense,
                   recurringExpense.type == .variable {
                    expenseModel.expense.cost = expenseModel.expense.cost * (Double.random(in: 0.5 ... 1.5))
                }
            }
            currentYear.months.append(month)
        }
        model.years.append(currentYear)
        
        let previousYear = Year(id: currentYearID - 1)
        for monthID in 1 ... 12 {
            let month = Month(integer: monthID, income: model.monthlyIncome, expenses: model.monthlyExpenses.map { .init(recurringExpense: $0) })
            for expenseModel in month.expenses {
                if let recurringExpense = expenseModel.recurringExpense,
                   recurringExpense.type == .variable {
                    expenseModel.expense.cost = expenseModel.expense.cost * (Double.random(in: 0.5 ... 1.5))
                }
            }
            previousYear.months.append(month)
        }
        model.years.append(previousYear)
        
        return model
    }
}

enum IncomeType: String, CaseIterable, Codable {
    case yearly = "Yearly"
    case monthly = "Monthly"
}
