
import SwiftUI

struct ProgressRing: View {
    let progress: CGFloat // 0...1
    let size: CGFloat
    let lineWidth: CGFloat
    
    init(progress: CGFloat, size: CGFloat = 140, lineWidth: CGFloat = 12) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray4), lineWidth: lineWidth)
                .frame(width: size, height: size)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
            Text("\(Int(min(max(progress, 0), 1) * 100))%")
                .font(.headline)
        }
    }
}

#Preview {
    ProgressRing(progress: 0.43)
}


