//
//  FusionTaskViewControllerExtension.swift
//  FusionWork
//
//  Created by Hartzed Story on 28/5/25.
//

import Foundation
extension FusionTaskViewController {

    func getStartOfUTCDateString() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        return utcFormatter.string(from: startOfDay)
    }

    func getEndOfUTCDateString() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!.addingTimeInterval(-0.001)
        return utcFormatter.string(from: endOfDay)
    }

    func getStartOfUTCDateString(from date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let startOfDay = calendar.startOfDay(for: date)
        return utcFormatter.string(from: startOfDay)
    }

    func getEndOfUTCDateString(from date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!.addingTimeInterval(-0.001)
        return utcFormatter.string(from: endOfDay)
    }
}
