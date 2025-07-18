import SwiftUI

struct EditIncomeAndMonthlyExpenses: View {
    @Bindable var model: AppModel
    var onAddNewIncome: (RecurringIncome) -> Void = { _ in }
    var onAddNewExpense: (RecurringExpense) -> Void = { _ in }
    
    @State private var newExpense: RecurringExpense?
    @State private var newIncome: RecurringIncome?
    
    var body: some View {
        Form {
            Section("Monthly Income") {
                ForEach(model.monthlyIncomes, id: \.id) { income in
                    NavigationLink {
                        EditRecurringIncome(income: income, incomes: model.getIncomes(for: income))
                            .navigationTitle("Edit Expense")
                            .navigationBarTitleDisplayMode(.inline)
                            .onChange(of: income.name) {
                                model.years.forEach { year in
                                    year.months.forEach { month in
                                        month.incomes.forEach { income2 in
                                            if income2.recurringID == income.id {
                                                income2.name = income.name
                                            }
                                        }
                                    }
                                }
                            }
                    } label: {
                        LabeledContent {
                            Text(income.amount.formatted(.currency(code: "USD")))
                        } label: {
                            Text(income.name)
                        }
                    }
                }
                    
                Button {
                    newIncome = .init(name: "", amount: 0, type: .fixed)
                } label: {
                    Label("Add Income", systemImage: "plus")
                }
            }
            
            LabeledContent {
                Text(model.totalMonthlyIncome.formatted(.currency(code: "USD")))
            } label: {
                Text("Total Monthly Income:")
            }
                
            Section("Monthly Expenses") {
                ForEach(model.monthlyExpenses, id: \.id) { expense in
                    NavigationLink {
                        EditRecurringExpense(expense: expense, expenses: model.getExpenses(for: expense))
                            .navigationTitle("Edit Expense")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        LabeledContent {
                            Text(expense.cost.formatted(.currency(code: "USD")))
                        } label: {
                            Text(expense.name)
                        }
                    }
                    .onChange(of: expense.name) {
                        model.years.forEach { year in
                            year.months.forEach { month in
                                month.expenses.forEach { expense2 in
                                    if expense2.recurringID == expense.id {
                                        expense2.name = expense.name
                                    }
                                }
                            }
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
                Text("Total Monthly Expenses:")
            }
        }
        .fullScreenCover(item: $newIncome) { income in
            NavigationStack {
                EditRecurringIncome(income: income, incomes: [])
                    .navigationTitle("New Income Source")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Button("Cancel", systemImage: "xmark") {
                                newIncome = nil
                            }
                        }
                        
                        ToolbarItem(placement: .automatic) {
                            Button("Done", systemImage: "checkmark", role: .confirm) {
                                model.monthlyIncomes.append(income)
                                newIncome = nil
                                onAddNewIncome(income)
                            }
                        }
                    }
            }
        }
        .fullScreenCover(item: $newExpense) { expense in
            NavigationStack {
                EditRecurringExpense(expense: expense, expenses: [])
                    .navigationTitle("New Expense")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Button("Cancel", systemImage: "xmark") {
                                newExpense = nil
                            }
                        }
                        
                        ToolbarItem(placement: .automatic) {
                            Button("Done", systemImage: "checkmark", role: .confirm) {
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
