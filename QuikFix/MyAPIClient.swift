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
        var custIDs: [cusID] = []
        print("saveCArd")
        let url = self.baseURL.appendingPathComponent("user")
        var params: [String: Any] = [
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
                completionHandler(self.returnID as? String, nil)
              
        }
    }
    var stripeToken = String()
    //var job = [String:Any]()
   // var poster = String()
    func completeCharge(amount: Int,
                        poster: String, job: [String:Any]) {
        
        
        Database.database().reference().child("jobPosters").child(poster).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots {
                    if snap.key == "stripeToken"{
                        self.stripeToken = snap.value as! String
                    }
                }
                print("stripeToken inside charge: \(self.stripeToken)")
        let url = self.baseURL.appendingPathComponent("charge")
        var params: [String: Any] = [
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
                   Database.database().reference().child("jobPosters").child(poster).observeSingleEvent(of: .value, with: { (snapshot) in
                        
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
                                }
                            }
                            if containsUpcomingJobs == false{
                                var uploadData = [String]()
                                uploadData.append(job["jobID"] as! String)
                                var uploadDict = [String:Any]()
                                uploadDict["upcomingJobs"] = uploadData
                                Database.database().reference().child("jobPosters").child(poster).updateChildValues(uploadDict)
                            }
                            if containsJobsCompleted == false{
                                var uploadData = [String]()
                                uploadData.append(job["jobID"] as! String)
                                var uploadDict = [String:Any]()
                                uploadDict["jobsCompleted"] = uploadData
                                Database.database().reference().child("jobPosters").child(poster).updateChildValues(uploadDict)
                            }
                    }
                    
                    Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                            var containsJobs = false
                            var containsCompleted = false
                            var upcomingArray = [String]()
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
                            }
                                var uploadDict2 = [String:Any]()
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
                    
                case .failure(let error):
                    print(error)
                    //completion(error)
                }
            }
        }
        
        })
        
    }

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
