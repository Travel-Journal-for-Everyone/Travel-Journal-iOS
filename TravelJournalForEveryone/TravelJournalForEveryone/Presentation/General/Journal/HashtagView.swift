//
//  HashtagView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/8/25.
//

import SwiftUI

struct HashtagView: View {
    private let hashtag: [String]
    private let isLightMode: Bool
    
    init(_ hashtag: [String], isLightMode: Bool = false) {
        self.hashtag = hashtag
        self.isLightMode = isLightMode
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(hashtag, id: \.self) { tag in
                Text("#\(tag)")
                    .foregroundColor(isLightMode ? .tjPrimaryMain : .tjPrimaryMain)
                    .font(.pretendardRegular(12))
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(
                        Capsule()
                            .fill(isLightMode ? .tjWhite : .tjPrimaryLight)
                    )
            }
            
            Spacer()
        }
    }
}

#Preview {
    VStack {
        HashtagView(["바다", "부산", "해운대"])
        
        HashtagView(["바다", "부산", "해운대"], isLightMode: true)
    }
    .padding()
    .background(.tjGray5)
}
