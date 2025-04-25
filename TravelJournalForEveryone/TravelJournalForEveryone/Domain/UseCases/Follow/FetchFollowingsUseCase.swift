//
//  FetchFollowingsUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/23/25.
//

import Foundation
import Combine

protocol FetchFollowingsUseCase {
    func execute(
        memberID: Int?,
        pageNumber: Int
    ) -> AnyPublisher<Pageable<UserSummary>, NetworkError>
}

struct DefaultFetchFollowingsUseCase: FetchFollowingsUseCase {
    private let followRepository: FollowRepository
    
    init(followRepository: FollowRepository) {
        self.followRepository = followRepository
    }
    
    /// 로그인된 여행자 또는 다른 여행자의 Followings 목록을 가져옵니다.
    /// - Parameters:
    ///   - memberID: 특정 여행자의 정보를 가져오려면 값을 넣어주고,
    ///   nil을 입력하면 현재 로그인된 여행자 기준.
    ///   - pageNumber: 페이지 번호
    func execute(
        memberID: Int?,
        pageNumber: Int
    ) -> AnyPublisher<Pageable<UserSummary>, NetworkError> {
        return followRepository.fetchFollowings(
            memberID: resolveMemberID(from: memberID),
            pageNumber: pageNumber,
            pageSize: 10
        )
    }
    
    private func resolveMemberID(from input: Int?) -> Int {
        if let input { return input }
        return UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value)
    }
}
