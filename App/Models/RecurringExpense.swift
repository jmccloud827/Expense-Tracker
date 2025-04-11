import Foundation
import SwiftData

@Model class RecurringExpense: Identifiable {
    var id = UUID()
    var name: String
    var cost: Double
    var type: `Type`
    var dateCreated = Date.now
    
    init(name: String, cost: Double, type: Type) {
        self.name = name
        self.cost = cost
        self.type = type
    }
    
    enum `Type`: Codable {
        case variable
        case fixed
    }
}
