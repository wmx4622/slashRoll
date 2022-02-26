//
//  CustomAnnotation.swift
//  Slash Roll
//
//  Created by Voxar on 25.02.22.
//

import MapKit


class CustomAnnotation: NSObject, MKAnnotation {

    //MARK: - Fields
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var address: String?
    var workingHours: String?

    //MARK: - Initialization
    
    init(title: String?, subtitle: String?, cordinate: CLLocationCoordinate2D, address: String?, workingHours: String?) {
        self.coordinate = cordinate
        self.title = title
        self.subtitle = subtitle
        self.address = address
        self.workingHours = workingHours
        
    }


}

