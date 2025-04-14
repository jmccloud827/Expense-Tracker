import Foundation
import SwiftData

@Model class RecurringIncome: Identifiable {
    var id = UUID()
    var name: String
    var amount: Double
    var type: `Type`
    var dateCreated = Date.now
    
    init(name: String, amount: Double, type: Type) {
        self.name = name
        self.amount = amount
        self.type = type
    }
    
    enum `Type`: Codable {
        case variable
        case fixed
    }
}
