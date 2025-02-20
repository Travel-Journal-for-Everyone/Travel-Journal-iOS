//
//  TJButton.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct TJButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool
    var size: Size
    var height: CGFloat
    
    init(
        title: String,
        action: @escaping () -> Void,
        isDisabled: Bool = false,
        size: Size = .long,
        height: CGFloat = 50
    ) {
        self.title = title
        self.action = action
        self.isDisabled = isDisabled
        self.size = size
        self.height = height
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .frame(height: height)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: size.width, height: height)
                        // TODO: - 색상 정해주기
                        .foregroundStyle(isDisabled ? .gray : .blue)
                }
        }
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: 30) {
        TJButton(title: "작성 완료", action: { })
        TJButton(title: "작성 완료", action: { }, isDisabled: true)
        
        TJButton(title: "중복확인", action: { }, size: .short)
        TJButton(title: "중복확인", action: { }, isDisabled: true, size: .short)
    }
}

extension TJButton {
    enum Size {
        case short
        case long
        
        var width: CGFloat {
            switch self {
            case .short: return 81
            case .long: return 333
            }
        }
    }
}
