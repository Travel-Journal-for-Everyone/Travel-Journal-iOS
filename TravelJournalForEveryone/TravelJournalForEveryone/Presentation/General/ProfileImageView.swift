//
//  ProfileImageView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct ProfileImageView: View {
    let viewType: ViewType
    var image: Image?
    
    var body: some View {
        profileImageView
            .clipShape(Circle())
    }
    
    private var profileImageView: some View {
        Group {
            if let image {
                image
                    .resizable()
            } else {
                Image(.defaultProfile)
                    .resizable()
            }
        }
        .frame(
            width: viewType.size,
            height: viewType.size
        )
        .scaledToFill()
    }
}

#Preview {
    VStack {
        ProfileImageView(viewType: .listCell, image: nil)
        ProfileImageView(viewType: .home, image: nil)
    }
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
