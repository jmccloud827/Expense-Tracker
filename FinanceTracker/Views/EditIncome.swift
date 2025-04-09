import SwiftUI

struct EditIncomeAndMonthlyExpenses: View {
    @Bindable var model: IncomeAndMonthlyExpenses
    
    @State private var newExpense: RecurringExpense?
    
    var body: some View {
        Form {
            Section("Income") {
                Picker("Income Type", selection: $model.incomeType) {
                    ForEach(IncomeType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                    
                HStack {
                    Text("Amount Post Tax")
                        
                    TextField("", value: $model.income, format: .currency(code: "USD"))
                        .multilineTextAlignment(.trailing)
                }
            }
            
            LabeledContent {
                Text(model.monthlyIncome.formatted(.currency(code: "USD")))
            } label: {
                Text("Monthly Income")
            }
                
            Section("Monthly Expenses") {
                ForEach(model.expenses, id: \.id) { expense in
                    NavigationLink {
                        EditRecurringExpense(expense: expense)
                            .navigationTitle("Edit Expense")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        LabeledContent {
                            switch expense.type {
                            case let .fixed(cost):
                                Text(cost.formatted(.currency(code: "USD")))
                            case let .variable(estimate):
                                Text(estimate.formatted(.currency(code: "USD")))
                            }
                        } label: {
                            Text(expense.name)
                        }
                    }
                }
                    
                Button {
                    newExpense = .init(name: "", type: .fixed(cost: 0))
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
            }
            
            LabeledContent {
                Text(model.totalExpenses.formatted(.currency(code: "USD")))
            } label: {
                Text("Total monthly expenses")
            }
        }
        .fullScreenCover(item: $newExpense) { expense in
            NavigationStack {
                EditRecurringExpense(expense: expense)
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
                                model.expenses.append(expense)
                                newExpense = nil
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
