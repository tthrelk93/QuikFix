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
    func parse(values: Any) -> [cusID] {
        var custIDs: [cusID] = []
        
        // Attempting to cast the values property into an Array of Any
        guard let values = values as? [Any] else { return custIDs }
        
        // Evaluate each value from the values Any Array
        for value in values {
            //Cast the value from the values Array to a Dictionary
            if let resultDict = value as? [String: Any] {
                
                // Attempt to initialize an instance of DogPark with the dictionary
                do {
                    let custID = try cusID(json: resultDict)
                    // If try is successful we'll append the results and continue as normal
                    custIDs.append(custID)
                } catch {
                    print("ERROR: \(error)")
                }
                
            }
        }
        
        // Returns an instance of DogPark Array
        return custIDs
    }
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
               /* case .success(let value):
                completionHandler(value as? NSDictionary, nil)
                case .failure(let error):
                completionHandler(nil, error)*/
                //self.delegate?.getID(id: resData.result.value!)
                //let strOutput = String(data : resData.result.value! as! Data, encoding : String.Encoding.utf8)
               // print(strOutput as! String)
                /*if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    if let values = response.result.value {
                        custIDs = self.parse(values: values) // Add this line of code
                        print("custIDs: \(custIDs)")
                    }
                } // else ..*/
               // switch response.result {
               // case .success:
                  //  completion(nil)
               // case .failure(let error):
                   // completion(error)
               // }
                //return resData.result.value!
        }
        //DispatchQueue.main.async{
          //  print(self.returnID)
        //return self.returnID
        //}
        //return self.returnID
        //print("custID = \(temp)")
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
