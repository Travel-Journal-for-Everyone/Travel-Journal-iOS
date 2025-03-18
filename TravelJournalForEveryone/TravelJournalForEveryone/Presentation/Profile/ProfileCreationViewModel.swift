//
//  ProfileCreationViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/26/25.
//

import SwiftUI
import Combine
import PhotosUI

// MARK: - State
struct ProfileCreationModelState {
    var profileImageString: String = ""
    var nickname: String = ""
    var tempNickname: String = ""
    var nicknameValidationMessage: String = ""
    var messageColor: Color = .tjRed
    var accountScope: AccountScope = .publicProfile
    
    var isDisableNicknameCheckButton: Bool = true
    var isDisableCompletionButton: Bool = true
    var isCheckingNickname: Bool = false
    
    var selectedItem: PhotosPickerItem? = nil
    var selectedImage: Image? = nil
    
    var isPresentedSignupCompletionView: Bool = false
    var isFocusedNicknameTextField: Bool = false
}

// MARK: - Intent
enum ProfileCreationIntent {
    case viewOnAppear
    case enterNickname(String)
    case tappedNicknameCheckButton
    case tappedAccountScope(AccountScope)
    case tappedCompletionButton
    case selectedPhoto(PhotosPickerItem?)
    case changeDefaultImage
    case isPresentedProfileCreationView(Bool)
}

// MARK: - ViewModel(State + Intent)
@MainActor
final class ProfileCreationViewModel: ObservableObject {
    @Published private(set) var state = ProfileCreationModelState()
    
    @Published private var tempNickname: String = ""
    @Published private var nicknameRegexCheckResult: NicknameRegexCheckResult = .empty
    
    private let nicknameCheckUseCase: NicknameCheckUseCase
    private let signUpUseCase: SignUpUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        nicknameCheckUseCase: NicknameCheckUseCase,
        signUpUseCase: SignUpUseCase
    ) {
        self.nicknameCheckUseCase = nicknameCheckUseCase
        self.signUpUseCase = signUpUseCase
        bind()
    }
    
    private func bind() {
        $tempNickname
            .removeDuplicates()
            .map { [weak self] tempNickname in
                guard let self else { return .empty }
                
                self.state.tempNickname = tempNickname
                self.state.isDisableCompletionButton = true
                self.state.isDisableNicknameCheckButton = false
                
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
        case .tappedAccountScope(let accountScope):
            print("Tapped: 계정 범위 설정 - \(accountScope)")
        case .tappedCompletionButton:
            handleTappedCompletionButton()
        case .selectedPhoto(let item):
            state.selectedItem = item
            Task {
                await loadImage()
            }
        case .changeDefaultImage:
            state.selectedImage = nil
            state.selectedItem = nil
        case .isPresentedProfileCreationView(let result):
            state.isPresentedSignupCompletionView = result
        }
    }
    
    private func handleViewOnAppear() { }
    
    private func handleTappedNicknameCheckButton() {
        state.isCheckingNickname = true
        state.isDisableNicknameCheckButton = true
        state.isFocusedNicknameTextField = false
        
        nicknameCheckUseCase.validateNicknameByServer(tempNickname)
            .sink { [weak self] completion in
                guard let self else { return }
        
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    switch error {
                    case .invalidNickname(let reason):
                        let errorReason = NicknameServerCheckResult.from(response: reason)
                        self.updateStateForNicknameValidationForServer(errorReason)
                    default:
                        print("error: \(error)")
                    }
                }
                
                self.state.isCheckingNickname = false
            } receiveValue: { [weak self] result in
                guard let self else { return }
            
                self.updateStateForNicknameValidationForServer(result)
            }
            .store(in: &cancellables)
    }
    
    private func handleTappedCompletionButton() {
        state.nickname = state.tempNickname
        
        signUpUseCase.execute(
            state.nickname,
            state.accountScope
        )
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("온보딩 실패 : \(error)")
            }
        } receiveValue: { [weak self] result in
            if result {
                self?.state.isPresentedSignupCompletionView = true
            }
        }
        .store(in: &cancellables)
        
    }
    
    private func updateStateForNicknameValidationForRegex(_ result: NicknameRegexCheckResult) {
        if result == .valid {
            state.isDisableNicknameCheckButton = (state.tempNickname == state.nickname)
        } else {
            state.isDisableNicknameCheckButton = true
            state.messageColor = .tjRed
        }
        
        switch result {
        case .valid, .empty:
            state.nicknameValidationMessage = ""
        case .tooShort:
            state.nicknameValidationMessage = "2자 이상 입력해주세요."
        case .containsWhitespace:
            state.nicknameValidationMessage = "띄어쓰기는 사용할 수 없습니다."
        case .invalidCharacters:
            state.nicknameValidationMessage = "한글, 영문, 숫자만 사용할 수 있습니다."
        }
    }
    
    private func updateStateForNicknameValidationForServer(_ result: NicknameServerCheckResult) {
        if result == .valid {
            state.isDisableCompletionButton = false
            state.messageColor = .tjGreen
        } else {
            state.isDisableCompletionButton = true
            state.messageColor = .tjRed
            state.isFocusedNicknameTextField = true
        }
        
        switch result {
        case .valid:
            state.nicknameValidationMessage = "사용 가능한 닉네임 입니다."
        case .containsBadWord:
            state.nicknameValidationMessage = "이 닉네임은 사용할 수 없습니다."
        case .duplicate:
            state.nicknameValidationMessage = "이미 사용중인 닉네임 입니다."
        case .unknownStringCode:
            break
        }
    }
    
    private func loadImage() async {
        guard let item = state.selectedItem else { return }
        
        item.loadTransferable(type: Data.self) { result in
            Task { @MainActor [weak self] in
                switch result {
                case .success(let data):
                    guard let data,
                          let uiImage = UIImage(data: data) else { return }
                    let image = Image(uiImage: uiImage)
                    self?.state.selectedImage = image
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
}
