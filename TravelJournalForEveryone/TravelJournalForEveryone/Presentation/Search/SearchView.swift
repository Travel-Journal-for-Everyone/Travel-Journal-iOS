//
//  SearchView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/2/25.
//

import SwiftUI
// 탭 키자마자 키보드 올리기
// UD에 검색어 저장하기

struct SearchView: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    
    private let userInfoManager = DIContainer.shared.userInfoManager
    @State private var searchText: String = ""
    @State private var searchTextList: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            searchBar(searchText)
            recentSearchHeader
            
            if searchTextList.isEmpty {
                emptyView
            } else {
                recentSearchContent
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

extension SearchView {
    private func searchBar(_ text: String) -> some View {
        let placeholder: String = "궁금한 여행지를 검색해보세요!"
        
        return HStack {
            TextField("", text: $searchText)
                .font(.pretendardRegular(16))
                .placeholder(when: text.isEmpty) {
                    Text(placeholder)
                        .font(.pretendardRegular(16))
                        .foregroundStyle(.tjGray3)
                }
            
            Spacer()
            
            Image(text.isEmpty ? .tjSearch : .tjClose)
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    searchText = ""
                }
        }
        .padding(.horizontal, 20)
        .frame(height: 44.adjustedH)
        .background(.tjGray6, in: RoundedRectangle(cornerRadius: 4))
        .padding(.top, 20)
    }
    
    private var recentSearchHeader: some View {
        HStack{
            Text("최근 검색어")
                .font(.pretendardSemiBold(16))
            Spacer()
            Text("전체 삭제")
                .font(.pretendardRegular(16))
                .foregroundStyle(.tjGray2)
        }
        .padding(.top, 20)
    }
    
    private var recentSearchContent: some View {
        VStack(spacing: 0) {
            ForEach(searchTextList, id: \.self) { text in
                recentSearchCell(text)
            }
        }
        .padding(.horizontal, 10)
    }
    
    private var emptyView: some View {
        VStack(alignment: .leading) {
            Text("최근 검색어가 없습니다.")
                .font(.pretendardRegular(16))
                .foregroundStyle(.tjGray2)
            Spacer()
        }
        .padding(.top, 30)
    }
    
    private func recentSearchCell(_ text: String) -> some View {
        HStack {
            Text(text)
                .font(.pretendardRegular(16))
            Spacer()
            Image(.tjClose)
                .resizable()
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 10)
        .frame(height: 50.adjustedH)
    }
}

#Preview {
    SearchView()
}
