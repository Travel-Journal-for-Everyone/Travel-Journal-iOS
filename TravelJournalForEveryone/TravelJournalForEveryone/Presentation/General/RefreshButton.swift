//
//  RefreshButton.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/4/25.
//

import SwiftUI

struct RefreshButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Image(.tjRefresh)
                .resizable()
                .frame(width: 16, height: 16)
            
            Text("다시 불러오기")
                .font(.pretendardMedium(16))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 14)
        .foregroundStyle(.tjGray3)
        .background {
            Capsule(style: .circular)
                .stroke(.tjGray5, lineWidth: 1)
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    RefreshButton {
        print("새로 고침")
    }
}
