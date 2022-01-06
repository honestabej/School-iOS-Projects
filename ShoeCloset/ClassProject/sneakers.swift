//
//  sneakers.swift
//  ClassProject
//
//  Created by Abe Johnson on 4/6/21.
//

import Foundation
import UIKit
import MapKit

class sneakers {
    
    var sneakers:[sneaker] = []
    
    func addSneaker(addBrand: String, addName: String, addPurchasePrice: Double, addRetailPrice: Double, addDate: String, addStyleID: String, addImage: UIImage, addMap: MKPointAnnotation) {
        let s = sneaker(b: addBrand, n: addName, p: addPurchasePrice, r: addRetailPrice, d: addDate, s: addStyleID, i: addImage, m: addMap)
        sneakers.append(s)
    }
    
    func getCount() -> Int {
        return sneakers.count
    }
    
    func getSneakerAt(index: Int) -> sneaker {
        return sneakers[index]
    }
    
    func getSneakerNamed(getName: String) -> (s: sneaker, i: Int) {
        var index = 0
        if (sneakers.count > 0) {
            for i in (0...sneakers.count - 1) {
                if getName == sneakers[i].name {
                    index = i
                    break
                }
            }
        }
        return (sneakers[index], index)
    }
    
    func removeSneakerAt(index: Int) {
        sneakers.remove(at: index)
    }
    
    func setSneakerAtBrand(index: Int, setBrand: String) {
        sneakers[index].brand = setBrand
    }
    
    func setSneakerAtName(index: Int, setName: String) {
        sneakers[index].name = setName
    }
    
    func setSneakerAtPurchasePrice(index: Int, setPurchasePrice: Double) {
        sneakers[index].purchasePrice = setPurchasePrice
    }
    
    func setSneakerAtRetailPrice(index: Int, setRetailPrice: Double) {
        sneakers[index].retailPrice = setRetailPrice
    }
    
    func setSneakerAtDate(index: Int, setDate: String) {
        sneakers[index].date = setDate
    }
    
    func setSneakerAtStyleID(index: Int, setStyleID: String) {
        sneakers[index].styleID = setStyleID
    }
    
    func setSneakerAtImage(index: Int, setImage: UIImage) {
        sneakers[index].image = setImage
    }
    
    func setSneakerAtLocation(index: Int, setMap: MKPointAnnotation) {
        sneakers[index].map = setMap
    }
    
}

class sneaker {
    var brand: String?
    var name: String?
    var purchasePrice: Double?
    var retailPrice: Double?
    var date: String?
    var styleID: String?
    var image: UIImage?
    var map: MKPointAnnotation?
    
    init (b: String, n: String, p: Double, r: Double, d: String, s: String, i: UIImage, m: MKPointAnnotation) {
        brand = b
        name = n
        purchasePrice = p
        retailPrice = r
        date = d
        styleID = s
        image = i
        map = m
    }
}
