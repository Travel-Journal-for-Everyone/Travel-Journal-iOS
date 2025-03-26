//
//  SocialLoginAuthService.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/12/25.
//

import Foundation
import Combine
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import GoogleSignIn

protocol SocialLoginAuthService {
    @MainActor func loginWith(_ loginProvider: SocialType) -> AnyPublisher<String, Error>
}

enum SocialLoginError: Error {
    case kakaoIDTokenNotFound
    case googleIDTokenNotFound
    case appleIDTokenNotFound
    case appleIDTokenEncodingFailed
}

final class DefaultSocialLoginAuthService: NSObject, SocialLoginAuthService {
    private var subject = PassthroughSubject<String, Error>()
    
    @MainActor
    func loginWith(_ loginProvider: SocialType) -> AnyPublisher<String, Error> {
        switch loginProvider {
        case .kakao:
            return loginWithKakao()
        case .apple:
            return loginWithApple()
        case .google:
            return loginWithGoogle()
        }
    }
    
    private func loginWithKakao() -> AnyPublisher<String, Error> {
        return Future { promise in
            if UserApi.isKakaoTalkLoginAvailable() {
                // 카카오톡으로 로그인
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    guard error == nil else {
                        promise(.failure(error!))
                        return
                    }
                    
                    guard let idToken = oauthToken?.idToken else {
                        promise(.failure(SocialLoginError.kakaoIDTokenNotFound))
                        return
                    }
                    
                    promise(.success(idToken))
                }
            } else {
                // 카카오 계정으로 로그인
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    guard error == nil else {
                        promise(.failure(error!))
                        return
                    }
                    
                    guard let idToken = oauthToken?.idToken else {
                        promise(.failure(SocialLoginError.kakaoIDTokenNotFound))
                        return
                    }
                    
                    promise(.success(idToken))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func loginWithApple() -> AnyPublisher<String, Error> {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
        return subject.eraseToAnyPublisher()
    }
    
    @MainActor
    private func loginWithGoogle() -> AnyPublisher<String, Error> {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController
        else {
            fatalError("⛔️ Not Found windowScene or rootViewController")
        }
        
        return Future { promise in
            GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
                guard error == nil else {
                    promise(.failure(error!))
                    return
                }
                
                guard let idToken = result?.user.idToken else {
                    promise(.failure(SocialLoginError.googleIDTokenNotFound))
                    return
                }
                
                promise(.success(idToken.tokenString))
            }
        }
        .eraseToAnyPublisher()
    }
}

extension DefaultSocialLoginAuthService: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            fatalError("⛔️ No window found")
        }
        return window
    }
    
    // apple id 연동 성공 시
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        guard let idTokenData = appleIDCredential.identityToken else {
            subject.send(completion: .failure(SocialLoginError.appleIDTokenNotFound))
            return
        }
        
        guard let idToken = String(data: idTokenData, encoding: .utf8) else {
            subject.send(completion: .failure(SocialLoginError.appleIDTokenEncodingFailed))
            return
        }
        
        #if DEBUG
        print("✅ Apple ID Token: \(idToken)")
        #endif
        
        subject.send(idToken)
    }
    
    // apple id 연동 실패 시
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("⛔️ Apple Login Failed: \(error)")
        subject.send(completion: .failure(error))
    }
}
