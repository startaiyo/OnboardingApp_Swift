//
//  Date+Extras.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

import UIKit

extension Date {
    func stringFromDate() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        return formatter.string(from: self)
    }
}
