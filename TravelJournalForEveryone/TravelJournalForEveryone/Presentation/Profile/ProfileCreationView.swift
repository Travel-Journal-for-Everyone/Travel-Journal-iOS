//
//  ProfileCreationView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct ProfileCreationView: View {
    var isEditingProfile: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ProfileImageView(viewType: .profileCreation)
                .overlay(alignment: .bottomTrailing) {
                    cameraIconView
                }
                .onTapGesture {
                    // TODO: - 앨범에서 사진 선택 기능 넣기
                    print("앨범에서 사진 선택")
                }
            
            VStack(spacing: 40) {
                userInfoInputAreaFor(.nickname)
                
                userInfoInputAreaFor(.profileVisibilityScope)
            }
        }
    }
    
    private var cameraIconView: some View {
        Circle()
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .overlay {
                Circle()
                    .stroke(.gray, lineWidth: 1)
            }
            .overlay {
                Image(systemName: "camera.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 21)
            }
    }
    
    func userInfoInputAreaFor(_ type: InputType) -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text(type.title)
                .fontWeight(.medium)
                .font(.system(size: 18))
                .padding(.bottom, 15)
            
            switch type {
            case .nickname:
                TJButton(title: "닉네임을 입력하세요") {
                    
                }
            case .profileVisibilityScope:
                TJButton(title: "전체 공개") {
                    
                }
            }
        }
        .frame(width: .infinity)
        .background(.yellow)
    }
}

#Preview {
    ProfileCreationView()
}

extension ProfileCreationView {
    enum InputType {
        case nickname
        case profileVisibilityScope
        
        var title: String {
            switch self {
            case .nickname:
                return "닉네임"
            case .profileVisibilityScope:
                return "프로필 공개 범위"
            }
        }
    }
}
