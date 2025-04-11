import SwiftUI

struct EditIncomeAndMonthlyExpenses: View {
    @Bindable var model: AppModel
    var onAddNewExpense: (RecurringExpense) -> Void = { _ in }
    
    @State private var newExpense: RecurringExpense?
    
    var body: some View {
        Form {
            Section("Income") {
                Picker("Income Type", selection: $model.incomeType) {
                    ForEach(IncomeType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                    
                DynamicCurrencyTextField("Amount Post Tax", value: $model.income)
            }
            
            LabeledContent {
                Text(model.monthlyIncome.formatted(.currency(code: "USD")))
            } label: {
                Text("Monthly Income")
            }
                
            Section("Monthly Expenses") {
                ForEach(model.monthlyExpenses, id: \.id) { expense in
                    NavigationLink {
                        EditRecurringExpense(expense: expense, expenses: model.getExpensesFor(recurringExpense: expense))
                            .navigationTitle("Edit Expense")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        LabeledContent {
                            Text(expense.cost.formatted(.currency(code: "USD")))
                        } label: {
                            Text(expense.name)
                        }
                    }
                }
                    
                Button {
                    newExpense = .init(name: "", cost: 0, type: .fixed)
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
            }
            
            LabeledContent {
                Text(model.totalMonthlyExpenses.formatted(.currency(code: "USD")))
            } label: {
                Text("Total monthly expenses")
            }
        }
        .fullScreenCover(item: $newExpense) { expense in
            NavigationStack {
                EditRecurringExpense(expense: expense, expenses: [])
                    .navigationTitle("New Expense")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Button("Cancel") {
                                newExpense = nil
                            }
                        }
                        
                        ToolbarItem(placement: .automatic) {
                            Button("Done") {
                                model.monthlyExpenses.append(expense)
                                newExpense = nil
                                onAddNewExpense(expense)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditIncomeAndMonthlyExpenses(model: .sample)
    }
}
