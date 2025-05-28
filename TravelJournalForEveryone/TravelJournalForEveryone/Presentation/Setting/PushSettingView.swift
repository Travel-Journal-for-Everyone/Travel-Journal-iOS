//
//  PushSettingView.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/21/25.
//

import SwiftUI

struct PushSettingView: View {
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
        .onAppear {
            viewModel.send(.viewOnAppear)
        }
    }
}

extension PushSettingView {
    private var menuSection: some View {
        VStack {
            MenuHorizontalView(text: "푸시 알림") {
                Toggle("", isOn: Binding(
                    get: { viewModel.state.isAllPushOn },
                    set: { _ in
                        viewModel.send(.allToggleTapped)
                    })
                )
                .frame(width: 51.adjustedW, height: 29.adjustedH)
                .tint(.tjPrimaryMain)
            } action: { }
            
            if viewModel.state.isAllPushOn {
                ForEach(PushType.allCases, id: \.self) { type in
                    MenuHorizontalView(text: type.title) {
                        Toggle("", isOn: Binding(
                            get: { viewModel.state.pushList.contains(type) },
                            set: { _ in
                                viewModel.send(.pushTypeTapped(type: type))
                            })
                        )
                        .frame(width: 51.adjustedW, height: 29.adjustedH)
                        .tint(.tjPrimaryMain)
                    } action: { }
                }
            }
        }
    }
}

#Preview {
    PushSettingView(viewModel: .init())
}
