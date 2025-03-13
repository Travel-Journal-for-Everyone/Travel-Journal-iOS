//
//  API.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/13/25.
//

import Alamofire
import Foundation

final class AFSession {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let logger = NetworkEventMonitor()
        return Session(configuration: configuration, eventMonitors: [logger])
    }()
}
