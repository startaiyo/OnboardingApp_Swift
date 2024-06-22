//
//  String+Extras.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

import Foundation

extension String {
    func dateFromString() throws -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        if let date = formatter.date(from: self) {
            return date
        } else { throw ErrorsModel(type: .general)}
    }
}
