import SwiftData
import SwiftUI

@Model
class RecurringExpense: Identifiable {
    var id = UUID()
    var name: String
    var type: `Type`
    var costs: [Int] = []
    
    init(name: String, type: `Type`) {
        self.name = name
        self.type = type
    }
    
    var averageCost: Int {
        costs.reduce(0, +) / costs.count
    }
    
    func addCost(_ cost: Int) {
        costs.append(cost)
    }
    
    enum `Type`: Codable {
        case variable
        case fixed(cost: Int)
    }
}
