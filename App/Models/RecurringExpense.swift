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
    
    public static var samples: [RecurringExpense] = [
        .init(name: "Mortgage", cost: 2_000, type: .fixed),
        .init(name: "Water", cost: 50, type: .variable)
    ]
}
