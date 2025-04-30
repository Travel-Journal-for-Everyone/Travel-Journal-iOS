//
//  MyJournalView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct MyJournalView: View {
    @StateObject var viewModel: MyJournalViewModel
    @EnvironmentObject private var coordinator: DefaultCoordinator
    
    @State private var isPresentingMenu = false
    @State private var isPresentingJournalListViewForAll = false
    @State private var isPresentingJournalListViewForRegion = false
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                stops: [
                    .init(color: .tjWhite, location: 0),
                    .init(color: .tjGradient1, location: 0.25),
                    .init(color: .tjGradient2, location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            journalMap(regionDatas: viewModel.state.user.regionDatas)
                .offset(
                    x: 76.adjustedW,
                    y: viewModel.state.isCurrentUser && viewModel.state.isInitialView
                        ? 90.adjustedH
                        : 115.adjustedH
                )
            
            userInfoView
                .padding(.horizontal, 16)
            
            if isPresentingMenu {
                Color.clear
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.smooth(duration: 0.25)) {
                            isPresentingMenu.toggle()
                        }
                    }
                
                menuView
            }
            
            if viewModel.state.isCurrentUser && viewModel.state.isInitialView {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        journalCreateButton
                            .padding(.trailing, 31)
                            .padding(.bottom, 90.adjustedH)
                    }
                }
            }
            
            if viewModel.state.isTouchDisabled {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .sheet(isPresented: $isPresentingJournalListViewForRegion) {
            viewModel.send(.sheetDismissed)
        } content: {
            JournalPlaceListView(
                viewModel: .init(
                    fetchJournalsUseCase: DIContainer.shared.fetchJournalsUseCase,
                    fetchPlacesUseCase: DIContainer.shared.fetchPlacesUseCase,
                    user: viewModel.state.user,
                    viewType: .region(viewModel.state.selectedRegion)
                )
            )
            .padding(.top)
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isPresentingJournalListViewForAll) {
            viewModel.send(.sheetDismissed)
        } content: {
            JournalPlaceListView(
                viewModel: .init(
                    fetchJournalsUseCase: DIContainer.shared.fetchJournalsUseCase,
                    fetchPlacesUseCase: DIContainer.shared.fetchPlacesUseCase,
                    user: viewModel.state.user,
                    viewType: .all(viewModel.state.selectedActivityOverviewType)
                )
            )
            .padding(.top)
            .presentationDragIndicator(.visible)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.send(.viewOnAppear)
        }
    }
    
    private var userInfoView: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 10) {
                HStack(spacing: 0) {
                    if !viewModel.state.isInitialView {
                        Button {
                            coordinator.pop()
                        } label: {
                            Image(.tjLeftArrow)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .padding(.trailing, 5)
                    }
                    
                    Text("\(viewModel.state.user.nickname)")
                        .font(.pretendardBold(20))
                        .padding(.trailing, 5)
                    
                    Image("\(viewModel.state.user.accountScope.imageResourceString)")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Spacer()
                    
                    if viewModel.state.isCurrentUser && !viewModel.state.isInitialView {
                        EmptyView()
                    } else if viewModel.state.isCurrentUser {
                        Button {
                            print("알림 목록")
                        } label: {
                            Image(.tjBell)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    } else {
                        if viewModel.state.isLoadingFollowState {
                            // TODO: - SkeletonView가 있으면 좋을 듯
                            EmptyView()
                        } else {
                            FollowButton(isFollowing: viewModel.state.isFollowing) {
                                viewModel.send(.tappedFollowButton)
                            }
                            .padding(.trailing, 5)
                        }
                        
                        Button {
                            withAnimation(.smooth(duration: 0.25)) {
                                isPresentingMenu.toggle()
                            }
                        } label: {
                            Image(.tjMenu)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(isPresentingMenu ? .tjGray3 : .tjBlack)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(height: 30)
                
                HStack(spacing: 0) {
                    ProfileImageView(
                        viewType: .home,
                        imageString: viewModel.state.user.profileImageURLString
                    )
                    .padding(.trailing, 16)
                    
                    ActivityOverview(
                        user: viewModel.state.user,
                        isCurrentUser: viewModel.state.isCurrentUser,
                        memberID: viewModel.state.memberID
                    ) {
                        viewModel.send(.tappedActivityOverviewButton(.journal))
                        isPresentingJournalListViewForAll.toggle()
                    } placeAction: {
                        viewModel.send(.tappedActivityOverviewButton(.place))
                        isPresentingJournalListViewForAll.toggle()
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
    
    private var menuView: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    viewModel.send(.tappedBlockButton)
                    
                    withAnimation(.smooth(duration: 0.25)) {
                        isPresentingMenu.toggle()
                    }
                } label: {
                    HStack {
                        Text("차단하기")
                            .foregroundStyle(.tjBlack)
                            .font(.pretendardMedium(16))
                            .frame(height: 44)
                            .padding(.leading, 21)
                        
                        Spacer()
                    }
                }
                
                Rectangle()
                    .foregroundStyle(.tjGray5)
                    .frame(height: 1)
                
                Button(role: .destructive) {
                    viewModel.send(.tappedReportButton)
                    
                    withAnimation(.smooth(duration: 0.25)) {
                        isPresentingMenu.toggle()
                    }
                } label: {
                    HStack {
                        Text("신고하기")
                            .font(.pretendardMedium(16))
                            .frame(height: 44)
                            .padding(.leading, 21)
                        
                        Spacer()
                    }
                }
            }
            .frame(width: 194)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
                    .shadow(color: .gray.opacity(0.2), radius: 10)
            }
            .offset(y: 28.adjustedH)
            .padding(.trailing)
        }
        .zIndex(1)
        .transition(.scale(
            scale: 0,
            anchor: UnitPoint(x: 0.9, y: 0.3)
        ))
    }
    
    private var journalCreateButton: some View {
        Circle()
            .foregroundStyle(.tjPrimaryLight)
            .frame(width: 50, height: 50)
            .overlay {
                Image(.tjPencil)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.tjPrimaryMain)
            }
            .shadow(color: .tjGray1.opacity(0.1), radius: 10, y: 2)
            .onTapGesture {
                print("일지 작성하기")
            }
    }
    
    private func journalMap(regionDatas: [RegionData]) -> some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 0) {
                    // 강원도
                    regionMap(regionDatas[1])
                    
                    // 경상도
                    regionMap(regionDatas[3])
                        .offset(x: -4.adjustedW, y: -2.adjustedH)
                }
                
                VStack(spacing: 0) {
                    // 수도권
                    regionMap(regionDatas[0])
                    
                    // 충청도
                    regionMap(regionDatas[2])
                        .offset(y: -2.adjustedH)
                    
                    // 전라도
                    regionMap(regionDatas[4])
                        .offset(x: -15.35.adjustedW, y: -4.03.adjustedH)
                    
                    // 제주도
                    regionMap(regionDatas[5])
                        .offset(x: -32.adjustedW, y: 8.adjustedH)
                }
                .offset(x: -143.8.adjustedW, y: 62.adjustedH)
            }
        }
        .blur(radius: !viewModel.state.isCurrentUser && viewModel.state.user.accountScope == .privateProfile ? 6 : 0)
        .allowsHitTesting(!(!viewModel.state.isCurrentUser && viewModel.state.user.accountScope == .privateProfile))
        .overlay {
            if !viewModel.state.isCurrentUser && viewModel.state.user.accountScope == .privateProfile {
                HStack(spacing: 5) {
                    Image(.tjLock)
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("나만 보기 계정입니다")
                        .foregroundStyle(.tjBlack)
                        .font(.pretendardMedium(16))
                }
                .offset(x: -80.adjustedW, y: 70.adjustedH)
            }
        }
    }
    
    private func regionMap(_ regionData: RegionData) -> some View {
        let labelYOffset: CGFloat
        let regionWidth: CGFloat
        
        switch regionData.regionName {
        case .metropolitan:
            labelYOffset = 0
            regionWidth = 183
        case .gangwon:
            labelYOffset = 0
            regionWidth = 108
        case .chungcheong:
            labelYOffset = 0
            regionWidth = 183
        case .gyeongsang:
            labelYOffset = 15
            regionWidth = 165.09
        case .jeolla:
            labelYOffset = 0
            regionWidth = 148.3
        case .jeju:
            labelYOffset = 6
            regionWidth = 109
        }
        
        return Image(regionData.regionName.imageResourceString)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: regionWidth.adjustedW)
            .overlay {
                VStack(spacing: 6) {
                    Text("\(regionData.regionName.mapTitle)")
                        .font(.pretendardSemiBold(16))
                    HStack(spacing: 5) {
                        HStack(spacing: 2) {
                            Image(.tjJournal)
                                .frame(width: 16, height: 16)
                            Text("\(regionData.travelJournalCount)")
                                .font(.pretendardRegular(12))
                        }
                        
                        HStack(spacing: 2) {
                            Image(.tjPlace)
                                .frame(width: 16, height: 16)
                            Text("\(regionData.placesCount)")
                                .font(.pretendardRegular(12))
                        }
                    }
                    .foregroundStyle(.tjGray1)
                }
                .offset(y:labelYOffset)
            }
            .onTapGesture {
                viewModel.send(.tappedRegionButton(regionData.regionName))
                isPresentingJournalListViewForRegion.toggle()
            }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DefaultCoordinator())
}
