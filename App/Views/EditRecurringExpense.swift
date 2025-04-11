import SwiftUI

struct EditRecurringExpense: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Bindable var expense: RecurringExpense
    let expenses: [(year: Int, months: [(month: String, cost: Double)])]
    
    var body: some View {
        Form {
            TextField("Name", text: $expense.name)
            
            DynamicCurrencyTextField(value: $expense.cost) {
                switch expense.type {
                case .fixed:
                    Text("Cost:")
                case .variable:
                    Text("Estimate:")
                }
            }
            
            Section("Type") {
                Button {
                    expense.type = .fixed
                } label: {
                    HStack {
                        Text("Fixed")
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                        
                        if case .fixed = expense.type {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button {
                    expense.type = .variable
                } label: {
                    HStack {
                        Text("Variable")
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                        
                        if case .variable = expense.type {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            
            if !expenses.isEmpty {
                LabeledContent {
                    Text(averageCost.formatted(.currency(code: "USD")))
                } label: {
                    Text("Average:")
                }
                
                ForEach(expenses, id: \.year) { year in
                    Section(String(year.year)) {
                        ForEach(year.months, id: \.month) { month in
                            LabeledContent {
                                Text(month.cost.formatted(.currency(code: "USD")))
                            } label: {
                                Text(month.month)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var averageCost: Double {
        let allCosts = expenses.flatMap(\.months).map(\.cost)
        return allCosts.reduce(0, +) / Double(allCosts.count)
    }
}

#Preview {
    let model = AppModel.sample
    let recurringExpense = model.monthlyExpenses.first { $0.type == .variable }!
    let expenses = model.getExpensesFor(recurringExpense: recurringExpense)
    
    return EditRecurringExpense(expense: recurringExpense, expenses: expenses)
}
