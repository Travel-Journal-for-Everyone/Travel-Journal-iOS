//
//  ProfileImageView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct ProfileImageView: View {
    private let viewType: ViewType
    private let image: Image?
    private let imageString: String?
    
    init(
        viewType: ViewType,
        image: Image? = nil,
        imageString: String? = nil
    ) {
        self.viewType = viewType
        self.image = image
        self.imageString = imageString
    }
    
    var body: some View {
        profileImageView
            .clipShape(Circle())
    }
    
    private var profileImageView: some View {
        Group {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else if let imageString,
               let url = URL(string: imageString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
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
