import SwiftData
import SwiftUI

@Model class IncomeAndMonthlyExpenses: Identifiable {
    var id = UUID()
    var income: Double = 0
    var incomeType: IncomeType = IncomeType.yearly
    var paychecks: [Double] = []
    var expenses: [RecurringExpense] = []
    var dateCreated = Date.now
    
    init() {}
    
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
    
    var totalExpenses: Double {
        expenses.reduce(0) { result, expense in
            switch expense.type {
            case let .fixed(cost):
                return result + cost
            case let .variable(estimate):
                return result + estimate
            }
        }
    }
    
    static var sample: IncomeAndMonthlyExpenses {
        var model = IncomeAndMonthlyExpenses()
        model.income = 90_000
        model.incomeType = .yearly
        model.expenses = RecurringExpense.samples
        
        return model
    }
}

enum IncomeType: String, CaseIterable, Codable {
    case yearly = "Yearly"
    case monthly = "Monthly"
}
