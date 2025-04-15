import SwiftUI

struct EditMonth: View {
    @Bindable var month: Month
    
    var body: some View {
        Form {
            if !month.incomes.isEmpty {
                Section("Recurring Income Sources") {
                    ForEach($month.incomes.filter { $0.wrappedValue.recurringID != nil }, id: \.id) { $income in
                        DynamicCurrencyTextField($income.wrappedValue.name, value: $income.amount)
                    }
                }
            }
            
            Section("Other Income Sources") {
                ForEach($month.incomes.filter { $0.wrappedValue.recurringID == nil }, id: \.id) { $income in
                    DynamicCurrencyTextField(value: $income.amount) {
                        TextField("Name", text: $income.name)
                    }
                }
                
                Button {
                    month.incomes.append(.init(name: "", amount: 0))
                } label: {
                    Label("Add Income Source", systemImage: "plus")
                }
            }
            
            LabeledContent {
                Text(month.totalIncomes.formatted(.currency(code: "USD")))
            } label: {
                Text("Total Income:")
            }
            
            if !month.expenses.isEmpty {
                Section("Recurring Expenses") {
                    ForEach($month.expenses.filter { $0.wrappedValue.recurringID != nil }, id: \.id) { $expense in
                        DynamicCurrencyTextField($expense.wrappedValue.name, value: $expense.cost)
                    }
                }
            }
            
            Section("Other Expenses") {
                ForEach($month.expenses.filter { $0.wrappedValue.recurringID == nil }, id: \.id) { $expense in
                    DynamicCurrencyTextField(value: $expense.cost) {
                        TextField("Name", text: $expense.name)
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
                Text("Total Expenses:")
            }
            
            LabeledContent {
                Text((month.totalIncomes - month.totalExpenses).formatted(.currency(code: "USD")))
            } label: {
                Text("Net Income:")
            }
        }
    }
}

#Preview {
    EditMonth(month: AppModel.sample.years.first!.months.first!)
}
