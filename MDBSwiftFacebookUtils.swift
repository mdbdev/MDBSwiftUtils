//
//  MDBSwiftFacebookUtils.swift
//  SalePool
//
//  Created by Akkshay Khoslaa on 5/20/16.
//  Copyright © 2016 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class MDBSwiftFacebookUtils {
    
    var facebookFriends: Array<NSDictionary>!
    
    /**
     Gets all of the user's Facebook friends asynchronously. Block is called once all friends are retrieved.
     
     - parameters:
     - block: block that is executed once all friends are retrieved.
     */
    func getAllFBFriendsWithBlock(block: (Array<NSDictionary>) -> Void) {
        
        facebookFriends = Array<NSDictionary>()
        
        getFriendsUsingApp()
        
        getFriendsNotUsingApp(nil, finalCompletion: block)
        
    }
    
    /**
     Gets all of the user's Facebook friends asynchronously. Retrieves all friends in batches of 25 and executes the block after each batch is retrieved .
     
     - parameters:
        - block: block that is called each time a batch is retrieved.
     */
    func getAllFBFriendsWithIncrementalBlock(block: (Array<NSDictionary>) -> Void) {
        
        facebookFriends = Array<NSDictionary>()
        
        getFriendsUsingApp()
        
        getFriendsNotUsingApp(block, finalCompletion: nil)
        
        
    }
    
    private func getFriendsNotUsingApp(eachCompletion: ((Array<NSDictionary>) -> Void)?, finalCompletion: ((Array<NSDictionary>) -> Void)?) {
        FBSDKGraphRequest(graphPath: "/me/invitable_friends", parameters: ["fields": "name, email, friends, picture"]).startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            
            let data = result.objectForKey("data") as! NSArray
            
            for i in 0...(data.count - 1) {
                let infoDict : NSDictionary = data[i] as! NSDictionary
                self.facebookFriends.append(infoDict)
            }
            
            if finalCompletion == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    eachCompletion!(self.facebookFriends)
                })
            }
            
            if let paging = result.objectForKey("paging") as! NSDictionary? {
                if let nextString = paging.objectForKey("next") as! String? {
                    self.recursiveRequestFriends(nextString, eachCompletion: eachCompletion, finalCompletion: finalCompletion)
                }
            }
            
        }
    }
    
    private func getFriendsUsingApp() {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: ["fields": "name, email, friends, picture"])
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                
                let resultDict = result as! NSDictionary
                
                let data = resultDict.objectForKey("data") as! NSArray
                
                for i in 0...(data.count - 1) {
                    let infoDict : NSDictionary = data[i] as! NSDictionary
                    self.facebookFriends.append(infoDict)
                }
                
                
            } else {
                
                print("Error: \(error)");
                
            }
        }

    }
    
    private func recursiveRequestFriends(urlString: String, eachCompletion: ((Array<NSDictionary>) -> Void)?, finalCompletion: ((Array<NSDictionary>) -> Void)?) {
        
        httpJSONGETRequest(urlString, completion: {(result: NSDictionary) -> Void in
            
            let data : NSArray = result.objectForKey("data") as! NSArray
            
            for i in 0...(data.count - 1) {
                let infoDict : NSDictionary = data[i] as! NSDictionary
                self.facebookFriends.append(infoDict)
            }
            
            if finalCompletion == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    eachCompletion!(self.facebookFriends)
                })
            }
            
            
            if let paging = result.objectForKey("paging") as! NSDictionary? {
                if let nextString = paging.objectForKey("next") as! String? {
                    self.recursiveRequestFriends(nextString, eachCompletion: eachCompletion, finalCompletion: finalCompletion)
                } else {
                    if eachCompletion == nil {
                        finalCompletion!(self.facebookFriends)
                    }
                }
            }
            
        })
        
    }

    private func httpJSONGETRequest(urlString: String, completion: (NSDictionary) -> Void) {
        let url: NSURL = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let opQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: opQueue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            do {
                
                if let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    completion(result)
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }
    
    /**
     Get the current user's name, email, gender, and Facebook id in an NSDictionary.
     
     - parameters:
        - block: block that's called once data has been retrieved
 
    */
    func getFBDataWithBlock(block: (NSDictionary) -> Void) {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email, gender"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if error != nil {
                
                print("Error: \(error)")
                
            } else {
                
                block(result as! NSDictionary)
               
            }
        })
    }
    
    /**
     Get the current user's Facebook profile picture as a UIImage.
     
     - parameters:
        - block: block that's called once picture has been retrieved
     
     */
    func getFBProfilePicWithBlock(block: (UIImage) -> Void) {
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                
                if let profilePicture = result.objectForKey("data") as! NSDictionary? {
                    
                    if let picUrl = profilePicture.objectForKey("url") as! String? {
                        
                        let url = NSURL(string: picUrl)
                        let urlRequest = NSURLRequest(URL: url!)
                        
                        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                            (response, data, error) in
                            
                            let image = UIImage(data: data!)
                            
                            block(image!)
                            
                        })
                        
                    } else {
                        print("Picture could not be retrieved")
                    }
                    
                } else {
                    
                    print("Picture could not be retrieved")
                    
                }
                
            } else {
                print("Erorr: \(error)")
            }
            
        })

    }
    

    
}