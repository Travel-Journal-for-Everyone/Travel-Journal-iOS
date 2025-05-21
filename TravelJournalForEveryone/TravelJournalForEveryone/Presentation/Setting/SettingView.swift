//
//  SettingView.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/21/25.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var coordinator: DefaultCoordinator
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            menuSection
            Spacer()
            outSection
                .padding(.bottom, 98)
        }
        .padding(.horizontal, 16)
        .padding(.top, 15)
        .onChange(of: authViewModel.state.isLoading) { oldValue, newValue in
            guard oldValue else { return }
            
            if !newValue {
                coordinator.popToRoot()
                coordinator.selectedTab = .myJournal
            }
        }
        .customNavigationBar {
            Text("설정")
                .font(.pretendardMedium(17))
        } leadingView: {
            Button {
                coordinator.pop()
            } label: {
                Image(.tjLeftArrow)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
}

extension SettingView {
    private var menuSection: some View {
        VStack {
            MenuHorizontalView(text: "알림 설정") {
                Image(.tjNext)
                    .resizable()
                    .frame(width: 24, height: 24)
            } action: {
                coordinator.push(.pushSetting)
            }
            
            MenuHorizontalView(text: "화면모드 설정") {
                Image(.tjNext)
                    .resizable()
                    .frame(width: 24, height: 24)
            } action: {
                coordinator.push(.screenSetting)
            }
            
            MenuHorizontalView(text: "이용약관") { }
            MenuHorizontalView(text: "개인정보 처리방침") { }
            MenuHorizontalView(text: "앱 버전 정보") {
                Text("v.1.0.0")
                    .font(.pretendardMedium(16))
                    .foregroundStyle(.tjPrimaryMain)
            } action: { }
        }
    }
    
    private var outSection: some View {
        HStack(spacing: 8) {
            Button {
                authViewModel.send(.logout)
            } label: {
                Text("로그아웃")
                    .font(.pretendardMedium(12))
                    .foregroundStyle(.tjGray3)
            }
            
            Rectangle()
                .frame(width: 1.adjustedW, height: 8.adjustedH)
                .foregroundStyle(.tjGray3)
            
            Button {
                authViewModel.send(.unlink)
            } label: {
                Text("회원탈퇴")
                    .font(.pretendardMedium(12))
                    .foregroundStyle(.tjGray3)
            }
        }
    }
}

#Preview {
    SettingView()
}
