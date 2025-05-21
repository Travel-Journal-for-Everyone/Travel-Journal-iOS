//
//  PushSettingView.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/21/25.
//

import SwiftUI

struct PushSettingView: View {
    @EnvironmentObject private var coordinator: DefaultCoordinator
    
    var body: some View {
        VStack {
            menuSection
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 15)
        .customNavigationBar {
            Text("푸시 알림")
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

extension PushSettingView {
    private var menuSection: some View {
        VStack {
            MenuHorizontalView(text: "전체 푸시 알림") {
                Toggle("", isOn: .constant(true))
                    .frame(width: 51.adjustedW, height: 29.adjustedH)
                    .tint(.tjPrimaryMain)
            } action: {
                // 푸시 관련 설정
            }
            
            MenuHorizontalView(text: "댓글 알림") {
                Toggle("", isOn: .constant(true))
                    .frame(width: 51.adjustedW, height: 29.adjustedH)
                    .tint(.tjPrimaryMain)
            } action: {
                // 푸시 관련 설정
            }
            
            MenuHorizontalView(text: "좋아요 알림") {
                Toggle("", isOn: .constant(true))
                    .frame(width: 51.adjustedW, height: 29.adjustedH)
                    .tint(.tjPrimaryMain)
            } action: {
                // 푸시 관련 설정
            }
            
            MenuHorizontalView(text: "팔로우 요청 알림") {
                Toggle("", isOn: .constant(true))
                    .frame(width: 51.adjustedW, height: 29.adjustedH)
                    .tint(.tjPrimaryMain)
            } action: {
                // 푸시 관련 설정
            }
        }
    }
}

#Preview {
    PushSettingView()
}
