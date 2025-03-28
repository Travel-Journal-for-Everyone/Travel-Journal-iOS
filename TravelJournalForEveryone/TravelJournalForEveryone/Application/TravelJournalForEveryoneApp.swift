//
//  TravelJournalForEveryoneApp.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn

@main
struct TravelJournalForEveryoneApp: App {
    var body: some Scene {
        WindowGroup {
            AuthenticationView(
                viewModel: .init(
                loginUseCase: DIContainer.shared.loginUseCase,
                logoutUseCase: DIContainer.shared.logoutUseCase,
                authStateCheckUseCase: DIContainer.shared.authStateCheckUseCase,
                unlinkUseCase: DIContainer.shared.unlinkUseCase
            ))
            .onOpenURL { url in
                // 카카오톡에서 앱으로 돌아올 때 쓰일 URL 핸들러
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
                
                // 구글 브라우저에서 앱으로 돌아올 때 쓰일 URL 핸들러
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
    
    init() {
        // kakao SDK 초기화
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoNativeAppKey)
    }
}
