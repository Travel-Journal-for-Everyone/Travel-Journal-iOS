//
//  ExploreView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/2/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel: ExploreViewModel
    
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            CustomSegmentedControl(
                options: ["여행 일지", "플레이스"],
                selectedIndex: Binding(
                    get: { viewModel.state.selectedSegmentIndex },
                    set: { newIndex in
                        withAnimation {
                            viewModel.send(.selectSegment(newIndex))
                        }
                    }
                ),
                namespace: namespace
            )
            .padding(.horizontal, 16)
            .padding(.top, 15)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 32) {
                    
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: Binding(
                get: { viewModel.state.selectedSegmentIndex },
                set: { viewModel.send(.selectSegment($0 ?? 0)) }
            ))
        }
        .customNavigationBar {
            Text("탐험하기")
                .font(.pretendardMedium(16))
                .foregroundStyle(.tjBlack)
        }
    }
}

#Preview {
    ExploreView(viewModel: .init())
}
