//
//  OAuthAuthenticator.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/13/25.
//

import Foundation
import Alamofire

final class OAuthAuthenticator: Authenticator {
    func apply(
        _ credential: OAuthCredential,
        to urlRequest: inout URLRequest
    ) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }
    
    func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: Error
    ) -> Bool {
        return response.statusCode == 401
    }
    
    func isRequest(
        _ urlRequest: URLRequest,
        authenticatedWith credential: OAuthCredential
    ) -> Bool {
        let bearerToken = HTTPHeader.authorization(
            bearerToken: credential.accessToken
        ).value
        
        return urlRequest.headers["Authorization"] == bearerToken
    }
    
    func refresh(
        _ credential: OAuthCredential,
        for session: Session,
        completion: @Sendable @escaping (Result<OAuthCredential, Error>) -> Void
    ) {
        guard let refreshToken = KeychainManager.load(forAccount: .refreshToken) else {
            #if DEBUG
            print("⛔️ Authenticator refresh Error: Failed to load refresh token from Keychain.")
            #endif
            return
        }
        
        let refreshTokenRequestDTO: RefreshJWTTokenRequestDTO = .init(
            refreshToken: refreshToken,
            // TODO: - DeviceID 불러오기
            deviceID: ""
        )
        let refreshTokenAPI: EndPoint = TokenAPI.refreshJWTToken(refreshTokenRequestDTO)
        
        AF.request(
            refreshTokenAPI.requestURL,
            method: refreshTokenAPI.method,
            parameters: refreshTokenAPI.bodyParameters,
            encoding: refreshTokenAPI.parameterEncoding,
            headers: refreshTokenAPI.headers
        )
        .validate()
        .response { response in
            if let httpResponse = response.response,
               let value = httpResponse.allHeaderFields["Authorization"] as? String,
               value.prefix(7) == "Bearer "
            {
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
        .responseDecodable(of: RefreshJWTTokenResponseDTO.self) { response in
            switch response.result {
            case .success(let refreshJWTTokenResponseDTO):
                guard let accessToken = KeychainManager.load(forAccount: .accessToken) else {
                    #if DEBUG
                    print("⛔️ Authenticator refresh Error: Failed to load access token from Keychain.")
                    #endif
                    return
                }
                
                KeychainManager.save(
                    forAccount: .refreshToken,
                    value: refreshJWTTokenResponseDTO.refreshToken
                )
                
                let newCredential: OAuthCredential = .init(
                    accessToken: accessToken,
                    refreshToken: refreshJWTTokenResponseDTO.refreshToken,
                    expiration: Date(timeIntervalSinceNow: 60 * 30)
                )
                
                completion(.success(newCredential))
            case .failure(let error):
                #if DEBUG
                print("⛔️ Authenticator refresh Error: Refresh token has expired. Please log in again.")
                #endif
                
                completion(.failure(error))
            }
        }
    }
}
