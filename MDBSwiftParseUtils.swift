//
//  MDBSwiftParseUtils.swift
//
//  Created by Akkshay Khoslaa on 4/25/16.
//  Copyright © 2016 Mobile Developers of Berkeley. All rights reserved.
//

import Foundation
import UIKit
import Parse
import CoreLocation

public class MDBSwiftParseUtils {
    
    /**
     Sets the image of an imageview asynchronously.
     
     - parameters:
        - file: PFFile containing image
        - imageView: UIImageView that you want to set the image of
     */
    static func setImageViewImageFromFile(file: PFFile, imageView: UIImageView) {
        file.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    imageView.image = image
                }
            }
        }
    }
    
    /**
     Sets the image of a UIButton asynchronously.
     
     - parameters:
        - file: PFFile containing image
        - button: UIButton that you want to set the image of
     */
    static func setButtonImageFromFile(file: PFFile, button: UIButton) {
        file.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    button.setImage(image, forState: .Normal)
                }
            }
        }
    }
    
    /**
     Sets the image of an imageview asynchronously using a pointer that is passed in.
     
     - parameters:
        - pointer: PFObject that needs to be fetched that contains the PFFile
        - imageView: UIImageView that you want to set the image of
     */
    static func setImageViewImageFromPointer(pointer: PFObject, imageView: UIImageView) {
        pointer.fetchIfNeededInBackgroundWithBlock {
            (imageObject: PFObject?, error: NSError?) -> Void in
            let headerImageFile = imageObject!["img"] as! PFFile
            headerImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        imageView.image = image
                    }
                }
            }
        }
    }
    
    /**
     Sets the image of an imageview asynchronously using a pointer that is passed in.
     
     - parameters:
        - pointer: PFObject that needs to be fetched that contains the PFFile
        - imageView: UIImageView that you want to set the image of
        - imageFieldName: Name of the field containing the PFFile
     */
    static func setImageViewImageFromPointer(pointer: PFObject, imageFieldName: String, imageView: UIImageView) {
        pointer.fetchIfNeededInBackgroundWithBlock {
            (imageObject: PFObject?, error: NSError?) -> Void in
            let headerImageFile = imageObject!["img"] as! PFFile
            headerImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        imageView.image = image
                    }
                }
            }
        }
    }
    
    /**
     Sets the image of an imageview asynchronously using a pointer that is passed in.
     
     - parameters:
        - pointer: PFObject that needs to be fetched that contains the PFFile
        - imageView: UIImageView that you want to set the image of
        - imageFieldName: Name of the field containing the PFFile
     */
    static func setButtonImageFromPointer(pointer: PFObject, imageFieldName: String, button: UIButton) {
        pointer.fetchIfNeededInBackgroundWithBlock {
            (imageObject: PFObject?, error: NSError?) -> Void in
            let headerImageFile = imageObject!["img"] as! PFFile
            headerImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        button.setImage(image, forState: .Normal)
                    }
                }
            }
        }
    }
    
    /**
     Returns the distance between 2 locations as a formatted string.
     
     - returns:
     distance between 2 locations as a String
     
     - parameters:
        - firstLocation: first location geopoint
        - secondLocation: second location geopoint
     */
    static func getDistanceString(firstLocation: PFGeoPoint, secondLocation: PFGeoPoint) -> String {
        return "\(Double(round(10*firstLocation.distanceInMilesTo(secondLocation))/10)) mi"
    }
    
    /**
     Check if location services are authorized, and if they are get the current location. 
     Make sure you call MDBSwiftUtils.startLocationServices() first.
     
     - returns:
     the current location as PFGeoPoint if location services are authorized; otherwise returns nil
     
     - parameters:
        - locationManager: CLLocationManager instance being used in your VC
     */
    static func getCurrentLocationGeoPoint(locationManager: CLLocationManager) -> PFGeoPoint? {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse
          || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways) {
                
          let currentLocation = locationManager.location
          return PFGeoPoint(location: currentLocation)
                
        } else {
            return nil
        }
    }
  
}