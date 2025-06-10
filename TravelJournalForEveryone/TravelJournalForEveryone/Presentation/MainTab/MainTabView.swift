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
                // MyJournal
                NavigationStack(path: $coordinator.myJournalPath) {
                    MyJournalView(
                        viewModel: .init(
                            fetchUserUseCase: DIContainer.shared.fetchUserUseCase,
                            followUseCase: DIContainer.shared.followUseCase,
                            unfollowUseCase: DIContainer.shared.unfollowUseCase,
                            checkFollowUseCase: DIContainer.shared.checkFollowUseCase,
                            blockUseCase: DIContainer.shared.blockUseCase,
                            unblockUseCase: DIContainer.shared.unblockUseCase
                        )
                    )
                    .navigationDestination(for: Screen.self) { screen in
                        coordinator.build(screen)
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
                .tag(TJTab.myJournal)
                
                // Search
                NavigationStack(path: $coordinator.searchPath) {
                    SearchView(viewModel: .init(
                        searchMembersUseCase: DIContainer.shared.searchMembersUseCase,
                        searchPlacesUseCase: DIContainer.shared.searchPlacesUseCase,
                        searchJournalsUseCase: DIContainer.shared.searchJournalsUseCase
                    ))
                    .navigationDestination(for: Screen.self) { screen in
                        coordinator.build(screen)
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
                .tag(TJTab.search)
                
                // Explore
                NavigationStack(path: $coordinator.explorePath) {
                    ExploreView(viewModel: .init(
                        fetchExploreJournalsUseCase: DIContainer.shared.fetchExploreJournalsUseCase,
                        markJournalsUseCase: DIContainer.shared.markJournalsUseCase
                    ))
                    .navigationDestination(for: Screen.self) { screen in
                        coordinator.build(screen)
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
                .tag(TJTab.explore)
                
                // Profile
                NavigationStack(path: $coordinator.profilePath) {
                    ProfileView(viewModel: .init())
                        .navigationDestination(for: Screen.self) { screen in
                            coordinator.build(screen)
                        }
                        .toolbar(.hidden, for: .tabBar)
                }
                .tag(TJTab.profile)
            }
            
            GeometryReader { _ in
                VStack {
                    Spacer()
                    if coordinator.isPresentingTabBar {
                        customTabBar
                            .transition(.offset(y: 150))
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
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
