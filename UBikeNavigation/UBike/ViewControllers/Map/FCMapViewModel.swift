//
//  FCMapViewModel.swift
//  P6
//
//  Created by 黃柏叡 on 2019/9/24.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation
import CoreLocation

class FCMapViewModel: NSObject {
    private var locationManager:CLLocationManager!
    var userLocation:CLLocation?
    var selectedLocation:UBStationPointAnnotation? {
        didSet {
            self.selectedLocationUpdateClosure?()
        }
    }
    
    var ubikeStations: [UBikeStation] = []
    
    var ubikeStationAnnotations: [UBStationPointAnnotation] = [] {
        didSet {
            self.ubikeStationsUpdateClosure?()
        }
    }
    
    var selectedLocationUpdateClosure: (()->())?
    var userLocationUpdateClosure: (()->())?
    var ubikeStationsUpdateClosure: (()->())?
    
    func startUpdatingUserLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingUserLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func getUBikeStations() {
        UBikeRepository.shared.fetchAllUBikeStations { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let stations):
                self.ubikeStations = stations
                self.mapUbikeStationAnnotations()
            case .failure(let error):
                print("error -> \(error)")
            }
        }
    }
    
    func mapUbikeStationAnnotations() {
        self.ubikeStationAnnotations = self.ubikeStations.map { (station: UBikeStation) -> UBStationPointAnnotation in
            let coor = CLLocationCoordinate2DMake(station.latitude,
                                                      station.longitude)
            return UBStationPointAnnotation(name: station.chineseName,
                                            availableSpaces: station.currentAvailableSpacesCount,
                                            emptySpaces: station.currentEmptySpacesCount,
                                            coordinate: coor)
        }
    }
    
    func getStationDistances(userLocation: CLLocation) {
        for (index, station) in ubikeStations.enumerated() {
            let location = CLLocation(latitude: station.latitude, longitude: station.longitude)
            let meters =  userLocation.distance(from: location)
            ubikeStations[index].distance = meters
        }
        
        ubikeStations = ubikeStations.sorted(by: { (item1, item2) -> Bool in
            return item1.distance! < item2.distance!
        })
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = CLLocationDistance(5)
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }
}

//MARK:- CLLocationManagerDelegate
extension FCMapViewModel: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        
        //TODO: MOVE TO VC
//
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
