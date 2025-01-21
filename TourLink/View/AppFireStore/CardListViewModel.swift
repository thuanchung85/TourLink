//
//  CardListViewModel.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 12/09/2024.
//
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
// 1
import Combine

// 2
class CardListViewModel: ObservableObject
{
 
    @Published var cardRepository = CardRepository()

    
    //=====ADD======//
    func add(_ card: Card, collectname:String) {
        if (!card.pass.isEmpty) && (card.latitude != 0) && (card.longitude != 0) && (!card.userPhone.isEmpty) {
            cardRepository.add(card, collectname: collectname)
        }
    }
    
    //=====GET========//
    func get( collectname:String, completionHandler:  @escaping ([Card]) -> Void)  {
        
       
        cardRepository.get(collectname: collectname, completionHandler: {datas in
            completionHandler(datas)
        })
     
    }
    
    //=====DELETE=====//
    func delete() ->String{
      return   cardRepository.delete()
    }
    
    //====WATCH=======//
    func watch(collectname:String) {
         cardRepository.watch(collectname: collectname )
    }
    func unWatch(collectname:String){
        cardRepository.unwatch(collectname: collectname )
    }
}
