//
//  MyJournalView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct MyJournalView: View {
    @EnvironmentObject private var coordinator: DefaultCoordinator
    
    // TEST
    private let mockUser = User.mock()
    private var isCurrentUser = true
    @State private var isPresentingMenu = false
    @State private var isFollowing = false
    
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
            
            journalMap(regionDatas: mockUser.regionDatas)
                .offset(y: 110)
            
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
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    journalCreateButton
                        .padding(.trailing, 31)
                        .padding(.bottom, 50)
                }
            }
        }
    }
    
    private var userInfoView: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 10) {
                HStack(spacing: 0) {
                    if !isCurrentUser {
                        Button {
                            print("뒤로 가기")
                        } label: {
                            Image(.tjLeftArrow)
                        }
                        .padding(.trailing, 5)
                    }
                    
                    Text("마루김마루")
                        .font(.pretendardBold(20))
                        .padding(.trailing, 5)
                    
                    Image(.tjGlobe)
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Spacer()
                    
                    if isCurrentUser {
                        Button {
                            print("알림 목록")
                        } label: {
                            Image(.tjBell)
                        }
                    } else {
                        FollowButton(isFollowing: $isFollowing) {
                            isFollowing.toggle()
                        }
                        
                        Button {
                            print("메뉴")
                            withAnimation(.smooth(duration: 0.25)) {
                                isPresentingMenu.toggle()
                            }
                        } label: {
                            Image(.tjMenu)
                                .renderingMode(.template)
                                .foregroundStyle(isPresentingMenu ? .tjGray3 : .tjBlack)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(height: 30)
                
                HStack(spacing: 0) {
                    ProfileImageView(viewType: .home, image: nil)
                        .padding(.trailing, 16)
                        .onTapGesture {
                            coordinator.push(.followList)
                        }
                    
                    Spacer()
                    
                    ActivityOverview(
                        user: mockUser,
                        isCurrentUser: isCurrentUser
                    ) {
                        print("일지 리스트")
                    } placeAction: {
                        print("플레이스 리스트")
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
                    withAnimation(.smooth(duration: 0.25)) {
                        isPresentingMenu.toggle()
                    }
                    
                    // TODO: - 차단하기
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
                    withAnimation(.smooth(duration: 0.25)) {
                        isPresentingMenu.toggle()
                    }
                    
                    // TODO: - 신고하기
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
            .offset(y: 28)
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
                        .offset(x: -4, y: -2)
                }
                .offset(x: 78, y: 0)
                
                VStack(spacing: 0) {
                    // 수도권
                    regionMap(regionDatas[0])
                    
                    // 충청도
                    regionMap(regionDatas[2])
                        .offset(x: 0, y: -2)
                    
                    // 전라도
                    regionMap(regionDatas[4])
                        .offset(x: -15.8, y: -4)
                    
                    // 제주도
                    regionMap(regionDatas[5])
                        .offset(x: -32, y: 8)
                }
                .offset(x: -67, y: 62)
            }
        }
    }
    
    private func regionMap(_ regionData: RegionData) -> some View {
        let labelYOffset: CGFloat
        
        switch regionData.regionName {
        case .metropolitan, .gangwon, .chungcheong, .jeolla:
            labelYOffset = 0
        case .gyeongsang:
            labelYOffset = 15
        case .jeju:
            labelYOffset = 6
        }
        
        return Image(regionData.regionName.imageResourceString)
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
                .offset(x: 0, y:labelYOffset)
            }
            .onTapGesture {
                print("\(regionData.regionName.mapTitle)")
            }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DefaultCoordinator())
//    MyJournalView()
//        .environmentObject(DefaultCoordinator())
}
