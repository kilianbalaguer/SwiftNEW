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
        ZStack {
            // MARK: - Button
            Button(action: {
                #if os(iOS)
                if showDrop {
                    drop()
                } else {
                    show.toggle()
                }
                #else
                show.toggle()
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

            // MARK: - Inline Content
            if show {
                ZStack {
                    if mesh {
                        MeshView(color: $color)
                    }

                    if specialEffect == "Christmas" {
                        SnowfallView()
                    }

                    VStack {
                        sheetCurrent
                            .frame(maxWidth: platformWidth)
                            .background(.ultraThinMaterial)
                            .modifier(PresentationBackgroundModifier())
                            .cornerRadius(20)
                            .padding()
                        
                        if history {
                            sheetHistory
                                .frame(maxWidth: platformWidth)
                                .background(.ultraThinMaterial)
                                .modifier(PresentationBackgroundModifier())
                                .cornerRadius(20)
                                .padding(.horizontal)
                        }
                    }
                }
                .transition(.opacity.combined(with: .scale))
                .zIndex(1)
            }
        }
    }

    // MARK: - Platform Width
    private var platformWidth: CGFloat {
        #if os(tvOS)
        400
        #else
        300
        #endif
    }

    // MARK: - Presentation Background Modifier
    private struct PresentationBackgroundModifier: ViewModifier {
        func body(content: Content) -> some View {
            if #available(iOS 16.4, tvOS 16.4, *) {
                content.presentationBackground(.thinMaterial)
            } else {
                content
            }
        }
    }

    // MARK: - Conditional Glass Modifier
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
