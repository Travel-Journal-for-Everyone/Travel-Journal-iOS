//
//  MainTabView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var coordinator: DefaultCoordinator
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $coordinator.selectedTab) {
                NavigationStack(path: $coordinator.myJournalPath) {
                    MyJournalView()
                        .tag(TJTab.myJournal)
                        .navigationDestination(for: Screen.self) { screen in
                            coordinator.build(screen)
                        }
                }
                
                SearchView()
                    .tag(TJTab.search)
                
                ExploreView()
                    .tag(TJTab.explore)
                
                Text("프로필")
                    .tag(TJTab.profile)
            }
            
            if coordinator.isPresentingTabBar {
                customTabBar
                    .transition(.offset(y: 150))
            }
        }
    }
    
    private var customTabBar: some View {
        VStack {
            Rectangle()
                .foregroundStyle(.tjGray4)
                .frame(height: 0.33)
            
            HStack {
                Spacer()
                
                ForEach(TJTab.allCases, id: \.title) { tab in
                    Spacer()
                    
                    Button {
                        coordinator.selectedTab = tab
                    } label: {
                        tabButtonView(
                            tab,
                            isSelected: coordinator.selectedTab == tab
                        )
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .background(.tjWhite.opacity(0.8))
    }
    
    private func tabButtonView(_ tab: TJTab, isSelected: Bool) -> some View {
        VStack(spacing: 6) {
            Image(isSelected ? tab.imageString.selected : tab.imageString.unselected)
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(tab.title)
                .font(.pretendardSemiBold(10))
                .foregroundStyle(isSelected ? .tjBlack : .tjGray3)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DefaultCoordinator())
}
