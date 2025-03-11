//
//  GoogleAuthService.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/7/25.
//

import Foundation
import Combine
import GoogleSignIn

protocol GoogleAuthService {
    func login() -> AnyPublisher<String?, Error>
}

final class DefaultGoogleAuthService: @preconcurrency GoogleAuthService {
    @MainActor
    func login() -> AnyPublisher<String?, Error> {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController
        else {
            fatalError("Not Found windowScene or rootViewController")
        }
        
        return Future { promise in
            GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
                guard error == nil else {
                    promise(.failure(error!))
                    return
                }
                
                if let result, let idToken = result.user.idToken {
                    promise(.success(idToken.tokenString))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
