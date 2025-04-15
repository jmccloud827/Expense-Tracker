import Foundation
import SwiftData

@Model final class Income: Identifiable {
    var id = UUID()
    var name: String = ""
    var amount: Double = 0.0
    var dateCreated = Date.now
    var recurringID: UUID?
    var month: Month?
    
    init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
    }
    
    init(recurringIncome: RecurringIncome) {
        self.name = recurringIncome.name
        self.amount = recurringIncome.amount
        self.recurringID = recurringIncome.id
    }
}
