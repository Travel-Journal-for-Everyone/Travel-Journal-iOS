//
//  Numeric+adjust.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/4/25.
//

import UIKit

extension CGFloat {
    @MainActor
    var adjustedW: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        return self * ratio
    }
    
    @MainActor
    var adjustedH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 812
        return self * ratio
    }
}

extension Double {
    @MainActor
    var adjustedW: Double {
        let ratio: Double = Double(UIScreen.main.bounds.width / 375)
        return self * ratio
    }
    
    @MainActor
    var adjustedH: Double {
        let ratio: Double = Double(UIScreen.main.bounds.height / 812)
        return self * ratio
    }
}

extension Int {
    @MainActor
    var adjustedW: CGFloat {
        return CGFloat(self).adjustedW
    }
    
    @MainActor
    var adjustedH: CGFloat {
        return CGFloat(self).adjustedH
    }
}
