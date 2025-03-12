//
//  loginProvider+ViewProperty.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/23/25.
//

import SwiftUI

extension LoginProvider {
    var backgroundColor: Color {
        switch self {
        case .kakao: .kakaoYellow
        case .apple: .tjBlack
        case .google: .tjWhite
        }
    }
    
    var imageResourceString: String {
        switch self {
        case .kakao: "KakaoLogin"
        case .apple: "AppleLogin"
        case .google: "GoogleLogin"
        }
    }
    
    var title: String {
        switch self {
        case .kakao: "카카오로 로그인"
        case .apple: "Apple로 로그인"
        case .google: "Google로 로그인"
        }
    }
    
    var textColor: Color {
        switch self {
        case .kakao: .tjBlack
        case .apple: .tjWhite
        case .google: .tjBlack
        }
    }
}
