import SwiftUI

struct EditMonth: View {
    @Bindable var month: Month
    
    var body: some View {
        Form {
            Section("Recurring Income Sources") {
                ForEach($month.incomes.filter { $0.wrappedValue.recurringIncome != nil }, id: \.id) { $incomeModel in
                    DynamicCurrencyTextField($incomeModel.wrappedValue.name, value: $incomeModel.income.amount)
                }
            }
            
            Section("Other Income Sources") {
                ForEach($month.incomes.filter { $0.wrappedValue.recurringIncome == nil }, id: \.id) { $incomeModel in
                    DynamicCurrencyTextField(value: $incomeModel.income.amount) {
                        TextField("Name", text: $incomeModel.income.name)
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
            
            Section("Recurring Expenses") {
                ForEach($month.expenses.filter { $0.wrappedValue.recurringExpense != nil }, id: \.id) { $expenseModel in
                    DynamicCurrencyTextField($expenseModel.wrappedValue.name, value: $expenseModel.expense.cost)
                }
            }
            
            Section("Other Expenses") {
                ForEach($month.expenses.filter { $0.wrappedValue.recurringExpense == nil }, id: \.id) { $expenseModel in
                    DynamicCurrencyTextField(value: $expenseModel.expense.cost) {
                        TextField("Name", text: $expenseModel.expense.name)
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
