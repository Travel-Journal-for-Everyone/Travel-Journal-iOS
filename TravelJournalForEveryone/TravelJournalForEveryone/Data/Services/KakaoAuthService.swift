//
//  KakaoAuthService.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/27/25.
//

import Foundation
import Combine
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

protocol KakaoAuthService {
    func login() -> AnyPublisher<String?, Error>
}

final class DefaultKakaoAuthService: KakaoAuthService {
    func login() -> AnyPublisher<String?, Error> {
        return Future { promise in
            if UserApi.isKakaoTalkLoginAvailable() {
                // 카카오톡으로 로그인
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error {
                        promise(.failure(error))
                    } else if let oauthToken {
                        promise(.success(oauthToken.idToken))
                    }
                }
            } else {
                // 카카오 계정으로 로그인
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error {
                        promise(.failure(error))
                    } else if let oauthToken {
                        promise(.success(oauthToken.idToken))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
