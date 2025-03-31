//
//  Region+ImageResourceString.swift
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
}
