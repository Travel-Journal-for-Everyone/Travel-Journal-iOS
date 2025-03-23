//
//  LoginProvider.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/23/25.
//

import Foundation

enum SocialType: String {
    case kakao
    case apple
    case google
    
    static func from(response: String) -> Self {
        return SocialType(rawValue: response) ?? .kakao
    }
}
