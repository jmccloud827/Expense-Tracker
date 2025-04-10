import SwiftUI

struct EditMonth: View {
    @Bindable var month: Month
    
    var body: some View {
        Form {
            Section("Income") {
                DynamicCurrencyTextField("Income", value: $month.income)
            }
            
            Section("Recurring Expenses") {
                ForEach($month.expenses.filter { $0.wrappedValue.recurringExpense != nil }, id: \.id) { $expenseModel in
                    DynamicCurrencyTextField($expenseModel.wrappedValue.name, value: $expenseModel.expense.cost)
                        .onChange(of: $expenseModel.wrappedValue.expense.cost) {
                            $expenseModel.wrappedValue.onCostChanged()
                        }
                }
            }
            
            Section("Other Expenses") {
                ForEach($month.expenses.filter { $0.wrappedValue.recurringExpense == nil }, id: \.id) { $expenseModel in
                    DynamicCurrencyTextField(value: $expenseModel.expense.cost) {
                        TextField("Name", text: $expenseModel.expense.name)
                    }
                    .onChange(of: $expenseModel.wrappedValue.expense.cost) {
                        $expenseModel.wrappedValue.onCostChanged()
                    }
                }
                
                Button {
                    month.expenses.append(.init(name: "", cost: 0))
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
            }
            
            LabeledContent {
                Text(month.totalExpenses.formatted(.currency(code: "USD")))
            } label: {
                Text("Total Expenses")
            }
            
            LabeledContent {
                Text((month.income - month.totalExpenses).formatted(.currency(code: "USD")))
            } label: {
                Text("Saved")
            }
        }
    }
}

#Preview {
    EditMonth(month: AppModel.sample.years.first!.months.first!)
}
