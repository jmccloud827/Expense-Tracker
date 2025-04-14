import Foundation
import SwiftData

@Model class AppModel: Identifiable {
    var id = UUID()
    var monthlyIncomes: [RecurringIncome] = []
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
    
    var totalMonthlyIncome: Double {
        monthlyIncomes.reduce(0) { $0 + $1.amount }
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
                              incomes: monthlyIncomes.map { .init(recurringIncome: $0) },
                              expenses: monthlyExpenses.map { .init(recurringExpense: $0) })
                    )
                }
            }
        } else {
            let year = Year(id: currentYearID)
            year.months.append(
                .init(integer: currentMonthID,
                      incomes: monthlyIncomes.map { .init(recurringIncome: $0) },
                      expenses: monthlyExpenses.map { .init(recurringExpense: $0) })
            )
            years.append(year)
        }
    }
    
    func getIncomes(for recurringIncome: RecurringIncome) -> [(year: Int, months: [(month: String, amount: Double)])] {
        years.map { year in
            let monthExpenses = year.months.flatMap { month in
                month.incomes.filter { $0.recurringIncome?.id == recurringIncome.id }
                    .map { (month.name, $0.income.amount) }
            }
            return (year.id, monthExpenses)
        }
    }
    
    func getExpenses(for recurringExpense: RecurringExpense) -> [(year: Int, months: [(month: String, cost: Double)])] {
        years.map { year in
            let monthExpenses = year.months.flatMap { month in
                month.expenses.filter { $0.recurringExpense?.id == recurringExpense.id }
                    .map { (month.name, $0.expense.cost) }
            }
            return (year.id, monthExpenses)
        }
    }
    
    static var sample: AppModel {
        let model = AppModel()
        model.monthlyIncomes = [
            .init(name: "Paycheck", amount: 90000.0 / 12, type: .fixed),
            .init(name: "Intrest", amount: 50, type: .variable)
        ]
        model.monthlyExpenses = [
            .init(name: "Mortgage", cost: 2_000, type: .fixed),
            .init(name: "Water", cost: 50, type: .variable),
            .init(name: "Credit Card", cost: 5_500, type: .variable)
        ]
        let currentYearID = Calendar.current.component(.year, from: Date.now)
        let currentYear = Year(id: currentYearID)
        let currentMonthID = Calendar.current.component(.month, from: Date.now)
        for monthID in 1 ... currentMonthID {
            let month = Month(integer: monthID, incomes: model.monthlyIncomes.map { .init(recurringIncome: $0) }, expenses: model.monthlyExpenses.map { .init(recurringExpense: $0) })
            for incomeModel in month.incomes {
                if let recurringIncome = incomeModel.recurringIncome,
                   recurringIncome.type == .variable {
                    incomeModel.income.amount = recurringIncome.amount * (Double.random(in: 0.5 ... 1.5))
                }
            }
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
            let month = Month(integer: monthID, incomes: model.monthlyIncomes.map { .init(recurringIncome: $0) }, expenses: model.monthlyExpenses.map { .init(recurringExpense: $0) })
            for incomeModel in month.incomes {
                if let recurringIncome = incomeModel.recurringIncome,
                   recurringIncome.type == .variable {
                    incomeModel.income.amount = recurringIncome.amount * (Double.random(in: 0.5 ... 1.5))
                }
            }
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
