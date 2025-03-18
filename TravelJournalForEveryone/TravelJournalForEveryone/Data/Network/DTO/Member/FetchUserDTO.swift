//
//  FetchUserDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/18/25.
//

import Foundation

struct FetchUserDTO: Decodable {
    // TODO: 백엔드 API 작업 완료 후 전체적으로 맞는지 확인하기!!!
    let nickname: String
    let accountScope: String
}

extension FetchUserDTO {
    func toEntity() -> User {
        return User(
            nickname: nickname,
            accountScope: AccountScope.from(response: accountScope)
        )
    }
}
