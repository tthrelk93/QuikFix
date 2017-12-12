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

class MyAPIClient: NSObject, STPEphemeralKeyProvider {

    static let sharedClient = MyAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func saveCard(_ stripeToken: STPToken, email: String, name: String, completion: @escaping STPErrorBlock){
        let url = self.baseURL.appendingPathComponent("user")
        var params: [String: Any] = [
            "stripeToken": stripeToken,
            "name": name,
            "email": email
        ]
        //params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                var custID = response.data
                print(custID)
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }
var stripeToken = String()
   // var poster = String()
    func completeCharge(amount: Int,
                        poster: String) {
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
                /*switch response.result {
                case .success:
                    //completion(nil)
                    
                case .failure(let error):
                    //completion(error)
                }*/
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
