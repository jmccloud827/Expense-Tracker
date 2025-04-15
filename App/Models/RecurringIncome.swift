import Foundation
import SwiftData

@Model final class RecurringIncome: Identifiable {
    var id = UUID()
    var name: String = ""
    var amount: Double = 0.0
    var type: `Type` = `Type`.fixed
    var dateCreated = Date.now
    var appModel: AppModel?
    
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
