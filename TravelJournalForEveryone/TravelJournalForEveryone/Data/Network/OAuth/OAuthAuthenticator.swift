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
            
            completion(.failure(NSError()))
            return
        }
        
        let refreshTokenRequestDTO: RefreshJWTTokenRequestDTO = .init(
            refreshToken: refreshToken,
            // TODO: - DeviceID 불러오기
            deviceID: ""
        )
        let refreshTokenAPI: EndPoint = TokenAPI.refreshJWTToken(refreshTokenRequestDTO)
        
        AFSession.session.request(
            refreshTokenAPI.requestURL,
            method: refreshTokenAPI.method,
            parameters: refreshTokenAPI.bodyParameters,
            encoding: refreshTokenAPI.parameterEncoding,
            headers: refreshTokenAPI.headers
        )
        .validate()
        .response { response in
            guard let httpResponse = response.response,
                  let authorizationValue = httpResponse.value(forHTTPHeaderField: "Authorization"),
                  authorizationValue.hasPrefix("Bearer ")
            else {
                completion(.failure(response.error!))
                return
            }
            
            let accessToken = authorizationValue.replacingOccurrences(of: "Bearer ", with: "")
            
            #if DEBUG
            print("📌 Updated Access Token: \(accessToken)")
            #endif
            
            KeychainManager.save(
                forAccount: .accessToken,
                value: accessToken
            )
        }
        .responseDecodable(of: RefreshJWTTokenResponseDTO.self) { response in
            switch response.result {
            case .success:
                guard let accessToken = KeychainManager.load(forAccount: .accessToken),
                      let refreshToken = KeychainManager.load(forAccount: .refreshToken)
                else {
                    #if DEBUG
                    print("⛔️ Authenticator refresh Error: Failed to load access token from Keychain.")
                    #endif
                    
                    completion(.failure(NSError()))
                    return
                }
                
                let newCredential: OAuthCredential = .init(
                    accessToken: accessToken,
                    refreshToken: refreshToken
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
