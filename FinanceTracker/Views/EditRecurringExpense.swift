import SwiftData
import SwiftUI

struct EditRecurringExpense: View {
    @Bindable var expense: RecurringExpense
    
    @State private var fixedCost = 0
    
    init(expense: RecurringExpense) {
        self.expense = expense
        if case let .fixed(cost) = expense.type {
            _fixedCost = .init(initialValue: cost)
        } else {
            _fixedCost = .init(initialValue: 0)
        }
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $expense.name)
            
            if case .fixed = expense.type {
                HStack {
                    Text("Cost:")
                    
                    TextField("", value: $fixedCost, format: .number)
                        .multilineTextAlignment(.trailing)
                }
                .onChange(of: fixedCost) {
                    expense.type = .fixed(cost: fixedCost)
                }
            }
            
            Section("Type") {
                Button {
                    withAnimation {
                        expense.type = .fixed(cost: 0)
                    }
                } label: {
                    HStack {
                        if case .fixed = expense.type {
                            Image(systemName: "checkmark")
                        }
                        
                        Text("Fixed")
                    }
                }
                
                Button {
                    withAnimation {
                        expense.type = .variable
                    }
                } label: {
                    HStack {
                        if case .variable = expense.type {
                            Image(systemName: "checkmark")
                        }
                        
                        Text("Variable")
                    }
                }
            }
        }
    }
}

#Preview {
    EditRecurringExpense(expense: .init(name: "", type: .fixed(cost: 0)))
}
