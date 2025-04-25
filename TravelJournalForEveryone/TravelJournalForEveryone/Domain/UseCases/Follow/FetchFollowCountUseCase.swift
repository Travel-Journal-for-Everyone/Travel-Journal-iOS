//
//  FetchFollowCountUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/23/25.
//

import Foundation
import Combine

protocol FetchFollowCountUseCase {
    func execute(memberID: Int?) -> AnyPublisher<FollowCountInfo, NetworkError>
}

struct DefaultFetchFollowCountUseCase: FetchFollowCountUseCase {
    private let followRepository: FollowRepository
    
    init(followRepository: FollowRepository) {
        self.followRepository = followRepository
    }
    
    /// 로그인된 여행자 또는 다른 여행자의 팔로워 Count를 가져옵니다.
    /// - Parameters:
    ///   - memberID: 특정 여행자의 정보를 가져오려면 값을 넣어주고,
    ///   nil을 입력하면 현재 로그인된 여행자 기준.
    func execute(memberID: Int?) -> AnyPublisher<FollowCountInfo, NetworkError> {
        return followRepository.fetchFollowCount(
            memberID: resolveMemberID(from: memberID)
        )
    }
    
    private func resolveMemberID(from input: Int?) -> Int {
        if let input { return input }
        return UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value)
    }
}
