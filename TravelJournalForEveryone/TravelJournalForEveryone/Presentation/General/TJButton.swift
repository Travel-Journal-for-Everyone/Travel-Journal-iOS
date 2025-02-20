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
        isDisabled: Bool = false,
        size: Size = .long,
        height: CGFloat = 50,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isDisabled = isDisabled
        self.size = size
        self.height = height
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: size.width, height: height)
                // TODO: - 색상 정해주기
                .foregroundStyle(isDisabled ? .gray : .blue)
                .overlay {
                    Text(title)
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                }
        }
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: 40) {
        VStack {
            TJButton(title: "작성 완료", action: { })
            TJButton(title: "작성 완료", isDisabled: true, action: { })
        }
        
        VStack {
            TJButton(title: "중복 확인", size: .short, action: { })
            TJButton(title: "중복 확인", isDisabled: true, size: .short, action: { })
        }
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
