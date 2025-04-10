import Foundation
import SwiftData

@Model class RecurringExpense: Identifiable {
    var id = UUID()
    var name: String
    var cost: Double
    var type: `Type`
    var dateCreated = Date.now
    var expenses: [Expense] = []
    
    init(name: String, cost: Double, type: Type) {
        self.name = name
        self.cost = cost
        self.type = type
    }
    
    var averageExpense: Double {
        expenses.reduce(0) { $0 + $1.cost } / Double(expenses.count)
    }
    
    func addOrUpdateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        } else {
            expenses.append(expense)
        }
    }
    
    enum `Type`: Codable {
        case variable
        case fixed
    }
    
    public static var samples: [RecurringExpense] = [
        .init(name: "Mortgage", cost: 2_000, type: .fixed),
        .init(name: "Water", cost: 50, type: .variable)
    ]
}
