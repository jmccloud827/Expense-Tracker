import SwiftUI

struct EditRecurringExpense: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Bindable var expense: RecurringExpense
    
    @State private var fixedCost = 0.0
    
    init(expense: RecurringExpense) {
        self.expense = expense
        switch expense.type {
        case let .fixed(cost):
            _fixedCost = .init(initialValue: cost)
        case let .variable(estimate):
            _fixedCost = .init(initialValue: estimate)
        }
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $expense.name)
            
            HStack {
                switch expense.type {
                case .fixed:
                    Text("Cost:")
                case .variable:
                    Text("Estimate:")
                }
                    
                TextField("", value: $fixedCost, format: .currency(code: "USD"))
                    .multilineTextAlignment(.trailing)
            }
            .onChange(of: fixedCost) {
                expense.type = .fixed(cost: fixedCost)
            }
            
            Section("Type") {
                Button {
                    expense.type = .fixed(cost: 0)
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
                    expense.type = .variable(estimate: 0)
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
        }
    }
}

#Preview {
    EditRecurringExpense(expense: .init(name: "", type: .fixed(cost: 0)))
}
