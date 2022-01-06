//
//  DetailViewController.swift
//  ClassProject
//
//  Created by Abe Johnson on 4/6/21.
//

import Foundation
import UIKit
import MapKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    // UI Outlet variables
    @IBOutlet weak var sneakerImage: UIImageView!
    @IBOutlet weak var sneakerTitle: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var boughtFor: UILabel!
    @IBOutlet weak var retail: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var styleID: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var onlineMessage: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var editSearch: UIButton!
    @IBOutlet weak var editOnline: UIButton!
    @IBOutlet weak var editCancel: UIView!
    @IBOutlet weak var editConfirm: UIView!
    
    // Code variables
    var sneaker: SneakerListItem?
    let methods = SneakerListItemMethods()
    var selectedAnnotation: MKPointAnnotation?
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editTextField.delegate = self
        // Set visibilty of location editing UI items
        editTextField.isHidden = true
        editSearch.isHidden = true
        editOnline.isHidden = true
        editCancel.isHidden = true
        editConfirm.isHidden = true
        
        // Set default label values
        sneakerImage.image = UIImage(data: (sneaker?.image)!)
        if sneaker?.brand != nil {
            brand.text = "Brand: \(String((sneaker?.brand)!))"
        } else {
            brand.text = "Brand: --"
        }
        if sneaker?.purchasePrice != nil {
            boughtFor.text = "Bought for: $\(String((sneaker?.purchasePrice)!))"
        } else {
            boughtFor.text = "Bought for: $--"
        }
        if sneaker?.retailPrice != nil {
            retail.text = "Retail price: $\(String((sneaker?.retailPrice)!))"
        } else {
            retail.text = "Retail price: $--"
        }
        if sneaker?.date != nil {
            released.text = "Released: \(String((sneaker?.date)!))"
        } else {
            released.text = "Released: --"
        }
        if sneaker?.styleID != nil {
            styleID.text = "Style ID: \(String((sneaker?.styleID)!))"
        } else {
            styleID.text = "Style ID: --"
        }
        sneakerTitle.text = sneaker?.name
        
        print(sneaker?.mapName)
        
        // Check for online purchase status of sneaker
        if sneaker?.mapName != "Online Purchase" {
            // Make the annotation for the map from core data values
            let annotation = MKPointAnnotation()
            annotation.title = sneaker?.mapName
            annotation.coordinate = CLLocationCoordinate2DMake(Double(sneaker!.mapLat), Double(sneaker!.mapLong))
            // Hide onlineMessage label
            onlineMessage.isHidden = true
            // Remove any existing annotations
            let annotations = self.mapView.annotations
            self.mapView.removeAnnotations(annotations)
            // Add new annotation
            self.mapView.addAnnotation(annotation)
            // Set region for displaying map
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    // Edit Sneaker information
    @IBAction func editSneaker(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select information to edit", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Edit Name", style: .default, handler: { (action) in
            print("edit name")
            let nameAlert = UIAlertController(title: "Edit Name", message: nil, preferredStyle: .alert)
            nameAlert.addTextField { (textField) in textField.placeholder = "" }
            nameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            nameAlert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                if let newName = nameAlert.textFields?.first?.text {
                    self.methods.setSneakerItemName(item: self.sneaker!, newName: newName)
                    self.sneakerTitle.text = newName
                    print("sneaker name updated")
                } else {
                    print("Error editing name")
                }
            }))
            self.present(nameAlert, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Edit Price", style: .default, handler: { (action) in
            print("edit price")
            let priceAlert = UIAlertController(title: "Edit Price", message: nil, preferredStyle: .alert)
            priceAlert.addTextField { (textField) in textField.placeholder = "" }
            priceAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            priceAlert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                if let newPrice = priceAlert.textFields?.first?.text {
                    self.methods.setSneakerItemPurchasePrice(item: self.sneaker!, newPurchasePrice: Double((newPrice))!)
                    self.boughtFor.text = "Bought for: $\(newPrice)"
                    print("sneaker price updated")
                } else {
                    print("Error editing price")
                }
            }))
            self.present(priceAlert, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Edit Image", style: .default, handler: { (action) in
            print("edit image")
            let imgAlert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .alert)
            imgAlert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                print("photo library")
                self.photoLibrarySelected()
            }))
            imgAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                print("camera")
                self.cameraSelected()
            }))
            imgAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(imgAlert, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Edit Location", style: .default, handler: { (action) in
            print("edit location")
            self.editTextField.isHidden = false
            self.editSearch.isHidden = false
            self.editOnline.isHidden = false
            self.editCancel.isHidden = false
            self.editConfirm.isHidden = false
            self.onlineMessage.isHidden = true
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    // Implement Image Stuff Here
    // Edit image from photo library
    func photoLibrarySelected() {
        print("Image Selection Begins")
        let photoPicker = UIImagePickerController ()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        photoPicker.allowsEditing = true
        self.present(photoPicker, animated: true, completion: nil)
        print("Image Selection Complete")
    }
    
    // Edit image from camera
    func cameraSelected() {
        print("Image Selection Begins")
        let photoPicker = UIImagePickerController ()
        photoPicker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            photoPicker.sourceType = .camera
            photoPicker.allowsEditing = true
            self.present(photoPicker, animated: true, completion: nil)
            print("Image Selection Complete")
        } else {
            print("Error, cannot access camera in simulator")
        }
    }
    
    // UIImagePicker function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else {
            print("Error: No image found")
            return
        }

        sneakerImage.image = image
        print("Success: sneakerImage Set")
        self.methods.setSneakerItemImage(item: self.sneaker!, newImage: image)
        print("Success: Sneaker image updated")
    }
    
    // Implement Map Stuff Here
    // Search for location
    @IBAction func searchMap(_ sender: UIButton) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = editTextField.text
        searchRequest.region = mapView.region
        
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { response, _ in
            // Check for response
            guard let response = response else {
                return
            }
            // Create an array of matching items to the search
            let matchingItems = response.mapItems
            // Iterate through matching items and mark them on the map
            if (matchingItems.count > 1) {
                // remove current annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                // add new annotations
                for i in 1...matchingItems.count - 1 {
                    let place = matchingItems[i].placemark
                    let latitude = place.location?.coordinate.latitude
                    let longitude = place.location?.coordinate.longitude
                    let annotation = MKPointAnnotation()
                    annotation.title = place.name
                    annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                    self.mapView.addAnnotation(annotation)
                }
            } else {
                let error = UIAlertController(title: "Error", message: "Location not found", preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(error, animated: true)
            }
        }
    }
    
    // Get selected annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotation = view.annotation as? MKPointAnnotation
        print("Selected Annotation Set")
    }
    
    // Set the sneakers location to purchased online
    @IBAction func purchasedOnline(_ sender: UIButton) {
        // remove current annotations
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        // Update UI
        editTextField.isHidden = true
        editSearch.isHidden = true
        editOnline.isHidden = true
        editCancel.isHidden = true
        editConfirm.isHidden = true
        onlineMessage.isHidden = false
        
        // Update sneaker location
        self.methods.setSneakerItemMapInfo(item: self.sneaker!, newMapName: "Online Purchase", newMapLat: 0.0, newMapLong: 0.0)
    }
    
    // Cancel the edit function
    @IBAction func cancelLocationEdit(_ sender: UIButton) {
        // remove current annotations
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        // Set edit UI features back to hidden
        editTextField.isHidden = true
        editSearch.isHidden = true
        editOnline.isHidden = true
        editCancel.isHidden = true
        editConfirm.isHidden = true
        
        // Reset map to previous state
        if sneaker?.mapName != "Online Purchase" {
            // Make the annotation for the map from core data values
            let annotation = MKPointAnnotation()
            annotation.title = sneaker?.mapName
            annotation.coordinate = CLLocationCoordinate2DMake(Double(sneaker!.mapLat), Double(sneaker!.mapLong))
            // Hide onlineMessage label
            onlineMessage.isHidden = true
            // Add new annotation
            self.mapView.addAnnotation(annotation)
            // Set region for displaying map
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.mapView.setRegion(region, animated: true)
        } else {
            onlineMessage.isHidden = false
        }
    }
    
    // Edit/update the new location
    @IBAction func editLocation(_ sender: UIButton) {
        // Check for a selected location
        if selectedAnnotation == nil {
            let errorEditing = UIAlertController(title: "Please select a location!", message: nil, preferredStyle: .alert)
            errorEditing.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(errorEditing, animated: true)
        } else {
            // remove current annotations
            let annotations = self.mapView.annotations
            self.mapView.removeAnnotations(annotations)
            
            // Set edit UI features back to hidden
            editTextField.isHidden = true
            editSearch.isHidden = true
            editOnline.isHidden = true
            editCancel.isHidden = true
            editConfirm.isHidden = true
            
            // Edit the sneakers location and put it on the mapView
            self.methods.setSneakerItemMapInfo(item: self.sneaker!, newMapName: (selectedAnnotation?.title)!, newMapLat: Double((selectedAnnotation?.coordinate.latitude)!), newMapLong: Double((selectedAnnotation?.coordinate.longitude)!))
            self.mapView.addAnnotation(selectedAnnotation!)
        }
    }
    
    // Dismissing keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("activeTextField set as \(textField)")
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return activeTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
