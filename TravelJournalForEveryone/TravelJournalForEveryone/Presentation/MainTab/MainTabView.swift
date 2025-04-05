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
                    MyJournalView(viewModel: .init())
                        .navigationDestination(for: Screen.self) { screen in
                            coordinator.build(screen)
                        }
                }
                .tag(TJTab.myJournal)
                
                NavigationStack(path: $coordinator.searchPath) {
                    SearchView()
                }
                .tag(TJTab.search)
                
                NavigationStack(path: $coordinator.explorePath) {
                    ExploreView()
                        .navigationDestination(for: Screen.self) { screen in
                            coordinator.build(screen)
                        }
                }
                .tag(TJTab.explore)
                
                
                NavigationStack(path: $coordinator.profilePath) {
                    ProfileView(user: .mock())
                        .navigationDestination(for: Screen.self) { screen in
                            coordinator.build(screen)
                        }
                }
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
            }
        }
        .frame(height: 55)
        .background(.tjWhite.opacity(0.85))
        .background(.ultraThinMaterial)
    }
    
    private func tabButtonView(_ tab: TJTab, isSelected: Bool) -> some View {
        VStack(spacing: 6) {
            Image(isSelected ? tab.symbolImage.selected : tab.symbolImage.unselected)
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
