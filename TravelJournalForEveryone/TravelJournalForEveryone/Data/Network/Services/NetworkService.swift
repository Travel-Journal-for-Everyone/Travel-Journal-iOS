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

final class AFSession {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let logger = NetworkEventMonitor()
        return Session(configuration: configuration, eventMonitors: [logger])
    }()
}

final class DefaultNetworkService: NetworkService {
    private let interceptor: RequestInterceptor?
    
    init() {
        let credential = OAuthCredential(
            accessToken: KeychainManager.load(forAccount: .accessToken) ?? "",
            refreshToken: KeychainManager.load(forAccount: .refreshToken) ?? ""
        )
        let authenticator = OAuthAuthenticator()
        
        self.interceptor = AuthenticationInterceptor(
            authenticator: authenticator,
            credential: credential
        )
    }
    
    func request<T: Decodable & Sendable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        return AFSession.session.request(
            endPoint.requestURL,
            method: endPoint.method,
            parameters: endPoint.bodyParameters,
            encoding: endPoint.parameterEncoding,
            headers: endPoint.headers,
            interceptor: endPoint.requiresAuth ? interceptor : nil
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
        guard let authorizationValue = response.value(forHTTPHeaderField: "Authorization"),
              authorizationValue.hasPrefix("Bearer ")
        else { return }
        
        let accessToken = authorizationValue.replacingOccurrences(of: "Bearer ", with: "")
        
        #if DEBUG
        print("📌 Updated Access Token: \(accessToken)")
        #endif
        
        KeychainManager.save(
            forAccount: .accessToken,
            value: accessToken
        )
    }
}
