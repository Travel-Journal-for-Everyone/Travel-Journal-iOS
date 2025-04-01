//
//  MyJournalView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct MyJournalView: View {
    private let mockUser = User.mock()
    
    var body: some View {
        ZStack {
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
                            Image("TJJournal")
                                .frame(width: 16, height: 16)
                            Text("\(regionData.travelJournalCount)")
                                .font(.pretendardRegular(12))
                        }
                        
                        HStack(spacing: 2) {
                            Image("TJPlace")
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
    MyJournalView()
}
