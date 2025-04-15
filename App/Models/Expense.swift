import Foundation
import SwiftData

@Model final class Expense: Identifiable {
    var id = UUID()
    var name: String = ""
    var cost: Double = 0.0
    var dateCreated = Date.now
    var recurringID: UUID?
    var month: Month?
    
    init(name: String, cost: Double) {
        self.name = name
        self.cost = cost
    }
    
    init(recurringExpense: RecurringExpense) {
        self.name = recurringExpense.name
        self.cost = recurringExpense.cost
        self.recurringID = recurringExpense.id
    }
}
