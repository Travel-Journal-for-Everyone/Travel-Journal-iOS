//
//  ProfileCreationViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/26/25.
//

import SwiftUI
import Combine
import PhotosUI

@MainActor
final class ProfileCreationViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    @Published private var tempNickname: String = ""
    @Published private var nicknameRegexCheckResult: NicknameRegexCheckResult = .initial
    @Published private var nicknameServerCheckResult: NicknameServerCheckResult = .initial
    
    private let userInfoManager: UserInfoManager = DIContainer.shared.userInfoManager
    
    private let nicknameCheckUseCase: NicknameCheckUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    private var cancellables: Set<AnyCancellable> = []

    init(
        nicknameCheckUseCase: NicknameCheckUseCase,
        updateProfileUseCase: UpdateProfileUseCase,
        isEditing: Bool = false
    ) {
        self.nicknameCheckUseCase = nicknameCheckUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.state.isEditing = isEditing
        bind()
    }
    
    private func bind() {
        $tempNickname
            .removeDuplicates()
            .map { [weak self] tempNickname in
                guard let self else { return .initial }
                
                if state.tempNickname != tempNickname {
                    self.state.isDisableNicknameCheckButton = false
                    self.state.isDisableCompletionButton = true
                    nicknameServerCheckResult = .changed
                }
                
                self.state.tempNickname = tempNickname
                
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
    
    func send(_ intent: Intent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        case .enterNickname(let tempNickname):
            self.tempNickname = tempNickname
        case .tappedNicknameCheckButton:
            handleTappedNicknameCheckButton()
            updateCompletionButtonState()
        case .tappedAccountScope(let accountScope):
            state.accountScope = accountScope
            updateCompletionButtonState()
        case .tappedCompletionButton:
            handleTappedCompletionButton()
        case .selectedPhoto(let item):
            state.selectedItem = item
            Task {
                await loadImage()
                updateCompletionButtonState()
            }
        case .changeDefaultImage:
            state.selectedImage = nil
            state.selectedItem = nil
            state.profileImageString = ""
            updateCompletionButtonState()
        case .isPresentedProfileCreationView(let result):
            state.isPresentedSignupCompletionView = result
        }
    }
}

extension ProfileCreationViewModel {
    struct State {
        var profileImageString: String = ""
        var nickname: String = ""
        var tempNickname: String = ""
        var nicknameValidationMessage: String = ""
        var messageColor: Color = .tjRed
        var accountScope: AccountScope = .publicProfile
        
        var isDisableNicknameCheckButton: Bool = true
        var isDisableCompletionButton: Bool = true
        var isCheckingNickname: Bool = false
        
        var selectedItem: PhotosPickerItem?
        var selectedImage: Image?
        var selectedImageData: Data?
        
        var isPresentedSignupCompletionView: Bool = false
        var isNavigateToRootView: Bool = false
        
        var isFocusedNicknameTextField: Bool = false
        
        var isLoading: Bool = false
        var isEditing: Bool = false
    }

    enum Intent {
        case viewOnAppear
        case enterNickname(String)
        case tappedNicknameCheckButton
        case tappedAccountScope(AccountScope)
        case tappedCompletionButton
        case selectedPhoto(PhotosPickerItem?)
        case changeDefaultImage
        case isPresentedProfileCreationView(Bool)
    }

}

extension ProfileCreationViewModel {
    private func handleViewOnAppear() {
        if state.isEditing {
            let user = userInfoManager.user
            
            state.profileImageString = user.profileImageURLString
            state.tempNickname = user.nickname
            state.nickname = user.nickname
            state.accountScope = user.accountScope
            nicknameRegexCheckResult = .valid
        }
    }
    
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
                    print("⛔️ Nickname check error: \(error)")
                }
                
                self.state.isCheckingNickname = false
            } receiveValue: { [weak self] result in
                guard let self else { return }
                
                self.updateStateForNicknameValidationForServer(result)
                self.nicknameServerCheckResult = result
                self.updateCompletionButtonState()
            }
            .store(in: &cancellables)
    }
    
    private func handleTappedCompletionButton() {
        state.nickname = state.tempNickname
        state.isLoading = true

        updateProfileUseCase.execute(
            nickname: state.nickname,
            accountScope: state.accountScope,
            memberDefaultImage: state.profileImageString.isEmpty && state.selectedImage == nil,
            image: state.selectedImageData
        )
        .sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("⛔️ Profile-Update error: \(error)")
            }
            
            self?.state.isLoading = false
        } receiveValue: { [weak self] result in
            if result {
                if let isEditing = self?.state.isEditing,
                   isEditing {
                    self?.state.isNavigateToRootView = true
                } else {
                    self?.state.isPresentedSignupCompletionView = true
                }
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
        case .valid, .initial, .empty:
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
            if !state.isEditing {
                state.isDisableCompletionButton = false
            }
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
        default:
            break
        }
    }
    
    private func loadImage() async {
        state.profileImageString = ""
        
        guard let item = state.selectedItem else { return }
        
        item.loadTransferable(type: Data.self) { result in
            Task { @MainActor [weak self] in
                switch result {
                case .success(let data):
                    guard let data,
                          let jpegData = UIImage(data: data)?.jpegData(compressionQuality: 0.1),
                          let uiImage = UIImage(data: jpegData) else { return }
                    let image = Image(uiImage: uiImage)
                    self?.state.selectedImageData = jpegData
                    self?.state.selectedImage = image
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    private func updateCompletionButtonState() {
        if state.isEditing {
            let user = userInfoManager.user
            
            let isNicknameChanged = state.tempNickname != user.nickname
            let isNicknameValidServer = nicknameServerCheckResult == .valid || nicknameServerCheckResult == .initial
            let isNicknameValidRegex = nicknameRegexCheckResult == .valid || nicknameRegexCheckResult == .initial
            
            let isAccountScopeChanged = state.accountScope != user.accountScope
            
            let isImageChanged = state.profileImageString == ""
            
            let isComplete = (isNicknameChanged || isImageChanged || isAccountScopeChanged) && isNicknameValidServer && isNicknameValidRegex
            state.isDisableCompletionButton = !isComplete
        }
    }
}
