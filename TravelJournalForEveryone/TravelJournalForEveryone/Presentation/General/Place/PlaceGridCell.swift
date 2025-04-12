//
//  PlaceGridCell.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/8/25.
//

import SwiftUI

struct PlaceGridCell: View {
    private let place: PlaceSummary
    
    init(_ placeSummary: PlaceSummary) {
        self.place = placeSummary
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // TODO: - Image 어떻게 할지 정하기
            AsyncImage(url: URL(string: place.imageURLString)) { image in
                image.resizable()
                image.aspectRatio(contentMode: .fit)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.tjGray6)
            }
            .frame(width: 168.adjustedW, height: 168.adjustedH)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.bottom, 10)
            
            Text(place.name)
                .font(.pretendardMedium(16))
                .foregroundStyle(.tjBlack)
                .padding(.bottom, 5)
            
            Text(place.address)
                .font(.pretendardRegular(12))
                .foregroundStyle(.tjGray2)
        }
    }
}

#Preview {
    JournalPlaceListView(
        viewModel: .init(
            fetchJournalsUseCase: DIContainer.shared.fetchJournalsUseCase,
            user: .mock(),
            viewType: .all(.place)
        )
    )
}
