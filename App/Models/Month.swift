import Foundation
import SwiftData

@Model class Month: Identifiable {
    var id = UUID()
    var integer: Int
    var incomes: [IncomeModel]
    var expenses: [ExpenseModel]
    
    init(integer: Int, incomes: [IncomeModel], expenses: [ExpenseModel]) {
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
        expenses.reduce(0) { $0 + $1.expense.cost }
    }
    
    var totalIncomes: Double {
        incomes.reduce(0) { $0 + $1.income.amount }
    }
    
    var netIncome: Double {
        totalIncomes - totalExpenses
    }
}

extension Month {
    @Model class IncomeModel: Identifiable {
        var id = UUID()
        var income: Income
        var recurringIncome: RecurringIncome?
        var dateCreated = Date.now
        
        init(name: String, amount: Double) {
            self.income = .init(name: name, amount: amount)
        }
        
        init(recurringIncome: RecurringIncome) {
            self.income = .init(name: recurringIncome.name, amount: recurringIncome.amount)
            self.recurringIncome = recurringIncome
        }
        
        var name: String {
            recurringIncome?.name ?? income.name
        }
    }
    
    @Model class ExpenseModel: Identifiable {
        var id = UUID()
        var expense: Expense
        var recurringExpense: RecurringExpense?
        var dateCreated = Date.now
        
        init(name: String, cost: Double) {
            self.expense = .init(name: name, cost: cost)
        }
        
        init(recurringExpense: RecurringExpense) {
            self.expense = .init(name: recurringExpense.name, cost: recurringExpense.cost)
            self.recurringExpense = recurringExpense
        }
        
        var name: String {
            recurringExpense?.name ?? expense.name
        }
    }
}
