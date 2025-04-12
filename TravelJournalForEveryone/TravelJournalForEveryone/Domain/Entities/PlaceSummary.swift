//
//  PlaceSummary.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/8/25.
//

import Foundation

struct PlaceSummary: Identifiable {
    let id: Int
    let imageURLString: String
    let name: String
    let address: String
}

extension PlaceSummary {
    static func mock(id: Int, placeName: String) -> Self {
        return .init(
            id: id,
            imageURLString: "https://fastly.picsum.photos/id/584/200/300.jpg?hmac=sBfls3kxMp0j0qH3R-K2qM8Wyak1FlpOIgtcd7cEg68",
            name: placeName,
            address: "부산 해운대구"
        )
    }
}
