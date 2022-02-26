//
//  MapViewController.swift
//  Slash Roll
//
//  Created by Voxar on 24.02.22.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {

    //MARK: - Properties

    private lazy var locationManager = CLLocationManager()
    private lazy var marketsDataManager = MarketsDataManager()

    //MARK: - GUI variables

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.reuseIdentifier)
        mapView.register(CustomUserAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomUserAnnotationView.reuseIdentifier)
        mapView.delegate = self
        mapView.showsUserLocation = true

        return mapView
    }()

    private lazy var clearOverlayButton: UIButton = {
        let clearOverlayButton = UIButton()
        clearOverlayButton.tintColor = SRColors.cherryColor
        clearOverlayButton.setImage(UIImage(systemName: "clear" ), for: .normal)
        clearOverlayButton.contentVerticalAlignment = .fill
        clearOverlayButton.contentHorizontalAlignment = .fill
        clearOverlayButton.addTarget(self, action: #selector(removeAllOverlays), for: .touchUpInside)
        return clearOverlayButton
    }()

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        view.backgroundColor = SRColors.whiteColor
        addMarketAnnotations()
        configureLocationManager()
        centerCamera()
    }

    private func addSubviews() {
        view.addSubview(mapView)
        view.addSubview(clearOverlayButton)
    }
    
    //MARK: - Layout Configuration

    private func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        clearOverlayButton.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(30)
        }
    }

    //MARK: - Map Configuration

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }

    private func centerCamera() {
        mapView.setCamera(
            MKMapCamera(
                lookingAtCenter: CLLocationCoordinate2D(latitude: 53.9, longitude: 27.56),
                fromDistance:70000,
                pitch: 0,
                heading: 0),
            animated: true
        )
    }

    private func addMarketAnnotations() {
        marketsDataManager.loadMarketsList { [weak self] in
            self?.marketsDataManager.getAllMarkets().forEach { market in
                let annotation = CustomAnnotation(title: market.name, subtitle: nil, cordinate: CLLocationCoordinate2D(latitude: market.latitude, longitude: market.longitude), address: market.address, workingHours: market.workingHours)
                self?.mapView.addAnnotation(annotation)
            }
        }

    }

    //MARK: - User Interaction

    @objc private func removeAllOverlays() {
        mapView.removeOverlays(mapView.overlays)
    }
}

//MARK: - MapView Delegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: CustomAnnotation.self) {
            return mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.reuseIdentifier, for: annotation)
        }

        if annotation.isKind(of: MKUserLocation.self) {
            return mapView.dequeueReusableAnnotationView(withIdentifier: CustomUserAnnotationView.reuseIdentifier)
        }
        
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.leftCalloutAccessoryView {

            guard let destinationCoordinate = view.annotation?.coordinate else { return }

            locationManager.requestWhenInUseAuthorization()

            guard locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse else { return }

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
            request.transportType = .automobile

            let destination = MKDirections(request: request)

            destination.calculate { [weak self] response, error in
                guard let route = response?.routes.first else { return }
                self?.updateMapView(with: route)
            }

        } else {
            guard let annotation = view.annotation as? CustomAnnotation else { return }
            showAlert(title: "Информация", message: "Время работы \(annotation.workingHours ?? "неизвестно")\n Адрес \(annotation.address ?? "Адрес неизвестен")")
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = SRColors.cherryColor
        renderer.lineWidth = 3
        return renderer
    }

    private func updateMapView(with route: MKRoute) {
        let padding: CGFloat = 8
        mapView.addOverlay(route.polyline)
        mapView.setVisibleMapRect(
            mapView.visibleMapRect.union(
                route.polyline.boundingMapRect
            ),
            edgePadding: UIEdgeInsets(
                top: padding,
                left: padding,
                bottom: padding,
                right: padding
            ),
            animated: true
        )
    }

}

//MARK: - Location Manager Delegate

extension MapViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        showAlert(title: "Ошибка", message: error.localizedDescription)
    }
}
