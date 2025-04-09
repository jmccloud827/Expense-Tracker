import SwiftData
import SwiftUI

@Model class Month: Identifiable {
    var id = UUID()
    var integer: Int
    var income: Double
    var expenses: [ExpenseModel] = []
    
    init(integer: Int, income: Double, expenses: [ExpenseModel]) {
        self.integer = integer
        self.income = income
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
}

extension Month {
    @Model class ExpenseModel: Identifiable {
        var id = UUID()
        var expense: Expense
        var recurringExpense: RecurringExpense?
        var dateCreated = Date.now
        
        init(name: String, cost: Double) {
            self.expense = .init(name: name, cost: cost)
        }
        
        init(recurringExpense: RecurringExpense) {
            self.recurringExpense = recurringExpense
            switch recurringExpense.type {
            case let .fixed(cost):
                self.expense = .init(name: recurringExpense.name, cost: cost)
            case let .variable(estimate):
                self.expense = .init(name: recurringExpense.name, cost: estimate)
            }
        }
        
        var name: String {
            recurringExpense?.name ?? expense.name
        }
        
        func addCost(_ cost: Double) {
            self.expense.cost = cost
            if let recurringExpense = self.recurringExpense {
                recurringExpense.addOrUpdateExpense(self.expense)
            }
        }
    }
}
