//
//  OAuthCredential.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/13/25.
//

import Foundation
import Alamofire

struct OAuthCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String
    let expiration: Date
    
    var requiresRefresh: Bool {
        Date(timeIntervalSinceNow: 60 * 30) > expiration
    }
}
