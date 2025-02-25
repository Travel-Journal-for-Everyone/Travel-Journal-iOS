//
//  DefaultAuthRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class DefaultAuthRepository: AuthRepository {
    func loginWithKakao() -> AnyPublisher<String, LoginError> {
        return Future<String, LoginError> { promise in
            if UserApi.isKakaoTalkLoginAvailable() {
                // 카카오톡으로 로그인
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if error != nil {
                        promise(.failure(.kakaologinFailed))
                    } else if let oauthToken {
                        promise(.success(oauthToken.accessToken))
                    }
                }
            } else {
                // 카카오 계정으로 로그인
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if error != nil {
                        promise(.failure(.kakaologinFailed))
                    } else if let oauthToken {
                        promise(.success(oauthToken.accessToken))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
