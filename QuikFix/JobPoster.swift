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
    var currentListings: [String]?
    var upcomingJobs: [String]?
    var jobsCompleted: [String]?
    var address: String?
    var responses: [String:Any]?
    var prevWorker: [String]?
    var location: [String:Any]?
    var city: String?
    var paymentVerified: Bool?
    var stripeToken: String?
    var stripeCustomer: String?
    var phone: String?
    var promoCode: [String:Any]?
    var availableCredits: Int?
    var creditAmount: Int?
    var deviceToken: [String: Any]?
    
    //var city: String?
    //var state: String?
}
