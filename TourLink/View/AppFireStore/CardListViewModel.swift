//
//  CardListViewModel.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 12/09/2024.
//

import Foundation
// 1
import Combine

// 2
class CardListViewModel: ObservableObject {
  // 3
  @Published var cardRepository = CardRepository()

  // 4
  func add(_ card: Card) {
      if (!card.pass.isEmpty) && (card.latitude != 0) && (card.longitude != 0) && (!card.userPhone.isEmpty) {
          cardRepository.add(card)
      }
  }
}
