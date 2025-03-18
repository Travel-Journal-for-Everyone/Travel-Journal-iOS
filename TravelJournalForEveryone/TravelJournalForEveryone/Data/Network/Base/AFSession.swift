//
//  AFSession.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/18/25.
//

import Foundation
import Alamofire

final class AFSession {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let logger = NetworkEventMonitor()
        return Session(configuration: configuration, eventMonitors: [logger])
    }()
}
