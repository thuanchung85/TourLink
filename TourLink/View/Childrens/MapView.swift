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
        return MapView.Coordinator(mapData)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = mapData.mapView
        view.showsUserLocation = true
        view.userTrackingMode = .followWithHeading
        view.delegate = context.coordinator
        return view
    
    }
    
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    //====CLASS COORDINATOR===///
    class Coordinator: NSObject,MKMapViewDelegate{
        
        private let parent: MapViewModel?
        private var isUserAddHeadingArrow =  false
        
        //init
        init(_ parent: MapViewModel) {
            self.parent = parent
        }
        
        //===ham ve duong di mau xanh duong==///
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
        
        
        //===HAM thay doi hinh anh cua vi tri cac node tren map==//
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
        
        
        
        
        //=======ADD mui ten huong chi duong vao vi tri user====//
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            if views.last?.annotation is MKUserLocation {
                //neu user chua co gan mui ten chi duong thi gan vao, sau do khoa hok cho gan them nua
                if(isUserAddHeadingArrow == false){
                    parent!.addHeadingView(toAnnotationView: views.last!)
                    isUserAddHeadingArrow = true
                }
            }
        }
        
       
        
       
    }//end class Coordination
    
    
}//end struct MapView

