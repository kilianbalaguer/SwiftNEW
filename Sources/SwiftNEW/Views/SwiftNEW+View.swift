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
        .sheet(isPresented: $show) {
            sheetContent
        }
    }
    
    private var platformWidth: CGFloat {
#if os(tvOS)
        400
#else
        300
#endif
    }
    
    private var sheetContent: some View {
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
                sheetCurrent
                if historySheet {
                    historySheetContent
                }
            }
            .zIndex(1) // above the special effects
        }
        .background(.ultraThinMaterial)
        .modifier(PresentationBackgroundModifier())
    }
    
    private var historySheetContent: some View {
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
        .modifier(PresentationBackgroundModifier())
    }
    
    
    // MARK: - Background Modifier
    private struct PresentationBackgroundModifier: ViewModifier {
        func body(content: Content) -> some View {
            if #available(iOS 16.4, tvOS 16.4, *) {
                content.presentationBackground(.thinMaterial)
            } else {
                content
            }
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
