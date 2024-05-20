//
//  FullStoryConfig.swift
//  edX
//
//  Created by Saeed Bashir on 5/17/24.
//  Copyright © 2024 edX. All rights reserved.
//

import Foundation

fileprivate enum Keys: String, RawStringExtractable {
    case enabled = "ENABLED"
    case orgID = "ORG_ID"
}

class FullStoryConfig: NSObject {
    @objc var enabled: Bool = false
    @objc let orgID: String?
    
    init(dictionary: [String: AnyObject]) {
        enabled = dictionary[Keys.enabled] as? Bool ?? false
        orgID = dictionary[Keys.orgID] as? String ?? ""
    }
}

private let key = "FULLSTORY"
extension OEXConfig {
    @objc var fullStoryConfig: FullStoryConfig {
        return FullStoryConfig(dictionary: self[key] as? [String:AnyObject] ?? [:])
    }
}
