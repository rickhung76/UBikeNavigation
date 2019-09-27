//
//  Extensions.swift
//  Cluster
//
//  Created by Lasha Efremidze on 7/8/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import UIKit
import MapKit


extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)

        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))

        return coords
    }
}

extension MKMapView {
    func annotationView<T: MKAnnotationView>(of type: T.Type, annotation: MKAnnotation?, reuseIdentifier: String) -> T {
        guard let annotationView = dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? T else {
            return type.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        annotationView.annotation = annotation
        return annotationView
    }
    
    func animate(route: [CLLocationCoordinate2D], duration: TimeInterval, completion: (() -> Void)?) {
            guard route.count > 0 else { return }
            var currentStep = 1
            let totalSteps = route.count
            let stepDrawDuration = duration/TimeInterval(totalSteps)
            let drawDuration = stepDrawDuration > 0.03 ? 0.03 : stepDrawDuration // miniman 1/30 fps
            var previousSegment: MKPolyline?

            Timer.scheduledTimer(withTimeInterval: drawDuration, repeats: true) { [weak self] timer in
                guard let self = self else {
                    // Invalidate animation if we can't retain self
                    timer.invalidate()
                    completion?()
                    return
                }
                
                if let previous = previousSegment {
                    // Remove last drawn segment if needed.
                    self.removeOverlay(previous)
                    previousSegment = nil
                }
                
                guard currentStep < totalSteps else {
                    // If this is the last animation step...
                    let finalPolyline = MKPolyline(coordinates: route, count: route.count)
                    self.addOverlay(finalPolyline)
                    // Assign the final polyline instance to the class property.
                    timer.invalidate()
                    completion?()
                    return
                }
                
                // Animation step.
                // The current segment to draw consists of a coordinate array from 0 to the 'currentStep' taken from the route.
                let subCoordinates = Array(route.prefix(upTo: currentStep))
                let currentSegment = MKPolyline(coordinates: subCoordinates, count: subCoordinates.count)
                self.addOverlay(currentSegment)
                
                previousSegment = currentSegment
                currentStep += 1
            }
        }
}
