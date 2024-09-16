//
//  CardRepository.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 12/09/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
// 2
class CardRepository: ObservableObject 
{
    
   
    
   
    
    private let store = Firestore.firestore()
    
    
    //=========ADD===//
    func add(_ card: Card, collectname:String) {
      
        do {
            // 6
            _ = try store.collection(collectname).addDocument(from: card)
        } catch {
            fatalError("Unable to add card: \(error.localizedDescription).")
        }
    }
    
    //=======GET=======//
    
    func get(collectname:String,completionHandler:  @escaping ([Card]) -> Void)
    {
        var arrCards = [Card]()
        // 3
        store.collection(collectname)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                  //handle error
                    print("get firestore \(collectname) ERROR!")
                  return
                }
                
                
                snapshot.documents.forEach({ (documentSnapshot) in
                    let documentData = documentSnapshot.data()
                    
                    
                    let mCard = Card(name: documentData["name"] as! String, 
                                     pass: documentData["pass"] as! String,
                                     latitude: documentData["latitude"] as! Double,
                                     longitude: documentData["longitude"] as! Double,
                                     timeStamp: documentData["timeStamp"] as! Double,
                                     isAvaiable: (documentData["isAvaiable"] != nil),
                                     status: documentData["status"] as! String,
                                     userPhone: documentData["userPhone"] as! String)
                    
                    
                    arrCards.append(mCard)
                })
                
                // call the completion handler and pass the result array
                completionHandler(arrCards)
            }
        
    }
    
    
}
