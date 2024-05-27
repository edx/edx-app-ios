//
//  FullStoryAnalyticsTracker.swift
//  edX
//
//  Created by Saeed Bashir on 5/9/24.
//  Copyright © 2024 edX. All rights reserved.
//

import Foundation
import FullStory

class FullStoryAnalyticsTracker: NSObject, OEXAnalyticsTracker {
    
    var currentOrientationValue : String {
        return UIApplication.shared.interfaceOrientation.isLandscape ? OEXAnalyticsValueOrientationLandscape : OEXAnalyticsValueOrientationPortrait
    }
    
    func identifyUser(_ user: OEXUserDetails?) {
        guard let userID = user?.userId?.stringValue, let email = user?.email, let username = user?.username else { return }
        let traits: [String: String] = [
            "email": email,
            "username": username,
            "displayName": userID
        ]
        
        FS.identify(userID, userVars: traits)
    }
    
    func clearIdentifiedUser() {
        
    }
    
    func trackEvent(_ event: OEXAnalyticsEvent, forComponent component: String?, withProperties properties: [String : Any]) {
        var parameters: [String: Any] = [key_app_name: value_app_name]
        parameters[OEXAnalyticsKeyOrientation] =  currentOrientationValue
        
        if properties.count > 0 {
            parameters = parameters.concat(dictionary: properties)
        }
        
        if let component = component {
            parameters[key_component] = component
        }
        
        if let courseID = event.courseID {
            parameters[key_course_id] = courseID
        }
        
        parameters[key_name] =  event.name
        parameters[AnalyticsEventDataKey.Category.rawValue] = event.category
        
        FS.event(event.displayName, properties: parameters)
    }
    
    func trackScreen(withName screenName: String, courseID: String?, additionalInfo info: [String: String]?) {
        var parameters = info ?? [:]
        
        if let courseID  = courseID {
            parameters[key_course_id] = courseID
        }
        
        FS.page(withName: screenName, properties: parameters).start()
    }
}
