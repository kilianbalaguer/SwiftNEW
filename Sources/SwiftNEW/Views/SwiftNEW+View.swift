//
//  SwiftNEW+View.swift
//  SwiftNEW
//
//  Updated by Kilian on 27/09/2025
//

import SwiftUI
import SwiftVB
import SwiftGlass

#if os(iOS)
import Drops
#endif

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    public var body: some View {
        ZStack {
            if show {
                // Block interactions behind the view
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {} // disables taps behind

                // Main full-screen content
                VStack(spacing: 0) {
                    // Special effects and background mesh
                    ZStack {
                        Group {
                            switch specialEffect {
                            case "Christmas": SnowfallView()
                            case "Release": BalloonView()
                            case "Halloween": HalloweenView()
                            default: EmptyView()
                            }
                        }
                        .ignoresSafeArea()
                        .zIndex(0)

                        if mesh {
                            MeshView(color: $color)
                                .ignoresSafeArea()
                                .zIndex(0)
                        }
                    }

                    // Main content
                    VStack(spacing: 16) {
                        currentVersionView
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        if historySheet { historyView }

                        continueButton
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .zIndex(1)
                }
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: show)
            }
        }
        .onAppear {
            // Auto-show only once per version
            if lastSeenVersion != Bundle.version {
                show = true
                lastSeenVersion = Bundle.version
            }
        }
    }

    private var continueButton: some View {
        Button(action: { show = false }) {
            Text("Continue")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(15)
                .padding([.horizontal, .bottom])
        }
    }

    private struct ViewBackgroundModifier: ViewModifier {
        func body(content: Content) -> some View {
            content.background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
        }
    }

    private struct ConditionalGlassModifier: ViewModifier {
        let isEnabled: Bool
        let shadowColor: Color
        func body(content: Content) -> some View {
            if isEnabled { content.glass(shadowColor: shadowColor) }
            else { content }
        }
    }
}
