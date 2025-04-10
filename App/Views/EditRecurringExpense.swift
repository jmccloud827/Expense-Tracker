import SwiftUI

struct EditRecurringExpense: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Bindable var expense: RecurringExpense
    
    var body: some View {
        Form {
            TextField("Name", text: $expense.name)
            
            DynamicCurrencyTextField(value: $expense.cost) {
                switch expense.type {
                case .fixed:
                    Text("Cost:")
                case .variable:
                    Text("Estimate:")
                }
            }
            
            Section("Type") {
                Button {
                    expense.type = .fixed
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
                    expense.type = .variable
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
    EditRecurringExpense(expense: .init(name: "", cost: 0, type: .fixed))
}
