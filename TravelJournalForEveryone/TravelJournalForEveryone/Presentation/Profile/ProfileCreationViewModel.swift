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
    var isDisableNicknameCheckButton: Bool = false
    var isDisableCompletionButton: Bool = false
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
    
    func send(_ intent: ProfileCreationIntent) {
        switch intent {
        case .viewOnAppear:
            // 프로필 수정이라면 기존 회원정보로 뷰 세팅
            break
        case .enterNickname(let nickname):
            print("닉네임 입력중: \(nickname)")
        case .tappedNicknameCheckButton:
            print("Tapped: 닉네임 중복 확인 버튼 ")
        case .tappedProfileVisibilityScope(let profileVisibilityScope):
            print("Tapped: 계정 범위 설정 - \(profileVisibilityScope)")
        case .tappedCompletionButton:
            // 입력된 프로필 사진, 닉네임, 계정 범위를 서버로 전달해야 함
            print("Tapped: 작성 완료 버튼 눌림")
        }
    }
}
