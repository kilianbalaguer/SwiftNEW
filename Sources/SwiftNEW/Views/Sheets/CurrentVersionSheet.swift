//
//  CurrentVersionView.swift
//  SwiftNEW
//
//  Updated by Kilian on 27/09/2025
//

import SwiftUI
import SwiftVB
import SwiftGlass

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    public var currentVersionView: some View {
        VStack(alignment: align, spacing: 16) {
            Spacer()

            headings
                .padding(.bottom)

            Spacer()

            if loading {
                VStack {
                    Text("Loading...")
                        .padding(.bottom)
                    ProgressView()
                }
            } else {
                ScrollView(showsIndicators: false) {
                    ForEach(items, id: \.self) { item in
                        if item.version == Bundle.version || item.subVersion == Bundle.version {
                            ForEach(item.new, id: \.self) { new in
                                HStack(alignment: .top) {
                                    if align == .leading || align == .center {
                                        iconView(for: new)
                                    }

                                    VStack(alignment: align == .trailing ? .trailing : .leading, spacing: 4) {
                                        Text(new.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text(new.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                        Text(new.body)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                    }

                                    if align == .trailing {
                                        iconView(for: new)
                                    }
                                }
                                .padding(.bottom, 8)
                            }
                        }
                    }
                }
            }

            Spacer()

            if history {
                showHistoryButton
                    .padding(.bottom)
            }
        }
        .onAppear { loadData() }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func iconView(for item: ChangeItem) -> some View {
        ZStack {
            color
            Image(systemName: item.icon)
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
    }
}
