//
//  ProfileCreationView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct ProfileCreationView: View {
    @StateObject private var viewModel = ProfileCreationViewModel(
        nicknameCheckUseCase: DIContainer.shared.nickNameCheckUseCase
    )
    
    var isEditingProfile: Bool = false
    
    // TODO: - 임시로 뷰에 구현
    @State var profileVisibilityScope: ProfileVisibilityScope = .publicProfile
    
    @State var isTappedProfileVisibilityScopeButton: Bool = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(spacing: 0) {
                    ProfileImageView(viewType: .profileCreation)
                        .overlay(alignment: .bottomTrailing) {
                            cameraIconView
                        }
                        .onTapGesture {
                            // TODO: - 앨범에서 사진 선택 기능 넣기
                            hideKeyboard()
                            isTappedProfileVisibilityScopeButton = false
                            print("앨범에서 사진 선택")
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 40)
                    
                    VStack(spacing: 15) {
                        userInfoInputAreaFor(.nickname)
                        
                        userInfoInputAreaFor(.profileVisibilityScope)
                            .padding(.bottom, 45)
                    }
                    
                    Spacer()
                    
                    TJButton(
                        title: isEditingProfile ? "수정 완료" : "작성 완료",
                        isDisabled: viewModel.state.isDisableCompletionButton)
                    {
                        viewModel.send(.tappedCompletionButton)
                    }
                    .padding(.bottom, 17)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        }
        .customNavigationBar {
            Text(isEditingProfile ? "프로필 수정" : "프로필 작성")
                .font(.pretendardMedium(17))
        }
        .onTapGesture {
            hideKeyboard()
            isTappedProfileVisibilityScopeButton = false
        }
        .onAppear {
            viewModel.send(.viewOnAppear)
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
    
    func userInfoInputAreaFor(_ type: InputType) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(type.title)
                .font(.pretendardMedium(18))
                .padding(.bottom, 15)
            
            switch type {
            case .nickname:
                nicknameTextView
            case .profileVisibilityScope:
                profileVisibilityScopeButton
            }
        }
    }
    
    private var nicknameTextView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 9)
                    .frame(height: 50)
                    .foregroundStyle(.tjGray6)
                    .overlay {
                        TextField("닉네임을 입력하세요 (2~12자)", text: Binding(
                            get: { viewModel.state.tempNickname },
                            set: { viewModel.send(.enterNickname($0)) }
                        ))
                        .maxLength(text: Binding(
                            get: { viewModel.state.tempNickname },
                            set: { viewModel.send(.enterNickname($0)) }
                        ), 12)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .font(.pretendardRegular(16))
                        .padding(.horizontal, 20)
                        .submitLabel(.done)
                        .onSubmit {
                            viewModel.send(.tappedNicknameCheckButton)
                        }
                    }
                
                TJButton(
                    title: "중복 확인",
                    isDisabled: viewModel.state.isDisableNicknameCheckButton,
                    size: .short
                ) {
                    hideKeyboard()
                    isTappedProfileVisibilityScopeButton = false
                    
                    viewModel.send(.tappedNicknameCheckButton)
                }
            }
            
            Text(viewModel.state.errorMessage)
                .font(.pretendardRegular(12))
                .foregroundStyle(.tjRed)
        }
    }
    
    private var profileVisibilityScopeButton: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 14) {
                ForEach(
                    Array(ProfileVisibilityScope.allCases.enumerated()),
                    id: \.offset
                ) { index, scope in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 5) {
                            Text(scope.title)
                                .font(.pretendardMedium(16))
                            
                            Image(scope.imageResourceString)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                        
                        Text(scope.description)
                            .font(.pretendardRegular(14))
                            .foregroundStyle(.tjGray2)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        profileVisibilityScope  = scope
                        isTappedProfileVisibilityScopeButton.toggle()
                        
                        viewModel.send(.tappedProfileVisibilityScope(scope))
                    }
                    .padding(.horizontal, 20)
                    
                    if index < ProfileVisibilityScope.allCases.count - 1 {
                        Divider()
                            .background(.tjGray6)
                    }
                }
            }
            .padding(.vertical, 15)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.tjGray5, lineWidth: 1)
                    }
            }
            .offset(y: isTappedProfileVisibilityScopeButton ? 50 : 0)
            .opacity(isTappedProfileVisibilityScopeButton ? 1 : 0)
            .animation(
                .easeIn(duration: 0.15),
                value: isTappedProfileVisibilityScopeButton
            )
            
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 50)
                .foregroundStyle(.tjGray6)
                .overlay {
                    HStack(spacing: 5) {
                        Text("\(profileVisibilityScope.title)")
                            .font(.pretendardRegular(16))
                        
                        Image(profileVisibilityScope.imageResourceString)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Spacer()
                        
                        Image("TJArrowTriangle.up.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
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
                    hideKeyboard()
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
