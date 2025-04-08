import SwiftData
import SwiftUI

struct RecurringExpenseList: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Year.self, configurations: config)
    
    return RecurringExpenseList()
        .modelContainer(container)
}
