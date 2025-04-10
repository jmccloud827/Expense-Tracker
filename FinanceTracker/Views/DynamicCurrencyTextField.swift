import SwiftUI

struct DynamicCurrencyTextField<Label: View>: View {
    let label: () -> Label
    @Binding var value: Double
    
    @State private var width = 100.0
    
    init(_ title: String, value: Binding<Double>) where Label == Text {
        self.label = { Text(title) }
        _value = value
    }
    
    init(value: Binding<Double>, @ViewBuilder label: @escaping () -> Label) {
        _value = value
        self.label = label
    }
    
    var body: some View {
        HStack {
            label()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("", value: $value, format: .currency(code: "USD"))
                .multilineTextAlignment(.trailing)
                .frame(width: width)
                .background {
                    Text(value.formatted(.currency(code: "USD")))
                        .fixedSize()
                        .background {
                            GeometryReader { geometry in
                                Rectangle().fill(Color.clear)
                                    .onAppear {
                                        width = geometry.size.width
                                    }
                                    .onChange(of: value) {
                                        width = geometry.size.width
                                    }
                            }
                        }
                        .layoutPriority(1)
                        .opacity(0)
                }
        }
    }
}

#Preview {
    @Previewable @State var value = 1_000.0
    
    List {
        DynamicCurrencyTextField("Income", value: $value)
    }
}
