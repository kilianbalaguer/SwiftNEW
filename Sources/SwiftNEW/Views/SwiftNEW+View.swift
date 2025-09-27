//
//  SwiftNEW+View.swift
//  SwiftNEW
//
//  Modified by Kilian on 27/09/2025
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
            // Block taps behind the view
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {}

            // Fullscreen content
            contentView
                .edgesIgnoringSafeArea(.all)
        }
    }

    private var contentView: some View {
        ZStack {
            // Special effects behind content
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
            VStack {
                currentVersionView
                if historySheet {
                    historyView
                }
            }
            .background(.ultraThinMaterial)
            .modifier(ViewBackgroundModifier())
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
            .zIndex(1)
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: show)
        }
    }

    private var historyView: some View {
        ZStack {
            // Effects behind history
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

            // History content
            sheetHistory
                .zIndex(1)
#if os(visionOS)
                .padding()
#endif
        }
        .background(.ultraThinMaterial)
        .modifier(ViewBackgroundModifier())
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }

    // MARK: - Background Modifier
    private struct ViewBackgroundModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
        }
    }
}
