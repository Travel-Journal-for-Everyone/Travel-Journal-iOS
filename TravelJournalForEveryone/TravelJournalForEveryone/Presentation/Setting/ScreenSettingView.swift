//
//  ScreenSettingView.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/21/25.
//

import SwiftUI

struct ScreenSettingView: View {
    @EnvironmentObject private var coordinator: DefaultCoordinator
    @StateObject var viewModel: SettingViewModel
    
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
            ForEach(ScreenType.allCases, id: \.self) { type in
                MenuHorizontalView(text: type.title) {
                    Image(.tjCheck)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .opacity(viewModel.state.screenType == type ? 1 : 0)
                } action: {
                    viewModel.send(.changeScreenType(type: type))
                }
            }
        }
    }
}

#Preview {
    ScreenSettingView(viewModel: .init())
}
