//
//  NicknameRegexResult.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/28/25.
//

import Foundation

enum NicknameRegexCheckResult {
    case valid
    case initial
    case empty
    case tooShort
    case containsWhitespace
    case invalidCharacters
}
