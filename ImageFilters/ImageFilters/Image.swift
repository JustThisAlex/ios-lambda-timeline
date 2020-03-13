//
//  Image.swift
//  ImageFilters
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import MapKit

class Image: NSObject, Codable, MKAnnotation {
    let title: String?
    let image: Data?
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(title: String, image: Data?, latitude: Double, longitude: Double) {
        self.title = title
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }
}
