//
//  ProfileCreationView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI
import PhotosUI

struct ProfileCreationView: View {
    @StateObject var viewModel: ProfileCreationViewModel
    @EnvironmentObject private var coordinator: DefaultCoordinator
    
    @State var isTappedAccountScopeButton: Bool = false
    @State private var isShowingDialog: Bool = false
    @State private var isShowingPhotosPicker: Bool = false
    
    @FocusState private var nicknameFocusState: Bool
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(spacing: 0) {
                    
                    ProfileImageView(
                        viewType: viewModel.state.isEditing ? .profileEditing : .profileCreation,
                        image: viewModel.state.selectedImage,
                        imageString: viewModel.state.profileImageString
                    )
                    .overlay(alignment: .bottomTrailing) {
                        cameraIconView
                    }
                    .onTapGesture {
                        hideKeyboard()
                        isTappedAccountScopeButton = false
                        isShowingDialog = true
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 40)
                    
                    VStack(spacing: 15) {
                        userInfoInputAreaFor(.nickname)
                        userInfoInputAreaFor(.accountScope)
                            .padding(.bottom, 45)
                    }
                    
                    Spacer()
                    
                    TJButton(
                        title: viewModel.state.isEditing ? "수정 완료" : "작성 완료",
                        isDisabled: viewModel.state.isDisableCompletionButton)
                    {
                        viewModel.send(.tappedCompletionButton)
                    }
                    .padding(.bottom, 17)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .customNavigationBar {
                Text(viewModel.state.isEditing ? "프로필 수정" : "프로필 작성")
                    .font(.pretendardMedium(17))
            } leadingView: {
                Group {
                    if viewModel.state.isEditing {
                        Image(.tjLeftArrow)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                coordinator.pop()
                            }
                    } else {
                        EmptyView()
                    }
                }
            }
            
            if viewModel.state.isLoading {
                Color.black.opacity(0.25)
                    .ignoresSafeArea(.all)
                
                ProgressView()
            }
        }
        .photosPicker(
            isPresented: $isShowingPhotosPicker,
            selection:
                Binding( get: { viewModel.state.selectedItem },
                         set: {  viewModel.send(.selectedPhoto($0)) }
                       ),
            matching: .images)
        .confirmationDialog("프로필 사진 선택", isPresented: $isShowingDialog, actions: {
            Button("기본 이미지 선택하기") {
                viewModel.send(.changeDefaultImage)
            }
            Button("앨범에서 가져오기") {
                isShowingPhotosPicker = true
            }
        })
        .onTapGesture {
            hideKeyboard()
            isTappedAccountScopeButton = false
        }
        .onAppear {
            viewModel.send(.viewOnAppear)
        }
        .onChange(of: viewModel.state.isNavigateToRootView) { _, newValue in
            if newValue {
                coordinator.pop()
            }
        }
        .navigationDestination(
            isPresented: Binding(
                get: { viewModel.state.isPresentedSignupCompletionView },
                set: { viewModel.send(.isPresentedProfileCreationView($0)) }
            )
        ) {
            SignupCompletionView()
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
                .font(.pretendardMedium(16))
                .padding(.bottom, 15)
            
            switch type {
            case .nickname:
                nicknameTextView
            case .accountScope:
                accountScopeButton
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
                        .focused($nicknameFocusState)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .font(.pretendardRegular(16))
                        .padding(.horizontal, 20)
                        .submitLabel(.done)
                        .onSubmit {
                            guard !viewModel.state.isDisableNicknameCheckButton
                            else { return }
                            viewModel.send(.tappedNicknameCheckButton)
                        }
                    }
                
                TJButton(
                    title: viewModel.state.isCheckingNickname ? "" : "중복 확인",
                    isDisabled: viewModel.state.isDisableNicknameCheckButton,
                    size: .short
                ) {
                    hideKeyboard()
                    isTappedAccountScopeButton = false
                    
                    viewModel.send(.tappedNicknameCheckButton)
                }
                .overlay {
                    if viewModel.state.isCheckingNickname {
                        ProgressView()
                    }
                }
            }
            
            Text(viewModel.state.nicknameValidationMessage)
                .font(.pretendardRegular(12))
                .foregroundStyle(viewModel.state.messageColor)
        }
        .onChange(
            of: viewModel.state.isFocusedNicknameTextField
        ) { _, newValue in
            nicknameFocusState = newValue
        }
    }
    
    private var accountScopeButton: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 14) {
                ForEach(
                    Array(AccountScope.allCases.enumerated()),
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
                        isTappedAccountScopeButton.toggle()
                        
                        viewModel.send(.tappedAccountScope(scope))
                    }
                    .padding(.horizontal, 20)
                    
                    if index < AccountScope.allCases.count - 1 {
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
            .offset(y: isTappedAccountScopeButton ? 50 : 0)
            .opacity(isTappedAccountScopeButton ? 1 : 0)
            .animation(
                .easeIn(duration: 0.15),
                value: isTappedAccountScopeButton
            )
            
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 50)
                .foregroundStyle(.tjGray6)
                .overlay {
                    HStack(spacing: 5) {
                        Text("\(viewModel.state.accountScope.title)")
                            .font(.pretendardRegular(16))
                        
                        Image(viewModel.state.accountScope.imageResourceString)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Spacer()
                        
                        Image("TJArrowTriangle.up.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .rotationEffect(
                                .degrees(isTappedAccountScopeButton ? 0 : 180)
                            )
                            .animation(
                                .easeInOut(duration: 0.2),
                                value: isTappedAccountScopeButton
                            )
                    }
                    .padding(.horizontal, 20)
                }
                .onTapGesture {
                    hideKeyboard()
                    isTappedAccountScopeButton.toggle()
                }
        }
    }
}

#Preview {
    ProfileCreationView(
        viewModel: ProfileCreationViewModel(
            nicknameCheckUseCase: DIContainer.shared.nickNameCheckUseCase,
            updateProfileUseCase: DIContainer.shared.updateProfileUseCase
        )
    )
}

extension ProfileCreationView {
    enum InputType {
        case nickname
        case accountScope
        
        var title: String {
            switch self {
            case .nickname:
                return "닉네임"
            case .accountScope:
                return "프로필 공개 범위"
            }
        }
    }
}
