//
//  ProfileCreationView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct ProfileCreationView: View {
    var isEditingProfile: Bool = false
    
    // TODO: - 임시로 뷰에 구현
    @State var nicknameString = ""
    
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
                .padding(.bottom, 35)
            
            VStack(spacing: 15) {
                userInfoInputAreaFor(.nickname)
                
                userInfoInputAreaFor(.profileVisibilityScope)
            }
            
            Spacer()
            
            TJButton(title: isEditingProfile ? "수정 완료" : "작성 완료") {
                
            }
            .padding(.bottom, 17)
        }
        .padding(.horizontal, 30)
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
        VStack(alignment: .leading, spacing: 0) {
            Text(type.title)
                .fontWeight(.medium)
                .font(.system(size: 18))
                .padding(.bottom, 15)
            
            switch type {
            case .nickname:
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 9)
                            .frame(width: 242, height: 50)
                            // TODO: - 색상 변경 필요
                            .foregroundStyle(.gray.opacity(0.2))
                            .overlay {
                                TextField("닉네임을 입력하세요", text: $nicknameString)
                                    .padding(.horizontal, 20)
                            }
                        
                        TJButton(title: "중복 확인", size: .short) {
                            
                        }
                    }
                    
                    // TODO: - 에러 문구 로직 필요
                    Text("")
                        .fontWeight(.regular)
                        .font(.system(size: 12))
                        .foregroundStyle(.red)
                }
            case .profileVisibilityScope:
                TJButton(title: "전체 공개") {
                    
                }
            }
        }
        .frame(width: .infinity)
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
