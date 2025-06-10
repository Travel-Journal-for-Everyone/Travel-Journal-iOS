//
//  CustomAlertModifier.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/14/25.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    private let alertType: AlertType
    private let action: () -> Void
    
    init(
        isPresented: Binding<Bool>,
        alertType: AlertType,
        action: @escaping () -> Void
    ) {
        self._isPresented = isPresented
        self.alertType = alertType
        self.action = action
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.tjBlack
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(alignment: .center, spacing: 7) {
                        Text(alertType.title)
                            .font(.pretendardSemiBold(16))
                            .foregroundStyle(.tjBlack)
                        
                        Text(alertType.description)
                            .font(.pretendardRegular(12))
                            .foregroundStyle(.tjGray2)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 22)
                    .padding(.horizontal, 20)
                    
                    Color.tjGray5.frame(height: 1)
                    
                    HStack(spacing: 0) {
                        Button {
                            isPresented.toggle()
                        } label: {
                            Text(alertType.cancelLabel)
                                .font(.pretendardRegular(16))
                                .foregroundStyle(.tjBlack)
                                .contentShape(.rect)
                                .frame(maxWidth: .infinity)
                        }
                        
                        Color.tjGray5.frame(width: 1)
                        
                        Button {
                            isPresented.toggle()
                            action()
                        } label: {
                            Text(alertType.actionLabel)
                                .font(.pretendardSemiBold(16))
                                .foregroundStyle(.tjPrimaryMain)
                                .contentShape(.rect)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 43)
                }
                .frame(width: 271.adjustedW)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.tjWhite)
                }
            }
        }
    }
}

extension CustomAlertModifier {
    enum AlertType {
        case blockUser(nickname: String)
        case unblockUser(nickname: String)
        
        var title: String {
            switch self {
            case .blockUser(nickname: let nickname):
                "\(nickname) 님을 차단하시겠습니까?"
            case .unblockUser(let nickname):
                "\(nickname) 님을 차단 해제하시겠습니까?"
            }
        }
        
        var description: String {
            switch self {
            case .blockUser:
                "상대방이 탐험하기와 검색 결과에서 보이지 않습니다."
            case .unblockUser:
                "상대방이 나를 팔로우 할 수 있습니다."
            }
        }
        
        var actionLabel: String {
            switch self {
            case .blockUser:
                "차단하기"
            case .unblockUser:
                "차단 해제하기"
            }
        }
        
        var cancelLabel: String {
            switch self {
            case .blockUser, .unblockUser:
                "취소하기"
            }
        }
    }
}

#Preview {
    BlockedUserListView(
        viewModel: .init(
            fetchBlockedUsersUseCase: DIContainer.shared.fetchBlockedUsersUseCase,
            unblockUseCase: DIContainer.shared.unblockUseCase
        )
    )
    .customAlert(
        isPresented: .constant(true),
        alertType: .unblockUser(nickname: "마루김마루입니다요")
    ) { }
}
