//
//  FetchPlacesUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/15/25.
//

import Foundation
import Combine

protocol FetchPlacesUseCase {
    func execute(
        memberID: Int?,
        regionName: String?,
        pageNumber: Int
    ) -> AnyPublisher<Pageable<PlaceSummary>, NetworkError>
}

struct DefaultFetchPlacesUseCase: FetchPlacesUseCase {
    private let placeRepository: PlaceRepository
    
    init(placeRepository: PlaceRepository) {
        self.placeRepository = placeRepository
    }
    
    /// 로그인된 여행자 또는 다른 여행자의 Place 목록을 가져옵니다.
    /// - Parameters:
    ///   - memberID: 특정 여행자의 정보를 가져오려면 값을 넣어주고,
    ///   nil을 입력하면 현재 로그인된 여행자 기준.
    ///   - regionName: 특정 지역의 정보를 가져오려면 값을 넣어주고,
    ///   nil을 입력하면 전 지역의 정보를 가져옵니다.
    ///   - pageNumber: 페이지 번호
    func execute(
        memberID: Int?,
        regionName: String?,
        pageNumber: Int
    ) -> AnyPublisher<Pageable<PlaceSummary>, NetworkError> {
        return placeRepository.fetchPlaces(
            memberID: resolveMemberID(from: memberID),
            regionName: regionName,
            pageNumber: pageNumber,
            pageSize: 10
        )
    }
    
    private func resolveMemberID(from input: Int?) -> Int {
        if let input { return input }
        return UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value)
    }
}
