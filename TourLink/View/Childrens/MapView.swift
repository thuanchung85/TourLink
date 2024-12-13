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
            renderer.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.8507854436)
            renderer.lineWidth = 6
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
                let s = annotation.title ?? ""
                //neu la cac member thi dung hinh marker
                if (s?.contains(find: "Friend @_@") == true)
                {
                    let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "FRIEND_VIEW")
                         annotationView.canShowCallout = true
                         annotationView.animatesWhenAdded = true
                        let configuration = UIImage.SymbolConfiguration(pointSize: 50)
                         annotationView.glyphImage = UIImage(systemName: "person.fill", withConfiguration: configuration)
                         annotationView.glyphTintColor = .systemBlue
                         annotationView.markerTintColor = .green
                         print(annotationView.bounds.size) // defaulted to 28,28
                         annotationView.bounds.size = CGSize(width: 50, height: 50) // Does not change bubble size
                    
                    print("return friend annotation view")
                    
                    return annotationView
                }
                //neu là dich den thi dung hinh kim cham
                else{
                    let pinAnnotation = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                    pinAnnotation.tintColor = .red
                    pinAnnotation.animatesWhenAdded = true
                    pinAnnotation.canShowCallout = true
                    print("return PIN_VIEW annotation view")
                    return pinAnnotation
                }
                
            }
            
            
            
            return nil
                
            
        }
        
        
        
        
        //=======ADD mui ten huong chi duong vao vi tri user====//
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            //neu la user annotation add vao
            if views.last?.annotation is MKUserLocation {
                //neu user chua co gan mui ten chi duong thi gan vao, sau do khoa hok cho gan them nua
                if(isUserAddHeadingArrow == false){
                    parent!.addHeadingView(toAnnotationView: views.last!)
                    isUserAddHeadingArrow = true
                }
            }
            
            //neu la location dich den annotation add vao
            if views.last?.annotation is MKPointAnnotation {
                if let annotation = views.last(where: { $0.reuseIdentifier == "PIN_VIEW" })?.annotation {
                    //zoom toi vi tri location dich den
                        mapView.selectAnnotation(annotation, animated: true)
                    }
            }
            
        }
        
       
        //===Khi user tap vào vi tri đánh dấu trên MAP===//
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
                if let annotation = view.annotation {
                    //Process your annotation here
                    print("Annotation CLICK!", annotation)
                    self.parent?.vitriNoiCanDen = annotation.coordinate
                }
            }
       
    }//end class Coordination
    
    
}//end struct MapView

