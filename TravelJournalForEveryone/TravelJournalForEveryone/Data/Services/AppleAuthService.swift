//
//  AppleAuthService.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/4/25.
//

import Foundation
import AuthenticationServices
import Combine

protocol AppleAuthService {
    func login() -> AnyPublisher<String?, Error>
}

final class DefaultAppleAuthService: NSObject, AppleAuthService {
    private var subject = PassthroughSubject<String?, Error>()
    
    func login() -> AnyPublisher<String?, Error> {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
        return subject.eraseToAnyPublisher()
    }
}

extension DefaultAppleAuthService: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    // apple 로그인 UI를 어느 뷰에 표시할지 지정
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            fatalError("No window found")
        }
        return window
    }
    
    // apple id 연동 성공 시
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

        let name = appleIDCredential.fullName
        let code = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
        let token = String(data: appleIDCredential.identityToken!, encoding: .utf8)
        
        #if DEBUG
        print("token \(String(describing: token))")
        print("code \(String(describing: code))")
        #endif
        
        subject.send(token)
        
        // 서버로 토큰 전달
    }
    
    // apple id 연동 실패 시
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("Apple Login Failed \(error)")
        subject.send(completion: .failure(error))
    }
}
