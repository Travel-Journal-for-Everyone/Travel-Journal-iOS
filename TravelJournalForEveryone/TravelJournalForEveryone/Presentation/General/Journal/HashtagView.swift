//
//  HashtagView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/8/25.
//

import SwiftUI

struct HashtagView: View {
    private let hashtag: [String]
    
    init(_ hashtag: [String]) {
        self.hashtag = hashtag
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(hashtag, id: \.self) { tag in
                Text("#\(tag)")
                    .foregroundColor(.tjPrimaryMain)
                    .font(.pretendardRegular(12))
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(
                        Capsule()
                            .fill(.tjPrimaryLight)
                    )
            }
            
            Spacer()
        }
    }
}

#Preview {
    HashtagView(["바다", "부산", "해운대"])
}
