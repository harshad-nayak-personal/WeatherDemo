//
//  CLLocation+Extension.swift
//  DemoApp
//
//

import Foundation
import MapKit

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?,
                                                    _ country:  String?,
                                                    _ error: Error?) -> ()) {
//        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
//        
        CLGeocoder().reverseGeocodeLocation(self) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
}
