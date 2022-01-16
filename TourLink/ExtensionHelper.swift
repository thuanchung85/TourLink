//
//  ExtensionHelper.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 16/01/2022.
//

import Foundation
import SwiftUI

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}
