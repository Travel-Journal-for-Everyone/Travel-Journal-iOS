//
//  ExploreJournalListCell.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/4/25.
//

import SwiftUI

struct ExploreJournalListCell: View {
    private let journal: ExploreJournalSummary
    
    init(_ exploreJournalSummary: ExploreJournalSummary) {
        self.journal = exploreJournalSummary
    }
    
    var body: some View {
        VStack(spacing: 10) {
            imageView
            
            infoView
                .padding(.leading, 15)
        }
        .padding(.bottom, 20)
        .background(.tjGray7)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.tjGray5, lineWidth: 1)
        }
    }
    
    private var imageView: some View {
        ZStack(alignment: .leading) {
            AsyncImage(url: URL(string: journal.thumbnailURLString)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 361.adjustedH)
            .clipped()
            
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.6),
                    .init(color: .tjBlack.opacity(0.3), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 5) {
                    ProfileImageView(
                        viewType: .exploringJournal,
                        imageString: journal.profileImageURLString
                    )
                    
                    Text("\(journal.nickname)")
                        .font(.pretendardSemiBold(16))
                        .foregroundStyle(.tjBlack)
                }
                
                Spacer()
                
                // TODO: - 라이트 버전으로 수정 필요
                HashtagView(journal.hashtag)
            }
            .padding(.leading, 15)
            .padding(.top, 20)
            .padding(.bottom, 15)
        }
        .frame(height: 361.adjustedH)
    }
    
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(journal.title)")
                .font(.pretendardSemiBold(18))
                .foregroundStyle(.tjBlack)
                .padding(.bottom, 8)
            
            Group {
                Text("\(journal.startDateString) ~ \(journal.endDateString)")
                    .padding(.bottom, 5)
                
                Text("\(journal.address)")
                    .padding(.bottom, 20)
            }
            .font(.pretendardRegular(12))
            .foregroundStyle(.tjGray2)
            
            HStack(spacing: 8) {
                HStack(spacing: 5) {
                    Image(.tjLike)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("\(journal.likeCount)")
                        .font(.pretendardMedium(12))
                        .foregroundStyle(.tjBlack)
                }
                
                HStack(spacing: 5) {
                    Image(.tjComment)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("\(journal.commentCount)")
                        .font(.pretendardMedium(12))
                        .foregroundStyle(.tjBlack)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ExploreJournalListCell(
        .mock(
            id: 0,
            title: "바다만 주구장창 보았던 부산 여행 🌊"
        )
    )
}
