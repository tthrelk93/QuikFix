//
//  File.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/8/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import Foundation

class JobPost: NSObject {
    
    var category1: String?
    var payment: String?
    var date: [String]?
    var startTime: [String]?
    var jobDuration: String?
    var additInfo: String?
    var posterName: String?
    var jobID: String?
    var posterID: String?
    var workerCount: Any?
    var acceptedCount: Any?
    var location: String?
    var jobLat: String?
    var jobLong: String?
    var completed: Any?
    var workers: [String]?
    var messages: [String:Any]?
    var payments: [[String:Any]]?
    var pickupLocation: String?
    var dropOffLocation: String?
    var tools: [String]?
    var inProgress: Bool?
    //the following three fields are Bools that are created and immedietly destroyed
    //12 hours, three hours, and thirty min before job is to start so that I push notification will be sent to the students and poster reminding them
    
    
    
    
    
    //var responses: [String]?
    
    
    
}
