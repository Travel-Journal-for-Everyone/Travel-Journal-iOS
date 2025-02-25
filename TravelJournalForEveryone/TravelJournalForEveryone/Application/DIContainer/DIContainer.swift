//
//  DIContainer.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/25/25.
//

import Foundation

final class DIContainer {
    @MainActor static let shared = DIContainer()
    
    // Repositories
    lazy var authRepository = DefaultAuthRepository()
    
    // Usecases
    lazy var loginUsecase = DefaultLoginUseCase(authRepository: authRepository)
    
    private init() {}
}
