//
//  Realm+SafeWrite.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/01.
//

import RealmSwift

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
