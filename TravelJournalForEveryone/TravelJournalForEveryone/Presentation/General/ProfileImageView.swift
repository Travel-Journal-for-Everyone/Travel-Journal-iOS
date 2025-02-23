//
//  ProfileImageView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct ProfileImageView: View {
    let viewType: ViewType
    
    var body: some View {
        // TODO: - 추후에 이미지 불러오는 코드로 변경
        Circle()
            .foregroundStyle(.tjGray4)
            .frame(
                width: viewType.size,
                height: viewType.size
            )
    }
}

#Preview {
    ProfileImageView(viewType: .listCell)
}

extension ProfileImageView {
    enum ViewType {
        case home
        case journalDetail
        case placeDetail
        case listCell
        case exploringJournal
        case comment
        case profileInfo
        case profileCreation
        case profileEditing
        
        var size: CGFloat {
            switch self {
            case .exploringJournal, .comment:
                return 30
            case .journalDetail, .placeDetail, .listCell:
                return 52
            case .home, .profileInfo:
                return 80
            case .profileCreation, .profileEditing:
                return 120
            }
        }
    }
}
