//
//  searchResult.swift
//  ClassProject
//
//  Created by Abe Johnson on 4/10/21.
//

import Foundation
import UIKit

class searchResults {
    
    var results:[searchResult] = []
    
    func addResult(addBrand: String, addName: String, addRetail: Double, addReleased: String, addStyleID: String, addImage: UIImage, addURL: URL) {
        let r = searchResult(b: addBrand, n: addName, ret: addRetail, rel: addReleased, s: addStyleID, i: addImage, u: addURL)
        results.append(r)
    }
    
    func getCount() -> Int {
        return results.count
    }
    
    func getResultAt(index: Int) -> searchResult {
        return results[index]
    }
    
    func clearAll() {
        results.removeAll()
    }
}

class searchResult {
    var resBrand: String?
    var resName: String?
    var resRetail: Double?
    var resReleased: String?
    var resStyleID: String?
    var resImage: UIImage?
    var resImageUrl: URL?
    
    init (b: String, n: String, ret: Double, rel: String, s: String, i: UIImage, u: URL) {
        resBrand = b
        resName = n
        resRetail = ret
        resReleased = rel
        resStyleID = s
        resImage = i
        resImageUrl = u
    }
}
