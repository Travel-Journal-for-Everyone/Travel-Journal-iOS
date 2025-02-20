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
    @State var profileVisibilityScope: ProfileVisibilityScope = .publicProfile
    
    @State var isTappedProfileVisibilityScopeButton: Bool = false
    
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
                .padding(.top, 30)
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
        .customNavigationBar {
            Text("프로필 작성")
                .font(.system(size: 17, weight: .medium))
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
        VStack(alignment: .leading, spacing: 0) {
            Text(type.title)
                .font(.system(size: 18, weight: .medium))
                .padding(.bottom, 15)
            
            switch type {
            case .nickname:
                nicknameTextView
            case .profileVisibilityScope:
                profileVisibilityScopeButton
            }
        }
        .frame(width: 333)
    }
    
    private var nicknameTextView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 9)
                    .frame(width: 242, height: 50)
                // TODO: - 색상 변경 필요
                    .foregroundStyle(.gray.opacity(0.2))
                    .overlay {
                        TextField("닉네임을 입력하세요", text: $nicknameString)
                            .font(.system(size: 16, weight: .regular))
                            .padding(.horizontal, 20)
                    }
                
                TJButton(title: "중복 확인", size: .short) {
                    
                }
            }
            
            // TODO: - 에러 문구 로직 필요
            Text("")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.red)
        }
    }
    
    private var profileVisibilityScopeButton: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 10) {
                ForEach(
                    Array(ProfileVisibilityScope.allCases.enumerated()),
                    id: \.offset
                ) { index, scope in
                    Button {
                        // MARK: - 프로필 공개 범위 선택 액션
                        profileVisibilityScope  = scope
                        isTappedProfileVisibilityScopeButton.toggle()
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(spacing: 2) {
                                Text(scope.title)
                                    .font(.system(size: 16, weight: .medium))
                                
                                Image(systemName: "\(scope.iconName)")
                                
                                Spacer()
                            }
                            .foregroundStyle(.black)
                            
                            Text(scope.description)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    if index < ProfileVisibilityScope.allCases.count - 1 {
                        Divider()
                            .background(.gray.opacity(0.2))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    }
            }
            .offset(y: isTappedProfileVisibilityScopeButton ? 51 : 0)
            .opacity(isTappedProfileVisibilityScopeButton ? 1 : 0)
            .animation(
                .easeInOut(duration: 0.2),
                value: isTappedProfileVisibilityScopeButton
            )
            
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 333, height: 50)
            // TODO: - 색상 변경 필요
                .foregroundStyle(.gray)
                .overlay {
                    HStack {
                        Text("\(profileVisibilityScope.title)")
                            .font(.system(size: 16, weight: .regular))
                        
                        Spacer()
                        
                        Image(systemName: "arrowtriangle.up.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                            .rotationEffect(
                                .degrees(isTappedProfileVisibilityScopeButton ? 0 : 180)
                            )
                            .animation(
                                .easeInOut(duration: 0.2),
                                value: isTappedProfileVisibilityScopeButton
                            )
                    }
                    .padding(.horizontal, 20)
                }
                .onTapGesture {
                    isTappedProfileVisibilityScopeButton.toggle()
                }
        }
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
