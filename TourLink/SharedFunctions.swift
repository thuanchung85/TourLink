//
//  SharedFunctions.swift
//  TourLink
//
//  Created by Luong Thuan Chung on 07/03/2022.
//

import Foundation
import MapKit

//hàm tinh ra khoan cach toi dich den
func tinhKhoanCach(route:MKRoute) -> String {
    //tinh khoan cach bao nhieu km
    let distanceKM = (route.distance / 1000)
   
    if(distanceKM >= 1)
    {
        return "\(String(format: "%.1f", distanceKM)) Km"
    }
    else{
        return String(distanceKM * 1000) + " meter"
    }
}

//ham tinh ra so gio phut can den dich, van toc trung binh 50km/h
func tinhSoGio(distanceKM: Double, vanToc: Double = 50) -> String {
    //tinh thoi gian = quang duong / van toc (50km/h)
    let distanceKM = distanceKM / 1000
    let tinhsoGio = Int(distanceKM / 50)
    
    var tinhsoPhut = (distanceKM / 50) - Double(tinhsoGio)
    if tinhsoPhut < 1 && tinhsoPhut > 0
    {
        tinhsoPhut = tinhsoPhut * 60
    }
    return String(tinhsoGio)  + " h " + String(Int(round(tinhsoPhut))) + " m"
}

//convert timeStamp to time
func convertTimeStamp(timeResult:Double)->String{
    let date = Date(timeIntervalSince1970: timeResult)
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
    dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}

//hàm tạo 1 cuộc gọi bằng số phone
func makeACallPhone(numberString:String){
    let telephone = "tel://"
        let formattedString = telephone + numberString
        guard let url = URL(string: formattedString) else { return }
        UIApplication.shared.open(url)
}
