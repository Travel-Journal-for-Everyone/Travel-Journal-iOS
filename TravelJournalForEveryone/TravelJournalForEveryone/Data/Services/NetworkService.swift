//
//  NetworkService.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/4/25.
//

import Foundation
import Combine
import Alamofire

enum NetworkError: Error {
    case networkError(Error)
}

protocol NetworkService {
    func request<T: Decodable & Sendable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) -> AnyPublisher<T, NetworkError>
}

final class DefaultNetworkService: NetworkService {
    func request<T: Decodable & Sendable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        var interceptor: RequestInterceptor?
        
        if endPoint.requiresAuth {
            let credential = OAuthCredential(
                accessToken: KeychainManager.load(forAccount: .accessToken) ?? "",
                refreshToken: KeychainManager.load(forAccount: .refreshToken) ?? "",
                expiration: Date(timeIntervalSinceNow: 60 * 30)
            )
            let authenticator = OAuthAuthenticator()
            
            interceptor = AuthenticationInterceptor(
                authenticator: authenticator,
                credential: credential
            )
        }
        
        return AFSession.session.request(
            endPoint.requestURL,
            method: endPoint.method,
            parameters: endPoint.bodyParameters,
            encoding: endPoint.parameterEncoding,
            headers: endPoint.headers,
            interceptor: interceptor
        )
        .validate()
        .publishDecodable(type: T.self)
        .tryMap { dataResponse in
            if let httpResponse = dataResponse.response {
                self.extractAccessToken(from: httpResponse)
            }
            
            switch dataResponse.result {
            case .success(let value): return value
            case .failure(let error): throw error
            }
        }
        .mapError { .networkError($0) }
        .eraseToAnyPublisher()
    }
    
    private func extractAccessToken(from response: HTTPURLResponse) {
        if let value = response.allHeaderFields["Authorization"] as? String {
            if value.prefix(7) == "Bearer " {
                let accessToken = String(value.split(separator: " ").last!)
                
                #if DEBUG
                print("📌 accessToken: \(accessToken)")
                #endif
                
                KeychainManager.save(
                    forAccount: .accessToken,
                    value: accessToken
                )
            }
        }
    }
}
