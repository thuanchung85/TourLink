//
//  MapView.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 14/01/2022.
//
import CoreGraphics
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    //map view nay co link toi viewmodel la mapData
    @StateObject var mapData : MapViewModel
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = mapData.mapView
        view.showsUserLocation = true
        view.delegate = context.coordinator
        return view
    
    }
    
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    //====CLASS COORDINATOR===///
    class Coordinator: NSObject,MKMapViewDelegate{
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
        
        
        //=====
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            //custom pins...
            
            //thay doi hinh dang cham diem cua user tren map
            if(annotation.isKind(of: MKUserLocation.self))
            {
                //let userAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
                
                return nil
            }
           
            //thay doi hinh dang cac diem tren map
            if(annotation.isKind(of: MKPointAnnotation.self))
            {
                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                    pinAnnotation.tintColor = .red
                    pinAnnotation.animatesDrop = true
                    pinAnnotation.canShowCallout = true
                    
                return pinAnnotation
            }
            return nil
                
            
        }
        
        
        
        
        //=======TEST====//
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            if views.last?.annotation is MKUserLocation {
                addHeadingView(toAnnotationView: views.last!)
            }
        }
        
       
        func addHeadingView(toAnnotationView annotationView: MKAnnotationView) {
            var headingImageView: UIImageView?
           
            if let image = UIImage.init(named: "BlueArrowIcon")
            {
                
                headingImageView = UIImageView(image: image)
                
                headingImageView!.frame = CGRect(x: (annotationView.frame.size.width - image.size.width)/2,
                                                 y: (annotationView.frame.size.height - image.size.height)/2,
                                                 width: image.size.width,
                                                 height: image.size.height )
                //headingImageView?.backgroundColor = .red
                
                annotationView.insertSubview(headingImageView!, at: 0)
                //headingImageView!.isHidden = true
            }
                
             
        }
        
        
    }//end class Coordination
    
    
}//end struct MapView

