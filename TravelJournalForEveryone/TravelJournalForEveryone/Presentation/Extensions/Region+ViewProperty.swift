//
//  Region+ViewProperty.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/1/25.
//

import Foundation

extension Region {
    var imageResourceString: String {
        switch self {
        case .metropolitan: "metropolitan"
        case .gangwon: "gangwon"
        case .chungcheong: "chungcheong"
        case .gyeongsang: "gyeongsang"
        case .jeolla: "jeolla"
        case .jeju: "jeju"
        }
    }
    
    var mapTitle: String {
        switch self {
        case .metropolitan: "서울 · 경기 · 인천"
        case .gangwon: "강원도"
        case .chungcheong: "충청도"
        case .gyeongsang: "경상도"
        case .jeolla: "전라도"
        case .jeju: "제주도"
        }
    }
}
