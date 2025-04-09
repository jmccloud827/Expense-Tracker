import SwiftData
import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            Onboarding()
        }
        .modelContainer(for: [
            Year.self,
            Month.self,
            Month.ExpenseModel.self,
            IncomeAndMonthlyExpenses.self,
            RecurringExpense.self,
            Expense.self
        ])
    }
    
    static var previewContainer: ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        return try! ModelContainer(for: Year.self,
                                   Month.self,
                                   Month.ExpenseModel.self,
                                   IncomeAndMonthlyExpenses.self,
                                   RecurringExpense.self,
                                   Expense.self,
                                   configurations: config)
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
