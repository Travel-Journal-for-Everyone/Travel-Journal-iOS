//
//  ProfileInfoRequestDTO.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/14/25.
//

import Foundation

struct ProfileInfoRequestDTO {
    var nickname: String
    var accountScope: AccountScope
    var imageData: Data?
}
