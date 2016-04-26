#MDBSwiftUtils
Utility classes for faster development. Files are documented in case you have any questions on how to use certain functions. In order to use, just add MDBSwiftUtils.swift and MDBSwiftParseUtils.swift to your XCode project.

######How to Call Functions Example - Swift:
``` swift
let timeElapsed = MDBSwiftUtils.timeSince(oldTime)
```

###MDBSwiftUtils
Includes methods to for common tasks that developers may want to accomplish in their projects.

######Included Functions - Swift:
``` swift
timeSince(oldTime: NSDate) -> String
randomNumBetween(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat
doubleToCurrencyString(val: Double) -> String
formatMultiLineLabel(label: UILabel)
getMultiLineLabelHeight(content: String, maxWidth: Int, font: UIFont)
startLocationServices(locationManager: CLLocationManager, currVC: CLLocationManagerDelegate) -> CGFloat
getCurrentLocation(locationManager: CLLocationManager) -> CLLocation
showBasicAlert(title: String, content: String, currVC: UIViewController)
```


###MDBSwiftParseUtils
Includes methods to easily accomplish tasks with Parse iOS SDK. Only include this file in your project if you have Parse iOS SDK properly integrated.

######Included Functions - Swift:
``` swift
setImageViewImageFromFile(file: PFFile, imageView: UIImageView)
setButtonImageFromFile(file: PFFile, button: UIButton)
setImageViewImageFromPointer(pointer: PFObject, imageView: UIImageView)
setImageViewImageFromPointer(pointer: PFObject, imageFieldName: String, imageView: UIImageView)
setButtonImageFromPointer(pointer: PFObject, imageFieldName: String, button: UIButton)
getDistanceString(firstLocation: PFGeoPoint, secondLocation: PFGeoPoint) -> String
getCurrentLocationGeoPoint(locationManager: CLLocationManager) -> PFGeoPoint
```

##Authors
Akkshay Khoslaa ([akhoslaa@berkeley.edu](mailto:akhoslaa@berkeley.edu))