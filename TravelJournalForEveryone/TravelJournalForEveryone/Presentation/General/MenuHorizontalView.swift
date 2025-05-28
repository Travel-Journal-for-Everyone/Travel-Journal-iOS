//
//  MenuHorizontalView.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/2/25.
//
import SwiftUI

struct MenuHorizontalView<RightView: View>: View {
    private let text: String
    private let rightView: () -> RightView
    private let action: (() -> Void)?
    
    init(
        text: String,
        rightView: @escaping () -> RightView = { EmptyView() },
        action: (() -> Void)?
    ) {
        self.text = text
        self.rightView = rightView
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(text)")
                    .font(.pretendardMedium(16))
                Spacer()
                rightView()
            }
            .padding(15)
            Divider()
                .background(.tjGray6)
        }
        .frame(height: 50)
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
    }
}
