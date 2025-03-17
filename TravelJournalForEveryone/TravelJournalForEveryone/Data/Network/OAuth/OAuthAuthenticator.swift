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
        do {
            let refreshToken = try KeychainManager.load(forAccount: .refreshToken).get()
            
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
                    do {
                        let accessToken = try KeychainManager.load(forAccount: .accessToken).get()
                        let newCredential = OAuthCredential(
                            accessToken: accessToken,
                            refreshToken: refreshToken
                        )
                        
                        completion(.success(newCredential))
                    } catch {
                        #if DEBUG
                        print("⛔️ Authenticator refresh Error: Failed to load access token from Keychain.")
                        #endif
                        
                        completion(.failure(error))
                    }
                case .failure(let error):
                    #if DEBUG
                    print("⛔️ Authenticator refresh Error: Refresh token has expired. Please log in again.")
                    #endif
                    
                    Task { @MainActor in
                        DIContainer.shared.authStateManager.unauthenticate()
                    }
                    
                    completion(.failure(error))
                }
            }
        } catch {
            #if DEBUG
            print("⛔️ Authenticator refresh Error: Failed to load refresh token from Keychain.")
            #endif
            
            completion(.failure(error))
        }
    }
}
