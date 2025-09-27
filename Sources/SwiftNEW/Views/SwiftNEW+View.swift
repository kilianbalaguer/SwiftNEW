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

    @AppStorage("lastSeenWhatsNewVersion") private var lastSeenVersion: String = ""
    
    public var body: some View {
        ZStack {
            if show {
                // Block taps behind
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { /* Do nothing */ }

                // Special effects
                Group {
                    switch specialEffect {
                    case "Christmas": SnowfallView()
                    case "Release": BalloonView()
                    case "Halloween": HalloweenView()
                    default: EmptyView()
                    }
                }
                .zIndex(0)

                // Background mesh
                if mesh {
                    MeshView(color: $color)
                        .zIndex(0)
                }

                // Main content
                VStack(spacing: 0) {
                    currentVersionView
                    if historySheet {
                        HistorySheet(items: items, color: color)
                    }
                    continueButton
                        .padding(.top)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 10)
                .zIndex(1)
                .transition(.opacity)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: show)
            }
        }
        .onAppear {
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
