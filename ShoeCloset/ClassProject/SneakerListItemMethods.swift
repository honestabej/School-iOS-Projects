//
//  SneakerListItemMethods.swift
//  ClassProject
//
//  Created by Abe Johnson on 4/10/21.
//

import UIKit
import Foundation

class SneakerListItemMethods {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items = [SneakerListItem]()
    
    // Get all saved items
    func getAllItems() -> [SneakerListItem] {
        do {
            items = try context.fetch(SneakerListItem.fetchRequest())
        } catch {
            print("Error in getting core data")
        }
        return items
    }
    
    // Create an item
    func createItem(brand: String, name: String, purchasePrice: Double, retailPrice: Double, date: String, styleID: String, image: UIImage, mapLat: Double, mapLong: Double, mapName: String) {
        let newItem = SneakerListItem(context: context)
        newItem.brand = brand
        newItem.name = name
        newItem.purchasePrice = purchasePrice
        newItem.retailPrice = retailPrice
        newItem.date = date
        newItem.styleID = styleID
        let imageData: Data = image.pngData()!
        newItem.image = imageData
        newItem.mapLat = mapLat
        newItem.mapLong = mapLong
        newItem.mapName = mapName
        print("NewItem created")
        
        do {
            try context.save()
            print("NewItem Succesfully saved to context")
        } catch {
            print("Error Saving to Core Data")
        }
    }
    
    // Delete an item
    func deleteItem(item: SneakerListItem) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("Error Deleteing from Core Data")
        }
    }
    
    // Get the count of all items
    func getCount() -> Int {
        return items.count
    }
    
    // Get an item with known index
    func getSneakerItemAt(index: Int) -> SneakerListItem {
        return items[index]
    }
    
    // Get an item with a known name
    func getSneakerItemNamed(getName: String) -> (s: SneakerListItem, i: Int) {
        var index = 0
        if (items.count > 0) {
            for i in (0...items.count - 1) {
                if getName == items[i].name {
                    index = i
                    break
                }
            }
        }
        return (items[index], index)
    }
    
    // Set functions
    func setSneakerItemBrand(item: SneakerListItem, newBrand: String) {
        item.brand = newBrand
        do {
            try context.save()
        } catch {
            print("Error saving new brand to core data")
        }
    }
    
    func setSneakerItemName(item: SneakerListItem, newName: String) {
        item.name = newName
        do {
            try context.save()
        } catch {
            print("Error saving new name to core data")
        }
    }
    
    func setSneakerItemPurchasePrice(item: SneakerListItem, newPurchasePrice: Double) {
        item.purchasePrice = newPurchasePrice
        do {
            try context.save()
        } catch {
            print("Error saving new purchasePrice to core data")
        }
    }
    
    func setSneakerItemRetailPrice(item: SneakerListItem, newRetailPrice: Double) {
        item.retailPrice = newRetailPrice
        do {
            try context.save()
        } catch {
            print("Error saving new retailPrice to core data")
        }
    }
    
    func setSneakerItemDate(item: SneakerListItem, newDate: String) {
        item.date = newDate
        do {
            try context.save()
        } catch {
            print("Error saving new date to core data")
        }
    }
    
    func setSneakerItemStyleID(item: SneakerListItem, newStyleID: String) {
        item.styleID = newStyleID
        do {
            try context.save()
        } catch {
            print("Error saving new styleID to core data")
        }
    }
    
    func setSneakerItemImage(item: SneakerListItem, newImage: UIImage) {
        let imageData: Data = newImage.pngData()!
        item.image = imageData
        do {
            try context.save()
        } catch {
            print("Error saving new image to core data")
        }
    }
    
    func setSneakerItemMapInfo(item: SneakerListItem, newMapName: String, newMapLat: Double, newMapLong: Double) {
        item.mapName = newMapName
        item.mapLat = newMapLat
        item.mapLong = newMapLong
        do {
            try context.save()
        } catch {
            print("Error saving new map info to core data")
        }
    }
    
}
