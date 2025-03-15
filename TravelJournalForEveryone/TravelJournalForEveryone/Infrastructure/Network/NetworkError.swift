//
//  NetworkError.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/14/25.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case decodingFailed(Data)
    case invalidNickname(reason: String)
    case unknownError(Error)
}
