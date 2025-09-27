//
//  CurrentVersionView.swift
//  SwiftNEW
//
//  Fixed by Kilian on 27/09/2025
//

import SwiftUI
import SwiftVB
import SwiftGlass

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    // MARK: - Fullscreen Current Version Changes View
    public var currentVersionView: some View {
        ZStack {
            // Block taps behind
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {}

            VStack(alignment: align) {
                Spacer()

                headings
                    .padding(.bottom)

                Spacer()

                if loading {
                    VStack {
                        Text(String(localized: "Loading...", bundle: .module))
                            .padding(.bottom)
                        ProgressView()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(items, id: \.self) { item in
                            if item.version == Bundle.version || item.subVersion == Bundle.version {
                                ForEach(item.new, id: \.self) { new in
                                    HStack {
                                        // Leading icon
                                        if align == .leading || align == .center {
                                            ZStack {
                                                color
                                                Image(systemName: new.icon)
                                                    .foregroundColor(.white)
                                            }
                                            .glass(radius: 15, shadowColor: color)
                                            #if !os(tvOS)
                                            .frame(width: 50, height: 50)
                                            #else
                                            .frame(width: 100, height: 100)
                                            #endif
                                            .cornerRadius(15)
                                            .padding(.trailing)
                                        } else { Spacer() }

                                        // Text content
                                        VStack(alignment: align == .trailing ? .trailing : .leading) {
                                            Text(new.title).font(.headline).lineLimit(1)
                                            Text(new.subtitle).font(.subheadline).foregroundColor(.secondary).lineLimit(1)
                                            Text(new.body).font(.caption).foregroundColor(.secondary).lineLimit(2)
                                        }

                                        // Trailing icon
                                        if align == .trailing {
                                            ZStack {
                                                color
                                                Image(systemName: new.icon)
                                                    .foregroundColor(.white)
                                            }
                                            .glass(radius: 15, shadowColor: color)
                                            #if !os(tvOS)
                                            .frame(width: 50, height: 50)
                                            #else
                                            .frame(width: 100, height: 100)
                                            #endif
                                            .cornerRadius(15)
                                            .padding(.trailing)
                                        } else { Spacer() }
                                    }
                                    .padding(.bottom)
                                }
                            }
                        }
                    }
                    #if !os(tvOS)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    #endif
                }

                Spacer()

                if history {
                    showHistoryButton
                        .padding(.bottom)
                }

                closeCurrentButton
                    .padding(.bottom)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadData() }
        .edgesIgnoringSafeArea(.all)
    }
}
