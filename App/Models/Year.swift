import SwiftData

@Model final class Year: Identifiable {
    var id: Int = 0
    @Relationship(deleteRule: .cascade, inverse: \Month.year) private var monthsBackingData: [Month]?
    var appModel: AppModel?
    
    var months: [Month] {
        get { monthsBackingData ?? [] }
        set { monthsBackingData = newValue }
    }
    
    init(id: Int) {
        self.id = id
    }
    
    var sortedMonths: [Month] {
        months.sorted { $0.integer > $1.integer }
    }
}
