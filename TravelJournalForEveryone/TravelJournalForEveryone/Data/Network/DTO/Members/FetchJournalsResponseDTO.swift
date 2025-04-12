//
//  FetchJournalsResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/12/25.
//

import Foundation

struct FetchJournalsResponseDTO: Decodable {
    let content: [JournalSummaryDTO]
    let pageable: Pageable
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int
    // MARK: 임시로 [String] 타입 사용
    let sort: [String]
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
}

extension FetchJournalsResponseDTO {
    struct JournalSummaryDTO: Decodable {
        let journalID: Int
        let hashtag: [String]
        let title: String
        let nights: Int
        let days: Int
        let startDate: String
        let endDate: String
        
        private enum CodingKeys: String, CodingKey {
            case journalID = "journalId"
            case hashtag = "hashTag"
            case title, nights, days, startDate, endDate
        }
    }
}

extension FetchJournalsResponseDTO {
    func toEntity() -> JournalsPage {
        return .init(
            totalJournals: totalElements,
            isLast: last,
            pageNumber: number,
            isEmpty: empty,
            journalSummaries: content.map { $0.toEntity() }
        )
    }
}

extension FetchJournalsResponseDTO.JournalSummaryDTO {
    func toEntity() -> JournalSummary {
        return .init(
            id: journalID,
            hashtag: hashtag,
            title: title,
            nights: nights,
            days: days,
            startDateString: startDate,
            endDateString: endDate
        )
    }
}

// TODO: - 나중에 다른 Pagination API를 확인하고 다른 파일로 분리할지 확인하기
struct Pageable: Decodable {
    let pageNumber: Int
    let pageSize: Int
    // MARK: 임시로 [String] 타입 사용
    let sort: [String]
    let offset: Int
    let paged: Bool
    let unpaged: Bool
}
