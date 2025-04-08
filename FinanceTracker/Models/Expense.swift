import SwiftData
import SwiftUI

@Model
class Expense: Identifiable {
    var id = UUID()
    var backingName: String?
    var cost: Int?
    var recurringExpense: RecurringExpense?
    
    init(name: String, cost: Int?) {
        self.backingName = name
        self.cost = cost
    }
    
    init(recurringExpense: RecurringExpense) {
        self.recurringExpense = recurringExpense
        if case let .fixed(cost) = recurringExpense.type {
            self.cost = cost
        }
    }
    
    var name: String {
        backingName ?? recurringExpense?.name ?? "Unknown Expense"
    }
    
    func addCost(_ cost: Int) {
        self.cost = cost
        if let recurringExpense = self.recurringExpense {
            recurringExpense.addCost(cost)
        }
    }
}
