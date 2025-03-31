//
//  Region.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/31/25.
//

import Foundation

enum Region: String {
    case metropolitan = "수도권"
    case gangwon = "강원도"
    case chungcheong = "충청도"
    case gyeongsang = "경상도"
    case jeolla = "전라도"
    case jeju = "제주도"
    
    static func from(response: String) -> Self {
        return Region(rawValue: response) ?? .metropolitan
    }
}
