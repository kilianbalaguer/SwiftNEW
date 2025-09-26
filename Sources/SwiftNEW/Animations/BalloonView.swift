//
//  BalloonView.swift
//  SwiftNEW
//
//  Created by Kilian Balaguer on 26/09/2025.
//


import SwiftUI

struct BalloonView: View {
    @State private var balloons = [Balloon]()
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(balloons) { balloon in
                    VStack(spacing: 0) {
                        Circle()
                            .fill(balloon.color)
                            .frame(width: balloon.size, height: balloon.size * 1.2)
                        Rectangle()
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 2, height: balloon.size)
                    }
                    .position(x: balloon.x, y: balloon.y)
                    .rotationEffect(.degrees(balloon.rotation))
                }
            }
            .onAppear {
                for _ in 0..<50 {
                    balloons.append(Balloon(
                        id: UUID(),
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: geometry.size.height...geometry.size.height + 200),
                        size: CGFloat.random(in: 20...40),
                        speed: CGFloat.random(in: 1...3),
                        rotation: Double.random(in: -15...15),
                        color: Color(
                            red: Double.random(in: 0.5...1),
                            green: Double.random(in: 0.5...1),
                            blue: Double.random(in: 0.5...1)
                        )
                    ))
                }
            }
            .onReceive(timer) { _ in
                for index in balloons.indices {
                    balloons[index].y -= balloons[index].speed
                    if balloons[index].y < -50 {
                        balloons[index].y = geometry.size.height + 50
                        balloons[index].x = CGFloat.random(in: 0...geometry.size.width)
                    }
                }
            }
        }
    }
}

struct Balloon: Identifiable {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var speed: CGFloat
    var rotation: Double
    var color: Color
}
