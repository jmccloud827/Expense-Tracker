import Foundation
import SwiftData

@Model final class Income: Identifiable {
    var id = UUID()
    var name: String = ""
    var amount: Double = 0.0
    var dateCreated = Date.now
    var incomeModel: Month.IncomeModel?
    
    init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
    }
}
