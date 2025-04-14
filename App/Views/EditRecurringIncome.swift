import SwiftUI

struct EditRecurringIncome: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Bindable var income: RecurringIncome
    let incomes: [(year: Int, months: [(month: String, amount: Double)])]
    
    var body: some View {
        Form {
            TextField("Name", text: $income.name)
            
            DynamicCurrencyTextField(value: $income.amount) {
                switch income.type {
                case .fixed:
                    Text("Cost:")
                case .variable:
                    Text("Estimate:")
                }
            }
            
            Section("Type") {
                Button {
                    income.type = .fixed
                } label: {
                    HStack {
                        Text("Fixed")
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                        
                        if case .fixed = income.type {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button {
                    income.type = .variable
                } label: {
                    HStack {
                        Text("Variable")
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                        
                        if case .variable = income.type {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            
            if !incomes.isEmpty {
                LabeledContent {
                    Text(averageCost.formatted(.currency(code: "USD")))
                } label: {
                    Text("Average:")
                }
                
                ForEach(incomes, id: \.year) { year in
                    Section(String(year.year)) {
                        ForEach(year.months, id: \.month) { month in
                            LabeledContent {
                                Text(month.amount.formatted(.currency(code: "USD")))
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
        let allCosts = incomes.flatMap(\.months).map(\.amount)
        return allCosts.reduce(0, +) / Double(allCosts.count)
    }
}

#Preview {
    let model = AppModel.sample
    let recurringIncome = model.monthlyIncomes.first { $0.type == .variable }!
    let incomes = model.getIncomes(for: recurringIncome)
    
    return EditRecurringIncome(income: recurringIncome, incomes: incomes)
}
