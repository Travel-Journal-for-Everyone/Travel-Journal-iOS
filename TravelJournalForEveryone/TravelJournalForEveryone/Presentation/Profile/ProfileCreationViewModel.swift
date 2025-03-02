//
//  ProfileCreationViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/26/25.
//

import Foundation
import Combine

// MARK: - State
struct ProfileCreationModelState {
    var profileImageString: String = ""
    var nickname: String = ""
    var tempNickname: String = ""
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
    
    @Published private var tempNickname: String = ""
    @Published private var nicknameRegexCheckResult: NicknameRegexCheckResult = .empty
    
    private let nicknameCheckUseCase: NicknameCheckUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(nicknameCheckUseCase: NicknameCheckUseCase) {
        self.nicknameCheckUseCase = nicknameCheckUseCase
        
        bind()
    }
    
    private func bind() {
        $tempNickname
            .removeDuplicates()
            .map { [weak self] tempNickname in
                guard let self else { return .empty }
                
                self.state.tempNickname = tempNickname
                self.state.isDisableCompletionButton = true
                self.state.isDisableNicknameCheckButton = (tempNickname == self.state.nickname)
                
                return self.nicknameCheckUseCase.validateNicknameByRegex(tempNickname)
            }
            .assign(to: &$nicknameRegexCheckResult)
        
        $nicknameRegexCheckResult
            .sink { [weak self] result in
                guard let self else { return }
                self.updateStateForNicknameValidationForRegex(result)
            }
            .store(in: &cancellables)
    }
    
    func send(_ intent: ProfileCreationIntent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        case .enterNickname(let tempNickname):
            self.tempNickname = tempNickname
        case .tappedNicknameCheckButton:
            handleTappedNicknameCheckButton()
        case .tappedProfileVisibilityScope(let profileVisibilityScope):
            print("Tapped: 계정 범위 설정 - \(profileVisibilityScope)")
        case .tappedCompletionButton:
            handleTappedCompletionButton()
        }
    }
    
    private func handleViewOnAppear() { }
    
    private func handleTappedNicknameCheckButton() {
        nicknameCheckUseCase.validateNicknameByServer(tempNickname)
            .sink { _ in
                // TODO: - 에러 처리
            } receiveValue: { [weak self] result in
                self?.updateStateForNicknameValidationForServer(result)
            }
            .store(in: &cancellables)
    }
    
    private func handleTappedCompletionButton() {
        // 입력된 프로필 사진, 닉네임, 계정 범위를 서버로 전달해야 함
        print("Tapped: 작성 완료 버튼 눌림")
    }
    
    private func updateStateForNicknameValidationForRegex(_ result: NicknameRegexCheckResult) {
        if result == .valid {
            state.isDisableNicknameCheckButton = (state.tempNickname == state.nickname)
        } else {
            state.isDisableNicknameCheckButton = true
        }
        
        switch result {
        case .valid, .empty:
            state.errorMessage = ""
        case .tooShort:
            state.errorMessage = "2자 이상 입력해주세요."
        case .containsWhitespace:
            state.errorMessage = "띄어쓰기는 사용할 수 없습니다."
        case .invalidCharacters:
            state.errorMessage = "한글, 영문, 숫자만 사용할 수 있습니다."
        }
    }
    
    private func updateStateForNicknameValidationForServer(_ result: NicknameServerCheckResult) {
        state.isDisableNicknameCheckButton = true
        
        if result == .valid {
            state.isDisableCompletionButton = false
        } else {
            state.isDisableCompletionButton = true
        }
        
        switch result {
        case .valid:
            // 성공 메시지 표시
            break
        case .containsBadWord:
            state.errorMessage = "이 닉네임은 사용할 수 없습니다."
        case .duplicate:
            state.errorMessage = "이미 사용중인 닉네임 입니다."
        case .unknownStringCode:
            break
        }
    }
}
