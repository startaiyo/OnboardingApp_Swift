//
//  Hashable+Extras.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/08.
//

extension Hashable where Self: AnyObject {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Self,
                    rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
