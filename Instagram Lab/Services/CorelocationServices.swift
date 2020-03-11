//
//  CorelocationServices.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/10/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationService {
  
  static public func getCoordinate( addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(addressString) { (placemarks, error) in
      if error == nil {
        if let placemark = placemarks?[0] {
          let location = placemark.location!
          completionHandler(location.coordinate, nil)
          return
        }
      }
      completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
    }
  }
}
