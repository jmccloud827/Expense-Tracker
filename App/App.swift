import SwiftData
import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            AppModel.self,
            Year.self,
            Month.self,
            Month.IncomeModel.self,
            Month.ExpenseModel.self,
            RecurringIncome.self,
            RecurringExpense.self,
            Income.self,
            Expense.self
        ])
    }
    
    static var previewContainer: ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        return try! ModelContainer(for: AppModel.self,
                                   Year.self,
                                   Month.self,
                                   Month.IncomeModel.self,
                                   Month.ExpenseModel.self,
                                   RecurringIncome.self,
                                   RecurringExpense.self,
                                   Income.self,
                                   Expense.self,
                                   configurations: config)
    }
}

/// App Icon
#Preview {
    Image(systemName: "dollarsign.square.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(.white)
        .frame(width: 250, height: 250)
        .padding()
        .padding()
        .padding(44)
        .background(.accent.gradient)
}
