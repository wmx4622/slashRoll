//
//  CustomAnnotationView.swift
//  Slash Roll
//
//  Created by Voxar on 25.02.22.
//

import Foundation
import MapKit


class CustomAnnotationView: MKMarkerAnnotationView, ReusableIdentifier {

    //MARK: - Life Cycle
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        tintColor = SRColors.cherryLightColor
        markerTintColor = SRColors.cherryLightColor
        canShowCallout = true
        animatesWhenAdded = true

        let detailsView = UIView()
        detailCalloutAccessoryView = detailsView
        let callaoutButton = UIButton(type: .detailDisclosure)
        callaoutButton.setImage(UIImage(systemName: "applepencil"), for: .normal)
        leftCalloutAccessoryView = callaoutButton
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
}
