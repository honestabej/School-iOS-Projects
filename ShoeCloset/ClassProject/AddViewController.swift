//
//  AddViewController.swift
//  ClassProject
//
//  Created by Abe Johnson on 4/6/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    // UI outlet variables
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var retailField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var releasedField: UITextField!
    @IBOutlet weak var styleIDField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchLocation: UIButton!
    
    // Code variables
    // var addViewSneakerCloset:sneakers = sneakers()
    var items = [SneakerListItem]()
    var result: searchResult?
    var errorAdding: Bool?
    var addIndexPath: IndexPath?
    var selectedAnnotation: MKPointAnnotation?
    var fromBack: Bool?
    var removeDefault = false
    var manual: Bool?
    let locationManager = CLLocationManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let methods = SneakerListItemMethods()
    var activeTextField = UITextField()
    var region: MKCoordinateRegion?
    var once = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Request current location access
        self.locationManager.requestAlwaysAuthorization()
        once = 0
        
        // Set up TextField delegates
        self.brandField.delegate = self
        self.nameField.delegate = self
        self.retailField.delegate = self
        self.priceField.delegate = self
        self.releasedField.delegate = self
        self.styleIDField.delegate = self
        self.searchField.delegate = self
        
        if manual == false {
            brandField.text = result?.resBrand
            nameField.text = result?.resName
            retailField.text = String((result?.resRetail!)!)
            releasedField.text = result?.resReleased
            styleIDField.text = result?.resStyleID
            DispatchQueue.main.async {
                print(String(describing: (self.result?.resImageUrl)!))
                var imageUrl: UIImage! = UIImage(named: "Default Sneaker")
                if String(describing: (self.result?.resImageUrl)!) != "google.com" {
                    do {
                        // print("Image URL: \(String(describing: media["imageUrl"]))")
                        let data = try Data(contentsOf: (self.result?.resImageUrl)!)
                        imageUrl = UIImage(data: data)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                self.imageView.image = imageUrl
                print("Image Set")
            }
            
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        imageView.image = UIImage(named: "Default Sneaker")
        searchField.isHidden = true
        searchLocation.isHidden = true
//        mapView.setRegion(region!, animated: true)
        
        // Set default selectedAnnotation values that stay default if sneaker was bought online
        let defaultAnnotation = MKPointAnnotation()
        defaultAnnotation.title = "Online Purchase"
        defaultAnnotation.coordinate = CLLocationCoordinate2DMake(0.0, 0.0)
        selectedAnnotation = defaultAnnotation
        fromBack = true
        print("AddViewController Loaded")
    }
    
    // Implement Image Stuff Here
    // Add image from photo library button
    @IBAction func selectImage(_ sender: UIButton) {
        print("Image Selection Begins")
        let photoPicker = UIImagePickerController ()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        photoPicker.allowsEditing = true
        self.present(photoPicker, animated: true, completion: nil)
        print("Image Selection Complete")
    }
    
    // Take picture button
    @IBAction func takePhoto(_ sender: UIButton) {
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

        imageView.image = image
        print("Success: ImageView Set")
    }
    
    // Implement map stuff here
    // Toggle showing search bar button
    @IBAction func showSearch(_ sender: UIButton) {
        if searchField.isHidden == true {
            searchField.isHidden = false
            searchLocation.isHidden = false
        } else {
            searchField.isHidden = true
            searchField.isHidden = true
        }
    }
    
    // Search for location
    @IBAction func searchMap(_ sender: UIButton) {
        activeTextField.resignFirstResponder()
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchField.text
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
        searchField.isHidden = true
        searchLocation.isHidden = true
    }
    
    // Get selected annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotation = view.annotation as? MKPointAnnotation
        print("Selected Annotation Set")
    }
    
    // Delegate method for current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if once < 1 {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            mapView.mapType = MKMapType.standard
            self.region = MKCoordinateRegion(center: locValue, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region!, animated: true)
            print("Region Set")
            once += 1
        }
    }
    
    // Add the sneaker to the collection if all fields are filled out
    @IBAction func addToCollection(_ sender: UIButton) {
        if (self.brandField.text == "" || self.nameField!.text == "" || self.retailField.text == "" || self.priceField!.text == "" || self.releasedField.text == "" || self.styleIDField.text == "" || self.imageView.image == nil) {
            errorAdding = true
            let alert = UIAlertController(title: "Input Error", message: "Please fill out all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            print("Problem Adding Sneaker")
        } else {
            self.methods.createItem(brand: self.brandField.text!, name: self.nameField.text!, purchasePrice: Double(self.priceField!.text!)!, retailPrice: Double(self.retailField.text!)!, date: self.releasedField.text!, styleID: self.styleIDField.text!, image: self.imageView.image!, mapLat: (selectedAnnotation?.coordinate.latitude)!, mapLong: (selectedAnnotation?.coordinate.longitude)!, mapName: (selectedAnnotation?.title)!)
            addIndexPath = IndexPath(row: items.count, section: 0)
            errorAdding = false
            print(String(selectedAnnotation?.title ?? "No Value"))
            print("Sneaker Added To Collection")
            self.fromBack = false
            performSegue(withIdentifier: "unwindSegue", sender: self)
        }
    }
    
    // Handle unwindSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindSegue" {
            
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
