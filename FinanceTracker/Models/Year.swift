import SwiftData

@Model class Year: Identifiable {
    var id: Int
    var months: [Month] = []
    
    init(id: Int) {
        self.id = id
    }
    
    var sortedMonths: [Month] {
        months.sorted { $0.integer > $1.integer }
    }
}
