//
//  LoginView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 1) {
                            Text("모두의 여행 일지")
                                .font(.pretendardBold(24))
                                .background {
                                    Rectangle()
                                        .frame(height: 34)
                                        .foregroundStyle(.tjPrimaryLight)
                                }
                            Text("와 함께")
                        }
                        Text("나만의 여행 일기를")
                        Text("만들어 보세요!")
                    }
                    .font(.pretendardMedium(24))
                    .padding(.bottom, 282)
                    
                    Spacer()
                }
                
                VStack(spacing: 10) {
                    Text("로그인/회원가입")
                        .font(.pretendardMedium(12))
                        .padding(.bottom, 8)
                    
                    loginButtonFor(.kakao)
                    
                    loginButtonFor(.apple)
                    
                    loginButtonFor(.google)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .navigationDestination(isPresented: Binding(get: { authViewModel.state.isPresentedProfileCreationView }, set: { authViewModel.send(.isPresentedProfileCreationView($0)) })) {
                ProfileCreationView()
            }
        }
    }
    
    private func loginButtonFor(_ type: LoginType) -> some View {
        Button {
            switch type {
            case .kakao:
                authViewModel.send(.kakaoLogin)
            case .apple:
                authViewModel.send(.appleLogin)
            case .google:
                authViewModel.send(.googleLogin)
            }
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 50)
                .foregroundStyle(type.backgroundColor)
                .overlay {
                    if type == .google {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.tjGray5, lineWidth: 1)
                    }
                }
                .overlay {
                    HStack(spacing: 8) {
                        Image("\(type.imageResourceString)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 21, height: 21)
                        
                        Text("\(type.title)")
                            .font(.pretendardMedium(16))
                            .foregroundStyle(type.textColor)
                    }
                }
        }
        
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
}
