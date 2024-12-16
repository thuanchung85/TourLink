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
    
   
    var array = [String]()
    let defaults = UserDefaults.standard
    
    private let store = Firestore.firestore()
    
    
    //=========ADD===//
    func add(_ card: Card, collectname:String) {
      
        do {
            // 6
            let documentRef = try store.collection(collectname).addDocument(from: card)
            let documentID = documentRef.documentID
            print("SUCCESS WRITE DATABASE FIRE STORE AT:  ", documentID)
            
            //ghi lai document id vào user default để dùng cho delete document sau này trong firestore
            array = defaults.array(forKey: "SavedStringArray_DocumentID_FireStore") as? [String] ?? []
            array.append(documentID)
            defaults.set(array, forKey: "SavedStringArray_DocumentID_FireStore")
            print("SAVE FINISH", defaults.array(forKey: "SavedStringArray_DocumentID_FireStore") as Any)
            
           
           
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
    
    //==========DELETE===//
    func delete(collectname:String, documentID:String){
       
        store.collection(collectname).document(documentID).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            }
            else {
                print("Document successfully removed!")
            }
            
        }
    }
}
