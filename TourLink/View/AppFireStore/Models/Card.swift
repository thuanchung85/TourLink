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
    
  var latitude: Double
  var longitude: Double
    
  var isAvaiable: Bool
    var status :String
  var userPhone: String
}


