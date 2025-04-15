import Foundation
import SwiftData

@Model final class RecurringExpense: Identifiable {
    var id = UUID()
    var name: String = ""
    var cost: Double = 0.0
    var type: `Type` = `Type`.fixed
    var dateCreated = Date.now
    var appModel: AppModel?
    
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
