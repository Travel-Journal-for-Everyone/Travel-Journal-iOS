//
//  Result+isSuccess.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/17/25.
//

import Foundation

extension Result {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}
