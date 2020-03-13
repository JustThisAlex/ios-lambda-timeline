//
//  MapViewController.swift
//  ImageFilters
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("NewImage"), object: nil)
        
        mapView.delegate = self
        reload()
    }
    
    @objc func reload() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Image")
        
        let images = Helper.getImages()

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(images)
        
        guard let mostRecent = images.last else { return }
        let region = MKCoordinateRegion(center: mostRecent.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let image = annotation as? Image else { return nil }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Image", for: annotation) as? MKMarkerAnnotationView else { return nil }
        
        annotationView.canShowCallout = true
        let detailView = DetailView()
        detailView.image = image
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}

class DetailView: UIView {
    var image: Image? { didSet {
        if let data = image?.image {
            imageView.image = UIImage(data: data)
            addSubview(imageView)
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
            imageView.contentMode = .scaleAspectFill
        }
        }}
    private let imageView = UIImageView()
}

