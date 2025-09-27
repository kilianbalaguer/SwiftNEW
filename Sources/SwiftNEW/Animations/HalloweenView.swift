import SwiftUI

struct HalloweenView: View {
    @State private var pumpkins = [Pumpkin]()
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(pumpkins) { pumpkin in
                    Image("Ghost", bundle: .module)
                        .resizable()
                        .frame(width: pumpkin.size, height: pumpkin.size)
                        .offset(x: pumpkin.x - geometry.size.width/2,
                                y: pumpkin.y - geometry.size.height/2)
                        .rotationEffect(.degrees(pumpkin.rotation))
                }
            }
            .onAppear {
                for _ in 0..<30 {
                    pumpkins.append(Pumpkin(
                        id: UUID(),
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 0...geometry.size.height),
                        size: CGFloat.random(in: 20...50),
                        speed: CGFloat.random(in: 1...2),
                        rotation: Double.random(in: 0...360)
                    ))
                }
            }
            .onReceive(timer) { _ in
                for index in pumpkins.indices {
                    pumpkins[index].y += pumpkins[index].speed
                    pumpkins[index].rotation += Double.random(in: -2...2)
                    if pumpkins[index].y > geometry.size.height {
                        pumpkins[index].y = -50
                        pumpkins[index].x = CGFloat.random(in: 0...geometry.size.width)
                    }
                }
            }
        }
        .drawingGroup() // optional for better performance
    }
}

struct Pumpkin: Identifiable {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var speed: CGFloat
    var rotation: Double
}
