//
//  FetchUserResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/27/25.
//

import Foundation

struct FetchUserResponseDTO: Decodable {
    let profileInfo: ProfileInfoDTO
    let regionDatas: [RegionDataDTO]
}

extension FetchUserResponseDTO {
    func toEntity() -> User {
        return User(
            nickname: profileInfo.nickname,
            profileImageURLString: profileInfo.profileImageURL,
            accountScope: AccountScope.from(response: profileInfo.accountScope),
            followingCount: profileInfo.followingCount,
            followerCount: profileInfo.followerCount,
            travelJournalCount: profileInfo.travelJournalCount,
            placesCount: profileInfo.placesCount,
            isFirstLogin: profileInfo.isFirstLogin,
            regionDatas: regionDatas.map { $0.toEntity() }
        )
    }
}
