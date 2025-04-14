import Foundation
import SwiftData

@Model class Income: Identifiable {
    var id = UUID()
    var name: String
    var amount: Double
    var dateCreated = Date.now
    
    init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
    }
}
