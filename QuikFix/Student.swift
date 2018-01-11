//
//  Student.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/10/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import Foundation

class Student: NSObject {
    var name: String?
    var studentID: String?
    var email: String?
    
    var bio: String?
    var pic: String?
    var school: String?
    var major: String?
    var gradYear: String?
    
    var jobsCompleted: [String]?
    var completedWaitingReview: [String]?
    var upcomingJobs: [String]?
    var nearbyJobs: [String]?
    
    var experience: [String]?
    var rating: Double?
    var totalEarned: Int?
    
    var city: String?
    var location: [String:Any]? // lat and long
    
    var tShirtSize: String?
    var phone: String?
    var deviceToken: [String:Any]? // for push
    
    var promoCode: [String:Any]?
    var availableCredits: Int?
    var creditHours: Double?
    var unreadMessages: Bool?
    var posterCancelled: String?
    var completedCount: Int?
    var twelveHoursToStart: String?
    var threeHoursToStart: String?
    var thirtyMinToStart: String?
    //var directMessages: [String:Any]?
    
}
