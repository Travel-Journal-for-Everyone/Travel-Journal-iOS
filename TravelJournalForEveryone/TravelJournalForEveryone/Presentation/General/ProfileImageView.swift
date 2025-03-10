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
            .frame(
                width: viewType.size,
                height: viewType.size
            )
            .overlay(alignment: .bottomTrailing) {
                if viewType == .profileCreation || viewType == .profileEditing {
                    cameraIconView
                }
            }
        
    }
    
    private var profileImageView: some View {
        Group {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Circle()
                    .foregroundStyle(.tjGray4)
            }
        }
    }
    
    private var cameraIconView: some View {
        Circle()
            .foregroundStyle(.tjWhite)
            .frame(width: 40, height: 40)
            .overlay {
                Circle()
                    .stroke(.tjGray6, lineWidth: 1)
            }
            .overlay {
                Image("TJCamera.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 21)
            }
    }
}

#Preview {
    ProfileImageView(viewType: .listCell, image: nil)
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
