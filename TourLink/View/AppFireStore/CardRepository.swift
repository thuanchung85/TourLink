//
//  CardRepository.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 12/09/2024.
//
import UserNotifications
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
    private var registration: ListenerRegistration?
    
    //=========ADD===//
    func add(_ card: Card, collectname:String) {
      
        do {
            // 6
            let documentRef = try store.collection(collectname).addDocument(from: card)
            let documentID = documentRef.documentID
            print("SUCCESS WRITE DATABASE FIRE STORE AT:  ", documentID)
            
            //ghi lai document id vào user default để dùng cho delete document sau này trong firestore
            array = defaults.array(forKey: "SavedStringArray_DocumentID_FireStore") as? [String] ?? []
            array.append(documentID + "<$>" + collectname)
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
    func delete() -> String{
        
        array = defaults.array(forKey: "SavedStringArray_DocumentID_FireStore") as? [String] ?? []
        array = array.filter({ $0 != ""})
        for i in array{
            guard let collectname = i.components(separatedBy: "<$>").last else { return "delete fail no collectname" }
            guard let documentID = i.components(separatedBy: "<$>").first else { return "delete fail no documentID" }
            if(collectname.isEmpty == false){
                store.collection(collectname).document(documentID).delete(){ err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    }
                    else {
                        print("Document successfully removed!")
                    }
                    
                }
               
            }
            else{
                return "delete fail no collectname"
            }
        }
      
        return "ok delete success"
    }
    
    //=======WATCH CHANGE OF DOCUMENT====//
    func watch(collectname:String, myCurrentName:String, thoiGianAppBatLen:Double)
    {
        print("WATCHING --> collection: " + collectname)
        
        //====tìm ra bên trong collecttion này có bao nhieu user khác tên==//
        /*
        var arrCardsT = [Card]()
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
                    
                    
                    arrCardsT.append(mCard)
                })
                
                let arr_kiemRaCacNameKhacNhau = arrCardsT.removingDuplicates(withSame: \.name).map { item  in
                    item.name
               
                }
                print("CAC USER CO TRONG COLLECTION NAY:  ", arr_kiemRaCacNameKhacNhau)
                var arrChuaItemLastTimeUpdate = [Card]()
                for i in 0..<arr_kiemRaCacNameKhacNhau.count{
                    print(arr_kiemRaCacNameKhacNhau[i])
                    //lọc array x theo tên
                    let x = arrCardsT.filter { item in
                        item.name.contains(find: arr_kiemRaCacNameKhacNhau[i])
                    }
                    
                    let xSort = x.sorted { c1, c2 in
                        c1.timeStamp > c2.timeStamp
                    }
                    
                    
                    let lastestItem = xSort.first
                    if(lastestItem != nil){
                        arrChuaItemLastTimeUpdate.append(lastestItem!)
                    }
                }
                arrChuaItemLastTimeUpdate = arrChuaItemLastTimeUpdate.filter({ item in
                    item.name != myCurrentName
                })
                
                arrChuaItemLastTimeUpdate.forEach { mem in
                    print("\n")
                    print("member", mem)
                }
               
        }*/
       
        //========ADD LISTENNER======//
         registration =  store.collection(collectname).addSnapshotListener(includeMetadataChanges: false){ documentSnapshot, error in
            guard let snapshot = documentSnapshot else { return }
             
            let x1 =  snapshot.documentChanges
            .filter({ item in
                 //add ngăn chặn chọn vào chính mình 120s update add vi tri
                 (item.document.data()["name"] as! String) != myCurrentName//chổ này bị crash app khi name bị null
             })
             print("x1 COUNT", x1.count)
             
            let x2 = x1
                 .filter({ item in
                 //lọc theo timeStamp tất cả timeStamp khác nhỏ hơn timeStamp cũa user này sẽ lúc bật app lên - 17 phút sẽ bị lọc ra
                (item.document.data()["timeStamp"] as! Double) > thoiGianAppBatLen - 1000
             })
             print("x2 COUNT", x2.count)
             
             x2.forEach { (documentChange) in
                switch documentChange.type {
                  case .added :
                     print("documentChange .... Added")
                    //hiện tại thì user mới add data vitri hay status thi sẽ nhân đươc notification
                    //nhưng mới vao thi sẽ nhận tất cả các notifi cua user củ trước đó nữa
                    let dict = documentChange.document.data()
                    self.notifiWhenADD(title: "TourLink:  \(dict["name"] ?? "")", sub: dict["status"] as! String)
                    
                  case .modified :
                     print("documentChange .... Modified")
                    let dict = documentChange.document.data()
                    self.notifiWhenADD(title: "TourLink:  \(dict["name"] ?? "")", sub: dict["status"] as! String)
                    
                  case .removed :
                     print("documentChange .... removed")
                }
            }
        }
       
    }
    //=======UNWATCH====//
    func unwatch(collectname:String){
        print("UNWATCHING --> collection: " + collectname)
        registration?.remove()
    }
   
    //==========NOTIFICATION: FOR ADD DATA====//
    func notifiWhenADD(title:String, sub:String){
        
        //bắn notification local ra
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
                return
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = sub
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
    }
    
    
    
    
}//end class
