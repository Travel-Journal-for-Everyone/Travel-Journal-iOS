//
//  SocialLogoutService.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/17/25.
//

import Foundation
import Combine
import KakaoSDKUser
import GoogleSignIn

protocol SocialLogoutService {
    func logoutWith(_ logoutProvider: SocialType) -> AnyPublisher<Bool, Error>
}

struct DefaultSocialLogoutService: SocialLogoutService {
    
    func logoutWith(_ logoutProvider: SocialType) -> AnyPublisher<Bool, Error> {
        switch logoutProvider {
        case .kakao:
            return logoutWithKakao()
        case .apple:
            return logoutWithApple()
        case .google:
            return logoutWithGoogle()
        }
    }
    
    private func logoutWithKakao() -> AnyPublisher<Bool, Error> {
        return Future { promise in
            UserApi.shared.logout { error in
                if let error = error {
                    print("⛔️ Kakao Logout Failed: \(error)")
                } else {
                    print("✅ Kakao Logout Success")
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func logoutWithApple() -> AnyPublisher<Bool, Error> {
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func logoutWithGoogle() -> AnyPublisher<Bool, Error> {
        return Future { promise in
            GIDSignIn.sharedInstance.signOut()
        }
        .eraseToAnyPublisher()
    }
}

