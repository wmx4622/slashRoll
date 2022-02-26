//
//  CustomUserAnnotation.swift
//  Slash Roll
//
//  Created by Voxar on 25.02.22.
//

import Foundation
import MapKit

class CustomUserAnnotationView: MKUserLocationView, ReusableIdentifier {

    //MARK: Life Cycle
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        tintColor = SRColors.cherryColor
        layer.shadowPath = UIBezierPath(
            roundedRect: .zero,
            cornerRadius: 22
          ).cgPath
    }
}


