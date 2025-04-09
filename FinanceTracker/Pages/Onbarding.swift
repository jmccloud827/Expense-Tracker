import SwiftUI
import SwiftData

struct Onboarding: View {
    @Query(sort: \IncomeAndMonthlyExpenses.dateCreated, order: .reverse) private var models: [IncomeAndMonthlyExpenses]
    
    var body: some View {
        NavigationStack {
            if let model = models.first {
                YearAndMonthList()
                    .environment(model)
            } else {
                OnboardingView()
            }
        }
    }
}

private struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var model = IncomeAndMonthlyExpenses()
    
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
