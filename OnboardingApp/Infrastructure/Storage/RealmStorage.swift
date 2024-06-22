//
//  RealmStorage.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/01.
//

import RealmSwift

struct RealmConstants {
    static let lastDBVersion: UInt64 = 2
}

struct DBChanges {
    static let version1 = 2
}

final class RealmStorage {
    // MARK: Properties
    private var realm: Realm {
        guard let realm = try? Realm(configuration: RealmStorage.config()) else {
            fatalError("Could not create Realm")
        }
        realm.refresh()
        return realm
    }
}

extension RealmStorage {
    static func config() -> Realm.Configuration {
        var config = Realm.Configuration()
        config.schemaVersion = RealmConstants.lastDBVersion
        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < RealmConstants.lastDBVersion {
                if oldSchemaVersion < DBChanges.version1 {
                    migration.enumerateObjects(ofType: MessageObject.className()) { _, newObject in
                        newObject?["userID"] = ""
                    }
                }
            }
        }
        return config
    }
}
