import SwiftUI

struct YearAndMonthList: View {
    @Environment(AppModel.self) private var model
    
    @State private var showSettings = false
    @State private var newExpense: RecurringExpense? = nil
    @State private var showAddExpenseAlert = false
    
    var body: some View {
        List {
            ForEach(model.years, id: \.id) { year in
                Section(String(year.id)) {
                    ForEach(year.sortedMonths, id: \.id) { month in
                        NavigationLink {
                            EditMonth(month: month)
                                .navigationTitle(month.name)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            Text(month.name)
                        }
                    }
                }
            }
        }
        .navigationTitle("Months")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    showSettings = true
                } label: {
                    Label("Settings", systemImage: "gearshape.fill")
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                EditIncomeAndMonthlyExpenses(model: model) { expense in
                    newExpense = expense
                    showAddExpenseAlert = true
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .alert("Would you like to add this new expense to the current month?", isPresented: $showAddExpenseAlert) {
                    Button("No", role: .cancel) {}
                    
                    Button("Yes") {
                        if let currentMonth = model.currentMonth,
                           let newExpense {
                            currentMonth.expenses.append(.init(recurringExpense: newExpense))
                        }
                    }
                }
            }
        }
        .onAppear {
            model.addYearOrMonthIfDoesNotExists()
        }
    }
}

#Preview {
    NavigationStack {
        YearAndMonthList()
    }
    .modelContainer(App.previewContainer)
    .environment(AppModel.sample)
}
