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
  var question: String
  var answer: String
  var successful: Bool = true
  var userId: String?
}


