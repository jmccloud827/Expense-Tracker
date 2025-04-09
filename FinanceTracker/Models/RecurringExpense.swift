import SwiftData
import SwiftUI

@Model class RecurringExpense: Identifiable {
    var id = UUID()
    var name: String
    var type: `Type`
    var dateCreated = Date.now
    var expenses: [Expense] = []
    
    init(name: String, type: Type) {
        self.name = name
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
        case variable(estimate: Double)
        case fixed(cost: Double)
    }
    
    public static var samples: [RecurringExpense] = [
        .init(name: "Mortgage", type: .fixed(cost: 2_000)),
        .init(name: "Water", type: .variable(estimate: 50))
    ]
}
