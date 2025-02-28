//
//  ProfileCreationViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/26/25.
//

import Foundation

// MARK: - State
struct ProfileCreationModelState {
    var profileImageString: String = ""
    var nickname: String = ""
    var errorMessage: String = ""
    var profileVisibilityScopre: ProfileVisibilityScope = .publicProfile
    var isDisableNicknameCheckButton: Bool = true
    var isDisableCompletionButton: Bool = true
}

// MARK: - Intent
enum ProfileCreationIntent {
    case viewOnAppear
    case enterNickname(String)
    case tappedNicknameCheckButton
    case tappedProfileVisibilityScope(ProfileVisibilityScope)
    case tappedCompletionButton
}

// MARK: - ViewModel(State + Intent)
final class ProfileCreationViewModel: ObservableObject {
    @Published private(set) var state = ProfileCreationModelState()
    
    private let nicknameCheckUseCase: NicknameCheckUseCase
    
    init(nicknameCheckUseCase: NicknameCheckUseCase) {
        self.nicknameCheckUseCase = nicknameCheckUseCase
    }
    
    func send(_ intent: ProfileCreationIntent) {
        switch intent {
        case .viewOnAppear:
            // 프로필 수정이라면 기존 회원정보로 뷰 세팅
            break
        case .enterNickname(let nickname):
            state.nickname = nickname
            let validationResult = nicknameCheckUseCase.validateNickname(nickname)
            updateStateForNicknameValidation(validationResult)
        case .tappedNicknameCheckButton:
            print("Tapped: 닉네임 중복 확인 버튼 ")
        case .tappedProfileVisibilityScope(let profileVisibilityScope):
            print("Tapped: 계정 범위 설정 - \(profileVisibilityScope)")
        case .tappedCompletionButton:
            // 입력된 프로필 사진, 닉네임, 계정 범위를 서버로 전달해야 함
            print("Tapped: 작성 완료 버튼 눌림")
        }
    }
    
    private func updateStateForNicknameValidation(_ result: NicknameValidationResult) {
        switch result {
        case .valid:
            state.errorMessage = ""
            state.isDisableNicknameCheckButton = false
        case .empty:
            state.errorMessage = ""
            state.isDisableNicknameCheckButton = true
        case .tooShort:
            state.errorMessage = "2자 이상 입력해주세요."
            state.isDisableNicknameCheckButton = true
        case .containsWhitespace:
            state.errorMessage = "띄어쓰기는 사용할 수 없습니다."
            state.isDisableNicknameCheckButton = true
        case .invalidCharacters:
            state.errorMessage = "한글, 영문, 숫자만 사용할 수 있습니다."
            state.isDisableNicknameCheckButton = true
        }
    }
}
