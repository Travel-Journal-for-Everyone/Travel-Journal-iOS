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
        RoundedRectangle(cornerRadius: 8)
            .frame(height: height)
            .frame(maxWidth: size.width)
            .foregroundStyle(isDisabled ? .tjGray4 : .tjPrimaryMain)
            .overlay {
                Text(title)
                    .font(.pretendardMedium(16))
                    .foregroundStyle(.white)
            }
            .onTapGesture {
                action()
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
            case .short: 88
            case .long: .infinity
            }
        }
    }
}
