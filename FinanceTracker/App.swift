import SwiftUI

@main
struct FinanceTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            YearAndMonthList()
        }
        .modelContainer(for: Year.self)
        .modelContainer(for: Month.self)
//        .modelContainer(for: RecurringExpense.self)
//        .modelContainer(for: Expense.self)
    }
}

/// App Icon
#Preview {
    Image(systemName: "text.book.closed.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(.white)
            .frame(width: 250, height: 250)
        .padding()
        .padding()
        .padding(44)
        .background(.accent.gradient)
}
