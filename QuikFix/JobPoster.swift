//
//  JobPoster.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/10/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import Foundation

class JobPoster: NSObject{
    var name: String?
    var email: String?
    var posterID: String?
    var pic: String?
    var currentListings: [String: Any]?
    var upcomingJobs: [String: Any]?
    var jobsCompleted: [String: Any]?
    var address: String?
    var responses: [String:Any]?
    var prevWorker: [String]?
    var location: [String:Any]?
    var city: String?
    var state: String?
    var paymentVerified: Bool?
    var stripeToken: String?
    var stripeCustomer: String?
    var phone: String?
    var promoCode: [String:Any]?
    var availableCredits: Int?
    var creditHours: Double?
    var creditAmount: Int?
    var deviceToken: [String: Any]?
    var expiredJobs: [String: Any]?
    var unreadMessages: Bool?
   
    var completedWaitingReview: [String: Any]?
    var studentCancelled: String?
    var twelveHoursToStart: String?
    var threeHoursToStart: String?
    var thirtyMinToStart: String?
    
    //var city: String?
    //var state: String?
}
