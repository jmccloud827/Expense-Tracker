import SwiftUI

struct Onboarding: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppModel.self) private var model
    
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
        #if DEBUG
            .toolbar {
                Button("Sample") {
                    modelContext.insert(AppModel.sample)
                }
            }
        #endif
    }
}

#Preview {
    Onboarding()
        .modelContainer(App.previewContainer)
        .environment(AppModel.sample)
}
