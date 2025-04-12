//
//  JournalListCell.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/7/25.
//

import SwiftUI

struct JournalListCell: View {
    private let journal: JournalSummary
    
    init(_ journalSummary: JournalSummary) {
        self.journal = journalSummary
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HashtagView(journal.hashtag)
            
            Text(journal.title)
                .foregroundStyle(.tjBlack)
                .font(.pretendardSemiBold(16))
            
            HStack(spacing: 8) {
                Text("\(journal.nights)박 \(journal.days)일")
                    .font(.pretendardSemiBold(12))
                
                Text("\(journal.startDateString) ~ \(journal.endDateString)")
                    .font(.pretendardRegular(12))
            }
            .foregroundStyle(.tjGray2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.leading, 20)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.tjGray7)
        }
    }
}

#Preview {
    JournalListCell(
        .mock(
            id: 0,
            title: "바다만 주구창창 보았던 부산 여행 🌊"
        )
    )
}
