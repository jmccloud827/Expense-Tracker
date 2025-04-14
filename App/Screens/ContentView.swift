import SwiftData
import SwiftUI

struct ContentView: View {
    @Query(sort: \AppModel.dateCreated, order: .reverse) private var models: [AppModel]
    
    var body: some View {
        NavigationStack {
            if let model = models.first {
                YearAndMonthList()
                    .environment(model)
            } else {
                Onboarding()
                    .environment(AppModel())
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(App.previewContainer)
}
