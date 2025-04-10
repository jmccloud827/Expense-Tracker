import SwiftUI

struct Onboarding: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var model = AppModel()
    
    var body: some View {
        EditIncomeAndMonthlyExpenses(model: .init())
            .navigationTitle("Onboarding")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        modelContext.insert(model)
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                }
            }
    }
}

#Preview {
    Onboarding()
        .modelContainer(App.previewContainer)
}
