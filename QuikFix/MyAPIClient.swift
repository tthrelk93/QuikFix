//
//  BackendAPIAdapter.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import FirebaseDatabase
import FirebaseAuth



enum SerializationError: Error {
    case missing(String)
}
struct cusID {
    var customer_id: String
    
    init(json: [String: Any]) throws {
        guard let customer_id = json["customer_id"] as? String else {
            throw SerializationError.missing("customer_id")
        }
        self.customer_id = customer_id
    }
}
protocol DataDelegate {
    
    
    func getID(id: String)
    
}

class MyAPIClient: NSObject, STPEphemeralKeyProvider {
    
    

    static let sharedClient = MyAPIClient()
    var delegate: DataDelegate?
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    // Takes in the HTTP response data and returns a DogPark Array
   
    var returnID = String()
    func callSaveCard(stripeToken: STPToken, email: String, name: String, completionHandler: @escaping (String?, Error?) -> ()){
        saveCard(stripeToken, email: email, name: name, completionHandler: completionHandler)
    }
    func saveCard(_ stripeToken: STPToken, email: String, name: String, completionHandler: @escaping (String?, Error?) -> ()) {
        //var custIDs: [cusID] = []
        print("saveCArd")
        let url = self.baseURL.appendingPathComponent("user")
        let params: [String: Any] = [
            "stripeToken": stripeToken,
            "name": name,
            "email": email
        ]
        //params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString() { resData in
            //.responseString { response in
                //var custID = response
                //print("response: \(response)")
                print(resData.result.value!)
                self.returnID = resData.result.value!
                completionHandler(self.returnID, nil)
              
        }
    }
    var stripeToken = String()
    //var job = [String:Any]()
   // var poster = String()
    var removeAcceptedCount = Int()
    var creditHours = Int()
    
    func completeCharge(amount: Int,
                        poster: String, job: [String:Any], senderScreen: String) {
        
        print("senderScreen: \(senderScreen)")
        if senderScreen == "dealsGrad" || senderScreen == "dealsUnderGrad"{
            Database.database().reference().child("jobPosters").child(poster).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapshots {
                        if snap.key == "stripeToken"{
                            self.stripeToken = snap.value as! String
                        }
                    }
                    print("stripeToken inside charge: \(self.stripeToken)")
                    let url = self.baseURL.appendingPathComponent("charge")
                    let params: [String: Any] = [
                        "amount": amount,
                        "customer_id": self.stripeToken
                    ]
                    
                    
                    //params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
                    
                    Alamofire.request(url, method: .post, parameters: params)
                        .validate(statusCode: 200..<300)
                        .responseString { response in
                            switch response.result {
                            case .success:
                                //completion(nil)
                                Database.database().reference().child("jobPosters").child(poster).observeSingleEvent(of: .value, with: { (snapshot) in
                                    
                                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                                
                                                for snap in snapshots {
                                                    if snap.key == "creditHours"{
                                                        self.creditHours = snap.value as! Int
                                                        if senderScreen == "dealsGrad"{
                                                        self.creditHours = self.creditHours + 10
                                                        } else {
                                                            self.creditHours = self.creditHours + 5
                                                        }
                                                    }
                                                }
                                                 Database.database().reference().child("jobPosters").child(poster).updateChildValues(["creditHours": self.creditHours])
                                            }
                                    })
                            
                            case .failure(let error):
                            print(error)
                            //completion(error)
                            }
                    }
                }
            })
                                    
        }
        if senderScreen == "cancelJob" || senderScreen == "normCharge" {
            
         Database.database().reference().child("jobPosters").child(poster).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots {
                    if snap.key == "stripeToken"{
                        self.stripeToken = snap.value as! String
                    }
                }
                print("stripeToken inside charge: \(self.stripeToken)")
        let url = self.baseURL.appendingPathComponent("charge")
                let params: [String: Any] = [
            "amount": amount,
            "customer_id": self.stripeToken
                ]
            
        
        //params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
                
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    //completion(nil)
                   var containsUpcomingJobs = false
                   var containsJobsCompleted = false
                   
                   if senderScreen == "cancelJob"{
                        Database.database().reference().child("jobs").child(job["jobID"] as! String).child("workers").observeSingleEvent(of: .value, with: { (snapshot) in
                             self.workers = snapshot.value as! [String]
                            
                        
                        Database.database().reference().child("jobPosters").child(poster).observeSingleEvent(of: .value, with: { (snapshot) in
                            var cancelUpcomingArray = [String]()
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                
                                for snap in snapshots {
                                    if snap.key == "name"{
                                        self.posterWhoCancelled = snap.value as! String
                                    }
                                    if snap.key == "upcomingJobs"{
                                        cancelUpcomingArray = snap.value as! [String]
                                        cancelUpcomingArray.remove(at: cancelUpcomingArray.index(of: job["jobID"] as! String)!)
                                    }
                                    
                                    
                                    
                                }
                                Database.database().reference().child("jobPosters").child(poster).updateChildValues(["upcomingJobs": cancelUpcomingArray])
                            }
                            
                            for worker in self.workers{
                                Database.database().reference().child("students").child(worker).observeSingleEvent(of: .value, with: { (snapshot) in
                                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                                    //var containsJobs = false
                                    //var containsCompleted = false
                                    //var upcomingArray = [String]()
                                    var cancelUpcomingArray2 = [String]()
                                    //var tempCompletedArray = [String]()
                                    for snap in snapshots {
                                        
                                        if snap.key == "upcomingJobs"{
                                            cancelUpcomingArray2 = snap.value as! [String]
                                            cancelUpcomingArray2.remove(at: cancelUpcomingArray2.index(of: job["jobID"] as! String)!)
                                        }
                                        
                                        
                                    }
                                    
                                    Database.database().reference().child("students").child(worker).updateChildValues(["upcomingJobs": cancelUpcomingArray, "posterCancelled": self.posterWhoCancelled])
                                    
                                    sleep(1)
                                    Database.database().reference().child("students").child(worker).child("posterCancelled").removeValue()
                                    
                                    
                                }
                            })
                        }
                            
                            
                            
                        })
                        })
                    
                    
                   }  else {
                   Database.database().reference().child("jobPosters").child(poster).observeSingleEvent(of: .value, with: { (snapshot) in
                        var containsWaiting = false
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            
                            for snap in snapshots {
                                if snap.key == "upcomingJobs"{
                                    
                                    containsUpcomingJobs = true
                                    var tempJobArray = snap.value as! [String]
                                    tempJobArray.remove(at: tempJobArray.index(of: job["jobID"] as! String)!)
                                    var uploadDict = [String:Any]()
                                    uploadDict["upcomingJobs"] = tempJobArray
                                    Database.database().reference().child("jobPosters").child(poster).updateChildValues(uploadDict)
                                    
                                } else if snap.key == "jobsCompleted"{
                                    containsJobsCompleted = true
                                    var tempJobArray = snap.value as! [String]
                                    tempJobArray.append(job["jobID"] as! String)
                                    var uploadDict = [String:Any]()
                                    uploadDict["jobsCompleted"] = tempJobArray
                                    Database.database().reference().child("jobPosters").child(poster).updateChildValues(uploadDict)
                                } else if snap.key == "completedWaitingReview"{
                                    containsWaiting = true
                                    var tempJobArray = snap.value as! [String]
                                    tempJobArray.append(job["jobID"] as! String)
                                    var uploadDict = [String:Any]()
                                    uploadDict["completedWaitingReview"] = tempJobArray
                                }
                            }
                            var uploadDict = [String:Any]()
                            if containsWaiting == false{
                                var uploadData = [String]()
                                uploadData.append(job["jobID"] as! String)
                                
                                uploadDict["completedWaitingReview"] = uploadData
                                
                            }
                            if containsUpcomingJobs == false{
                                var uploadData = [String]()
                                uploadData.append(job["jobID"] as! String)
                                
                                uploadDict["upcomingJobs"] = uploadData
                                
                            }
                            if containsJobsCompleted == false{
                                var uploadData = [String]()
                                uploadData.append(job["jobID"] as! String)
                               
                                uploadDict["jobsCompleted"] = uploadData
                                
                            }
                            Database.database().reference().child("jobPosters").child(poster).updateChildValues(uploadDict)
                    }
                    
                    Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                            var containsJobs = false
                            var containsWaiting2 = false
                            var containsCompleted = false
                            //var upcomingArray = [String]()
                            var tempJobArray = [String]()
                            var tempCompletedArray = [String]()
                            for snap in snapshots {
                                
                                if snap.key == "upcomingJobs"{
                                    tempJobArray = snap.value as! [String]
                                    tempJobArray.remove(at: tempJobArray.index(of: job["jobID"] as! String)!)
                                    containsJobs = true
                                }
                                if snap.key == "jobsCompleted"{
                                    tempCompletedArray = snap.value as! [String]
                                    tempCompletedArray.append(job["jobID"] as! String)
                                    containsCompleted = true
                                }
                                else if snap.key == "completedWaitingReview"{
                                    containsWaiting2 = true
                                    var tempJobArray = snap.value as! [String]
                                    tempJobArray.append(job["jobID"] as! String)
                                    var uploadDict = [String:Any]()
                                    uploadDict["completedWaitingReview"] = tempJobArray
                                }
                            }
                                var uploadDict2 = [String:Any]()
                            if containsWaiting == false{
                                var uploadData = [String]()
                                uploadData.append(job["jobID"] as! String)
                                
                                uploadDict2["completedWaitingReview"] = uploadData
                                
                            }
                                if containsJobs == false{
                                    
                                    //uploadDict2["upcomingJobs"] = [self.jobID]
                                }else {
                                    uploadDict2["upcomingJobs"] = tempJobArray
                                }
                                if containsCompleted == false{
                                    uploadDict2["jobsCompleted"] = [job["jobID"] as! String]
                                } else {
                                    uploadDict2["jobsCompleted"] = tempCompletedArray
                                }
                                Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).updateChildValues(uploadDict2)
                            }
                        })
                    
                    
                })
                    }
                    
                case .failure(let error):
                    print(error)
                    //completion(error)
                }
            }
        }
        
        })
        } else if senderScreen == "cancelJobStudent" {
            Database.database().reference().child("students").child(poster).observeSingleEvent(of: .value, with: { (snapshot) in
                print("cancelJobs")
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapshots {
                        if snap.key == "name"{
                            self.studentWhoCancelled = snap.value as! String
                        }
                        if snap.key == "stripeToken"{
                            self.stripeToken = snap.value as! String
                        }
                    }
                    
                    print("stripeToken inside charge: \(self.stripeToken)")
                    let url = self.baseURL.appendingPathComponent("charge")
                    let params: [String: Any] = [
                        "amount": amount,
                        "customer_id": self.stripeToken
                    ]
                    
                    
                    //params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
                    
                    Alamofire.request(url, method: .post, parameters: params)
                        .validate(statusCode: 200..<300)
                        .responseString { response in
                            switch response.result {
                            case .success:
                                //completion(nil)
                                var containsUpcomingJobs = false
                                var containsJobsCompleted = false
                                
                                
                                    Database.database().reference().child("jobs").child(job["jobID"] as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                            for snap in snapshots {
                                                if snap.key == "workers"{
                                                    self.workers = snap.value as! [String]
                                                }
                                                if snap.key == "acceptedCount"{
                                                    self.removeAcceptedCount = (snap.value as! Int) - 1
                                                    
                                                }
                                            }
                                            
                                            self.workers.remove(at: self.workers.index(of: Auth.auth().currentUser!.uid)!)
                                            Database.database().reference().child("jobs").child(job["jobID"] as! String).updateChildValues(["acceptedCount": self.removeAcceptedCount, "workers": self.workers])
                                        }
                                        Database.database().reference().child("jobPosters").child(job["posterID"] as! String).updateChildValues(["studentCancelled": self.studentWhoCancelled])
                                        Database.database().reference().child("students").child(poster).observeSingleEvent(of: .value, with: { (snapshot) in
                                            var uploadDataStudent = [String]()
                                            
                                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                                
                                                for snap in snapshots {
                                                    if snap.key == "upcomingJobs"{
                                                        
                                                        uploadDataStudent = snap.value as! [String]
                                                        uploadDataStudent.remove(at: uploadDataStudent.index(of: job["jobID"] as! String)!)
                                                    }
                                                }
                                                Database.database().reference().child("students").child(poster).updateChildValues(["upcomingJobs": uploadDataStudent])
                                                
                                            }
                                            Database.database().reference().child("jobPosters").child(job["posterID"] as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                                var uploadDataPoster = [String]()
                                                var nearbyJobsData = [String]()
                                                var currentListingsData = [String]()
                                                var clBool = false
                                                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                                    for snap in snapshots{
                                                        if snap.key == "upcomingJobs"{
                                                            uploadDataPoster = snap.value as! [String]
                                                            uploadDataPoster.remove(at: uploadDataPoster.index(of: job["jobID"] as! String)!)
                                                        }
                                                        if snap.key == "nearbyJobs"{
                                                            
                                                            nearbyJobsData = snap.value as! [String]
                                                            nearbyJobsData.remove(at: nearbyJobsData.index(of: job["jobID"] as! String)!)
                                                        }
                                                        
                                                        if snap.key == "currentListings"{
                                                            clBool = true
                                                            currentListingsData = snap.value as! [String]
                                                            currentListingsData.append(job["jobID"] as! String)
                                                        }
                                                    }
                                                    if clBool == false{
                                                        currentListingsData = [job["jobID"] as! String]
                                                    }
                                                    Database.database().reference().child("jobPosters").child(job["posterID"] as! String).updateChildValues(["upcomingJobs": uploadDataStudent, "nearbyJobs": nearbyJobsData, "currentListings": currentListingsData])
                                                    Database.database().reference().child("jobPosters").child(job["posterID"] as! String).child("studentCancelled").removeValue()
                                                    
                                                }
                                                
                                            })
                                            
                                        })
                                        
                                    })
                            
                            case .failure(let error):
                                print(error)
                                //completion(error)
                            }
                    }
                }
                
            })
        }
        
    }
    var studentWhoCancelled = String()
    var posterWhoCancelled = String()
    
    var workers = [String]()

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        print("createCustomerKey")
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        Alamofire.request(url, method: .post, parameters: [
            "api_version": apiVersion,
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
    }
    }

}
