//
//  ExploreViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/1/25.
//

import Foundation
import Combine

final class ExploreViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    func send(_ intent: Intent) {
        switch intent {
        case .selectSegment(let index):
            self.state.selectedSegmentIndex = index
        }
    }
}

extension ExploreViewModel {
    struct State {
        var selectedSegmentIndex: Int = 0
    }
    
    enum Intent {
        case selectSegment(Int)
    }
}
