//
//  UserDefaultsKey.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/17/25.
//

import Foundation

enum UserDefaultsError: Error {
    case dataNotFound
}

enum UserDefaultsKey {
    case deviceID
    case memberID
    case socialType
    case recentSearches
    
    var value: String { "\(self)" }
}
