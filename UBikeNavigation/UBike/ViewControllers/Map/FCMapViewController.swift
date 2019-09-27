//
//  FCMapViewController.swift
//  TaiwanPlay
//
//  Created by Frost on 2016/5/30.
//  Copyright © 2016年 Frost Chen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class FCMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.showsScale = true
            mapView.showsCompass = true
            mapView.showsUserLocation = true
            mapView.showsBuildings = true
        }
    }
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var naviBtn: UIButton!
    
    @IBOutlet weak var segmentHPositionLayoutConstraint: NSLayoutConstraint!
    lazy var vm = {
       return FCMapViewModel()
    }()

    var isNavigating: Bool = false {
        didSet {
            guard oldValue != isNavigating else {return}
            self.naviBtn.isHidden = !self.isNavigating
            self.toggleSegmentControl()
            if !self.isNavigating {
                self.mapView.removeOverlays(self.mapView.overlays)
                self.vm.selectedLocation = nil
            }
        }
    }
    
    var navigationTransportType: MKDirectionsTransportType = .walking {
        didSet {
            if let locationInfo = self.vm.selectedLocation {
                self.drawDirectionLineToDestinationPoint(destinationCoor: locationInfo.coordinate, transportType: self.navigationTransportType)
            }
        }
    }
    
    var isSearchingAvalible: Bool = true
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UBike地點"
        self.initUI()
        self.initViewModel()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm.startUpdatingUserLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vm.stopUpdatingUserLocation()
    }
    
    //MARK: Init
    private func initUI() {
        let rightMenuButton: UIBarButtonItem = UIBarButtonItem(
                  image: UIImage(named: "swhere"),
                  style: .plain,
                  target: self,
                  action: #selector(self.pushToNearestVC)
              )

              self.navigationItem.rightBarButtonItems = [rightMenuButton]
    }
    
    private func initViewModel() {
        vm.selectedLocationUpdateClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.mapView.removeAnnotations(self.mapView.annotations)
                if let location = self.vm.selectedLocation {
                    self.mapView.addAnnotation(location)
                    self.drawDirectionLineToDestinationPoint(destinationCoor: location.coordinate,
                                                             transportType: self.navigationTransportType,
                                                             isSetVisibleMapRect: true)
                }
                else {
                    self.mapView.addAnnotations(self.vm.ubikeStationAnnotations)
                }
            }
        }
        
        vm.userLocationUpdateClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                if let locationInfo = self.vm.selectedLocation {
                    self.drawDirectionLineToDestinationPoint(destinationCoor: locationInfo.coordinate, transportType: self.navigationTransportType, isSetVisibleMapRect: true)
                }
            }
        }
        
        vm.ubikeStationsUpdateClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                if let location = self.vm.userLocation {
                    self.setMapToLocation(location: location)
                }
                self.mapView.addAnnotations(self.vm.ubikeStationAnnotations)
            }
        }
        
        vm.initLocationManager()
        vm.getUBikeStations()
    }
    
    @objc func pushToNearestVC(sender:AnyObject) {
        guard self.vm.ubikeStations.count > 0 else {return}
        
        if let userLocation = self.vm.userLocation {
            self.vm.getStationDistances(userLocation: userLocation)
            let vc = SNearestViewController(ubikeStations: vm.ubikeStations)
            vc.delegate = self
            vc.presentFromViewController(ViewController: self)
        }
    }
    
    //MARK: 3D
    private func set3DCamera() {
        guard let coordinate = vm.userLocation?.coordinate else {return}

        let mapCamera =  MKMapCamera()
        mapCamera.centerCoordinate = coordinate
        mapCamera.pitch = 65
        mapCamera.altitude = 200
        mapCamera.heading = 45
        
        mapView.showsBuildings = true
        mapView.mapType = .satelliteFlyover
        mapView.setCamera(mapCamera, animated: true)
    }
    
    //MARK: Map Gerenal Function
    private func drawDirectionLineToDestinationPoint(destinationCoor:CLLocationCoordinate2D, transportType: MKDirectionsTransportType, isSetVisibleMapRect:Bool = false) {
        guard let sourcePoint = vm.userLocation?.coordinate else {return}
        mapView.removeOverlays(mapView.overlays);
        /////
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourcePoint, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoor, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = transportType
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard error == nil,
                let unwrappedResponse = response,
                let route = unwrappedResponse.routes.first else {
                    Util.alertMessage(title: "無法取得路徑", message: nil, centerButtonTitle: "Cancel")
                    return
            }
            
            if(isSetVisibleMapRect) {
                let mapRect = route.polyline.boundingMapRect
                let newSize = MKMapSize(width: mapRect.size.width * 2,
                                        height: mapRect.size.height * 2)
                let newOrg = MKMapPoint(x: mapRect.origin.x + (mapRect.size.width - newSize.width)/2,
                                        y: mapRect.origin.y + (mapRect.size.height - newSize.height)/2)
                let rect = MKMapRect(origin: newOrg,
                                     size: newSize)
                DispatchQueue.main.async {
                    self.mapView.setVisibleMapRect(rect, animated: true)
                }
            }
            
            let routeCoords = route.polyline.coordinates
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.mapView.animate(route: routeCoords, duration: 0.5) {
                    print("routeCoords animation finished")
                    self.isNavigating = true
                }
            }
        }
    }
    
    public func setMapToLocation(location:CLLocation) {
        mapView.showsBuildings = false
        mapView.mapType = .standard
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: span), animated: true)
    }
    
    public func setMapToLocation(location:CLLocationCoordinate2D) {
        mapView.showsBuildings = false
        mapView.mapType = .standard
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        mapView.setRegion(MKCoordinateRegion(center: location, span: span), animated: true)
    }
    
    private func toggleSegmentControl() {
        DispatchQueue.main.async {
            guard let segment = self.segmentControl else{return}
            let items = self.isNavigating ? ["步行", "開車", "大眾運輸"] : ["借車", "還車"]
            segment.replaceSegments(segments: items)
            segment.selectedSegmentIndex = self.isNavigating ? 0 : (self.isSearchingAvalible ? 0 : 1)
            let animationOffset = segment.bounds.width + (self.isNavigating ? 200.0 : 0.0)
            self.segmentHPositionLayoutConstraint.constant = -1 * animationOffset
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5) {
                self.segmentHPositionLayoutConstraint.constant = 16
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
  //MARK: IB Actions
    
    @IBAction func userLocationButton_TouchUp(_ sender: AnyObject) {
        if let userLocation = vm.userLocation {
            self.setMapToLocation(location: userLocation)
        }
    }
    
    @IBAction func the3DButton_TouchUp(_ sender: AnyObject) {
        self.set3DCamera()
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        if isNavigating {
            switch sender.selectedSegmentIndex {
            case 0:
                self.navigationTransportType = .walking
            case 1:
                self.navigationTransportType = .automobile
            case 2:
                self.navigationTransportType = .transit
            default:
                break
            }
        }
        else {
            self.isSearchingAvalible = sender.selectedSegmentIndex == 0
            self.mapView.removeAnnotations(self.vm.ubikeStationAnnotations)
            self.mapView.addAnnotations(self.vm.ubikeStationAnnotations)
        }
    }
    
    @IBAction func naviBtnPressed(_ sender: UIButton) {
        self.isNavigating = false
        self.navigationTransportType = .walking
    }
}




//MARK:- MKMapViewDelegate
extension FCMapViewController: MKMapViewDelegate {
    public func mapView(_ rendererFormapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor(rgb: 0x3E87FF);
        // 3EA7FF
        polylineRenderer.lineWidth = 4
        return polylineRenderer
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let ubAnnotation = annotation as? UBStationPointAnnotation else { return nil }
        let reusableId = "PinView"
        var pinView: PinView?

        if #available(iOS 11.0, *) {
            pinView = mapView.annotationView(of: PinMarkerView.self, annotation: annotation, reuseIdentifier: reusableId)
        }
        else {
            pinView = mapView.annotationView(of: PinAnnoView.self, annotation: annotation, reuseIdentifier: reusableId)
        }
        
        pinView?.canShowCallout = true
        let space = isSearchingAvalible ? ubAnnotation.availableSpaces : ubAnnotation.emptySpaces
        pinView?.config(("\(space)"))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setImage(ubAnnotation.image, for: .normal)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView

    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        guard let location = view.annotation as? UBStationPointAnnotation else{return}
        self.vm.selectedLocation = location
    }
}

extension FCMapViewController: SNearestViewControllerDelegate {
    func selected(station: UBikeStation) {
        let coor = CLLocationCoordinate2DMake(station.latitude,
                                                  station.longitude)
        let location = UBStationPointAnnotation(name: station.chineseName,
                                             availableSpaces: station.currentAvailableSpacesCount,
                                             emptySpaces: station.currentEmptySpacesCount,
                                             coordinate: coor)
        self.vm.selectedLocation = location
    }
}
