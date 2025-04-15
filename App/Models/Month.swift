import Foundation
import SwiftData

@Model final class Month: Identifiable {
    var id = UUID()
    var integer: Int = 0
    @Relationship(deleteRule: .cascade, inverse: \Income.month) private var incomesBackingData: [Income]?
    @Relationship(deleteRule: .cascade, inverse: \Expense.month) private var expensesBackingData: [Expense]?
    var year: Year?
    
    var incomes: [Income] {
        get { incomesBackingData ?? [] }
        set { incomesBackingData = newValue }
    }
    
    var expenses: [Expense] {
        get { expensesBackingData ?? [] }
        set { expensesBackingData = newValue }
    }
    
    init(integer: Int, incomes: [Income], expenses: [Expense]) {
        self.integer = integer
        self.incomes = incomes
        self.expenses = expenses
    }
    
    var name: String {
        switch integer {
        case 1: "January"
        case 2: "February"
        case 3: "March"
        case 4: "April"
        case 5: "May"
        case 6: "June"
        case 7: "July"
        case 8: "August"
        case 9: "September"
        case 10: "October"
        case 11: "November"
        case 12: "December"
        default: ""
        }
    }
    
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.cost }
    }
    
    var totalIncomes: Double {
        incomes.reduce(0) { $0 + $1.amount }
    }
    
    var netIncome: Double {
        totalIncomes - totalExpenses
    }
}
