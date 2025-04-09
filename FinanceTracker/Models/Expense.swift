import SwiftData
import SwiftUI

@Model class Expense: Identifiable {
    var id = UUID()
    var name: String
    var cost: Double
    var dateCreated = Date.now
    
    init(name: String, cost: Double) {
        self.name = name
        self.cost = cost
    }
}
