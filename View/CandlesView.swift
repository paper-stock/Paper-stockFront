import SwiftUI
import Charts

struct CandlesView: View {
    @StateObject private var viewModel: CandleViewModel
    
    @State private var rawSelectedDate: Date?
    private var selectedCandle: CandleModel? {
        guard let touchedData = rawSelectedDate else {return nil}
        return viewModel.candles.min {
            abs($0.t.timeIntervalSince(touchedData)) <
            abs($1.t.timeIntervalSince(touchedData))
        }
    }

    // Wartości startowe są tylko zaślepką, po załadowaniu danych zostaną nadpisane
    @State private var visibleLength: Double = 24 * 3600
    @State private var baseLength: Double = 24 * 3600
    @State private var scrollPosition: Date = .now

    // Ile świec maksymalnie widać przy największym przybliżeniu
    private let minCandlesVisible: Double = 5

    // Maksymalne przybliżenie: kilka długości jednej świecy
    private var minLength: Double {
        viewModel.selectedTimeframe.seconds * minCandlesVisible
    }

    // Maksymalne oddalenie: cały zakres pobranych danych
    private var dynamicMaxLength: Double {
        max(minLength, dataSpan)
    }

    // Czas od pierwszej do ostatniej świecy (plus jedna świeca, żeby ostatnia się mieściła)
    private var dataSpan: Double {
        guard let first = viewModel.candles.first?.t,
              let last = viewModel.candles.last?.t else { return 0 }
        return last.timeIntervalSince(first) + viewModel.selectedTimeframe.seconds
    }

    init(symbol: String) {
        _viewModel = StateObject(wrappedValue: CandleViewModel(symbol: symbol))
    }

    var body: some View {
        VStack(spacing: 16) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
//            if let selected = selectedCandle?.c{
//                Text(selected, format: .currency(code: "USD"))
//                .font(.title2)}
                
            
            
            Chart{
                ForEach(viewModel.candles, id: \.t) { candle in
                    let color: Color = candle.c >= candle.o ? .green : .red
                    let half = candle.timeframe.seconds * 0.35
                    
                    RuleMark(
                        x: .value("Czas", candle.t),
                        yStart: .value("Low", candle.l),
                        yEnd: .value("High", candle.h)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .foregroundStyle(color)
                    
                    RectangleMark(
                        xStart: .value("Start", candle.t.addingTimeInterval(-half)),
                        xEnd: .value("Koniec", candle.t.addingTimeInterval(half)),
                        yStart: .value("Open", candle.o),
                        yEnd: .value("Close", candle.c)
                    )
                    .foregroundStyle(color)
                }
                if let selected = selectedCandle{
                    RuleMark(
                        x: .value("Start", selected.t),
                        
                        )
                    .foregroundStyle(Color.gray.opacity(0.3))
                    .annotation(
                        position: .top, spacing: 0,
                        overflowResolution: .init(
                            x: .fit(to:  .chart),
                            y: .fit(to: .chart)
                        )
                    ){
                        VStack{
                            Text(selected.t, format: .dateTime)
                                .foregroundStyle(.secondary)
                            
                            HStack{
                                Text("Open: \(selected.o, format: .currency(code: "USD"))")
                                Text("High: \(selected.h, format: .currency(code: "USD"))")
                            }
                            HStack{
                                Text("Close: \(selected.c, format: .currency(code: "USD"))")
                                Text("Low: \(selected.l, format: .currency(code: "USD"))")
                            }
                        }.padding()
                            .font(.caption)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(25)
                    }
                }
            }// Chart
            .chartYScale(domain: .automatic(includesZero: false))
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: visibleLength)
            .chartScrollPosition(x: $scrollPosition)
            .chartXSelection(value: $rawSelectedDate)
            .simultaneousGesture(
                MagnifyGesture()
                    .onChanged { value in
                        let newLength = min(
                            max(baseLength / value.magnification, minLength),
                            dynamicMaxLength
                        )
                        // zachowaj prawą krawędź okna (najnowsze dane)
                        let right = scrollPosition.addingTimeInterval(visibleLength)
                        visibleLength = newLength
                        scrollPosition = right.addingTimeInterval(-newLength)
                    }
                    .onEnded { _ in
                        baseLength = visibleLength
                    }
            )
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }

            Picker("Interwał", selection: $viewModel.selectedTimeframe) {
                ForEach(Timeframe.allCases, id: \.self) { timeframe in
                    Text(timeframe.label).tag(timeframe)
                }
            }
            .pickerStyle(.menu)
        }
        .padding()
        .task(id: viewModel.selectedTimeframe) {
            await viewModel.loadCandles()
            resetView()
        }
    }

    
    private func resetView() {
        guard let first = viewModel.candles.first?.t else { return }
        let length = max(dataSpan, minLength)
        visibleLength = length
        baseLength = length
        scrollPosition = first
    }
}

#Preview {
    CandlesView(symbol: "TSLA")
}
