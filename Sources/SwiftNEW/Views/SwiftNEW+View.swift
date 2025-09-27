//
//  SwiftNEW+View.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
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
        VStack {
            // Optional trigger button (if you still want it for navigation)
            Button(action: {
#if os(iOS)
                if showDrop {
                    drop()
                } else {
                    show = true
                }
#else
                show = true
#endif
            }) {
                Label(label, systemImage: labelImage)
                    .frame(
                        width: size == "mini" ? nil : (size == "invisible" ? 0 : platformWidth),
                        height: size == "mini" ? nil : (size == "invisible" ? 0 : 50)
                    )
#if os(iOS) && !os(visionOS)
                .foregroundColor(labelColor)
                .background(size != "mini" && size != "invisible" ? color : Color.clear)
                .cornerRadius(15)
#endif
            }
            .opacity(size == "invisible" ? 0 : 1)
            .modifier(ConditionalGlassModifier(isEnabled: glass, shadowColor: color))
            
            // Main content view (always visible instead of in a sheet)
            if show {
                contentView
            }
        }
    }
    
    private var platformWidth: CGFloat {
#if os(tvOS)
        400
#else
        300
#endif
    }
    
    private var contentView: some View {
        ZStack {
            // Special effects first — will appear behind the content
            Group {
                switch specialEffect {
                case "Christmas": SnowfallView()
                case "Release": BalloonView()
                case "Halloween": HalloweenView()
                default: EmptyView()
                }
            }
            .zIndex(0) // behind main content
            
            // Background Mesh
            if mesh {
                MeshView(color: $color)
                    .zIndex(0)
            }
            
            // Main content (text, current sheet, history)
            VStack {
                currentVersionView
                if historySheet {
                    historyView
                }
            }
            .zIndex(1) // above the special effects
        }
        .background(.ultraThinMaterial)
        .modifier(ViewBackgroundModifier())
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding() // Add padding around the view
        .transition(.scale.combined(with: .opacity)) // Add nice transition
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: show)
    }
    
    private var historyView: some View {
        ZStack {
            // Special effects behind
            Group {
                switch specialEffect {
                case "Christmas": SnowfallView()
                case "Release": BalloonView()
                case "Halloween": HalloweenView()
                default: EmptyView()
                }
            }
            .zIndex(0)
            
            // Background Mesh
            if mesh {
                MeshView(color: $color)
                    .zIndex(0)
            }
            
            // History content above effects
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
    
    // MARK: - Background Modifier for regular views
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
    
    // MARK: - Glass Modifier
    private struct ConditionalGlassModifier: ViewModifier {
        let isEnabled: Bool
        let shadowColor: Color
        
        func body(content: Content) -> some View {
            if isEnabled {
                content.glass(shadowColor: shadowColor)
            } else {
                content
            }
        }
    }
}
