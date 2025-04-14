import Foundation
import SwiftData

@Model final class Month: Identifiable {
    var id = UUID()
    var integer: Int = 0
    @Relationship(inverse: \IncomeModel.month) private var incomesBackingData: [IncomeModel]?
    @Relationship(inverse: \ExpenseModel.month) private var expensesBackingData: [ExpenseModel]?
    var year: Year?
    
    var incomes: [IncomeModel] {
        get { incomesBackingData ?? [] }
        set { incomesBackingData = newValue }
    }
    
    var expenses: [ExpenseModel] {
        get { expensesBackingData ?? [] }
        set { expensesBackingData = newValue }
    }
    
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
        @Relationship(inverse: \Income.incomeModel) private var incomeBackingData: Income?
        @Relationship(inverse: \RecurringIncome.incomeModel) var recurringIncome: RecurringIncome?
        var dateCreated = Date.now
        var month: Month?
        
        var income: Income {
            get { incomeBackingData ?? .init(name: "", amount: 0) }
            set { incomeBackingData = newValue }
        }
        
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
        @Relationship(inverse: \Expense.expenseModel) private var expenseBackingData: Expense?
        @Relationship(inverse: \RecurringExpense.expenseModel) var recurringExpense: RecurringExpense?
        var dateCreated = Date.now
        var month: Month?
        
        var expense: Expense {
            get { expenseBackingData ?? .init(name: "", cost: 0) }
            set { expenseBackingData = newValue }
        }
        
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
