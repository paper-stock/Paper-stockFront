
import SwiftUI
struct Top10View: View {
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Most Active")
                            .font(.title2)
                            .bold()
                        MostActiveView()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Top Movers")
                            .font(.title2)
                            .bold()
                        TopMoversView()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    Top10View()
}
