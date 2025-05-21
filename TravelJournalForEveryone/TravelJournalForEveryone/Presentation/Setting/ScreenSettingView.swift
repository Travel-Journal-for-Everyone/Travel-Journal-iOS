//
//  ScreenSettingView.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/21/25.
//

import SwiftUI

struct ScreenSettingView: View {
    @EnvironmentObject private var coordinator: DefaultCoordinator
    
    var body: some View {
        VStack {
            menuSection
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 15)
        .customNavigationBar {
            Text("화면모드 설정")
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

extension ScreenSettingView {
    private var menuSection: some View {
        VStack {
            MenuHorizontalView(text: "라이트 모드") {
                Image(.tjCheck)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .opacity(0)
            } action: {
                
            }
            
            MenuHorizontalView(text: "다크 모드") {
                Image(.tjCheck)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .opacity(0)
            } action: {
                
            }
            
            MenuHorizontalView(text: "기기 설정과 동일") {
                Image(.tjCheck)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .opacity(1)
            } action: {
                
            }
        }
    }
}

#Preview {
    ScreenSettingView()
}
