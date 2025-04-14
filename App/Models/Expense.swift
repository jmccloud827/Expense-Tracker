import Foundation
import SwiftData

@Model final class Expense: Identifiable {
    var id = UUID()
    var name: String = ""
    var cost: Double = 0.0
    var dateCreated = Date.now
    var expenseModel: Month.ExpenseModel?
    
    init(name: String, cost: Double) {
        self.name = name
        self.cost = cost
    }
}
