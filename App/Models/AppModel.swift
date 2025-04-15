import Foundation
import SwiftData

@Model final class AppModel: Identifiable {
    var id = UUID()
    @Relationship(deleteRule: .cascade, inverse: \RecurringIncome.appModel) private var monthlyIncomesBackingData: [RecurringIncome]? = []
    @Relationship(deleteRule: .cascade, inverse: \RecurringExpense.appModel) private var monthlyExpensesBackingData: [RecurringExpense]? = []
    @Relationship(deleteRule: .cascade, inverse: \Year.appModel) private var yearsBackingData: [Year]? = []
    var dateCreated = Date.now
    
    var monthlyIncomes: [RecurringIncome] {
        get { monthlyIncomesBackingData ?? [] }
        set { monthlyIncomesBackingData = newValue }
    }
    
    var monthlyExpenses: [RecurringExpense] {
        get { monthlyExpensesBackingData ?? [] }
        set { monthlyExpensesBackingData = newValue }
    }
    
    var years: [Year] {
        get { yearsBackingData ?? [] }
        set { yearsBackingData = newValue }
    }
    
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
                month.incomes.filter { $0.recurringID == recurringIncome.id }
                    .map { (month.name, $0.amount) }
            }
            return (year.id, monthExpenses)
        }
    }
    
    func getExpenses(for recurringExpense: RecurringExpense) -> [(year: Int, months: [(month: String, cost: Double)])] {
        years.map { year in
            let monthExpenses = year.months.flatMap { month in
                month.expenses.filter { $0.recurringID == recurringExpense.id }
                    .map { (month.name, $0.cost) }
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
            currentYear.months.append(createMonth(id: monthID, model: model))
        }
        model.years.append(currentYear)
        
        let previousYear = Year(id: currentYearID - 1)
        for monthID in 1 ... 12 {
            previousYear.months.append(createMonth(id: monthID, model: model))
        }
        model.years.append(previousYear)
        
        return model
    }
    
    private static func createMonth(id: Int, model: AppModel) -> Month {
        let month = Month(integer: id, incomes: model.monthlyIncomes.map { .init(recurringIncome: $0) }, expenses: model.monthlyExpenses.map { .init(recurringExpense: $0) })
        for income in month.incomes {
            if let recurringID = income.recurringID,
               let recurringIncome = model.monthlyIncomes.first(where: { $0.id == recurringID }),
               recurringIncome.type == .variable {
                income.amount = recurringIncome.amount * (Double.random(in: 0.5 ... 1.5))
            }
        }
        for expense in month.expenses {
            if let recurringID = expense.recurringID,
               let recurringExpense = model.monthlyExpenses.first(where: { $0.id == recurringID }),
               recurringExpense.type == .variable {
                expense.cost = recurringExpense.cost * (Double.random(in: 0.5 ... 1.5))
            }
        }
        
        return month
    }
}
