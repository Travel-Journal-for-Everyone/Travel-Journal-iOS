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

@main
struct TravelJournalForEveryoneApp: App {
    init() {
        // kakao SDK 초기화
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView(viewModel: .init(
                loginUsecase: DIContainer.shared.loginUsecase)
            )
            // 카카오톡에서 앱으로 돌아올 때 쓰일 URL 핸들러
            .onOpenURL { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
    }
}
