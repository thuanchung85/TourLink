//
//  Card.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 12/09/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct Card: Identifiable, Codable {
    @DocumentID var id: String?
    var name:String
    var pass:String
    var latitude: Double
    var longitude: Double
    var timeStamp: Double
    
    var isAvaiable: Bool
    var status :String
    var userPhone: String
}


