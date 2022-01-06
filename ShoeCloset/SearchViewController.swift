//
//  SearchViewController.swift
//  ClassProject
//
//  Created by Abe Johnson on 4/10/21.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    // UI Outlet variables
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var addManually: UIButton!
    @IBOutlet weak var testImage: UIImageView!
    
    // Code Variables
    // var searchViewSneakerCloset: sneakers = sneakers()
    let headers = [
        "x-rapidapi-key": "63654628c1mshcacb20f48cacdd5p1ca34cjsn2ed9e823faa6",
        "x-rapidapi-host": "v1-sneakers.p.rapidapi.com"
    ]
    var items = [SneakerListItem]()
    var returnedResults: searchResults = searchResults()
    var selectedResult: searchResult?
    var manually: Bool?
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchField.delegate = self
    }
    
    // Perform JSON Query
    // Get results and update table
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        activeTextField.resignFirstResponder()
        // Remove current table elemtns to make room for new search
        returnedResults.clearAll()
        searchTable.reloadData()
        // Perform JSON Query
        let orig = searchField.text
        let new: String = orig!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("API URL Searched: https://v1-sneakers.p.rapidapi.com/v1/sneakers?limit=10&name=\(new)")
        getData(from: "https://v1-sneakers.p.rapidapi.com/v1/sneakers?limit=10&name=\(new)")
    }
    
    // Implement JSON API request here
    func getData(from url: String) {
        if searchField.text != "" {
            
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            // Start URLSession
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                var err: NSError?
                let jsonResult = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                if err != nil {
                    print(err?.localizedDescription as Any)
                }
                
                if let sneakerArr = jsonResult["results"] as? NSArray {
                    // Set labels appropriately
                    DispatchQueue.main.async {
                        for i in 0...(sneakerArr.count - 1) {
                            var brand = ""; var title = ""; var retailPrice = 0.0; var releaseDate = ""; var styleId = ""
                            let sneakerResult = sneakerArr[i] as? [String: AnyObject]
                            if String(describing: sneakerResult!["brand"]!) != "<null>" {
                                brand = sneakerResult!["brand"]! as! String
                            }
                            if String(describing: sneakerResult!["title"]!) != "<null>" {
                                title = sneakerResult!["title"]! as! String
                            }
                            if String(describing: sneakerResult!["retailPrice"]!) != "<null>" {
                                retailPrice = sneakerResult!["retailPrice"]! as! Double
                            }
                            if String(describing: sneakerResult!["releaseDate"]!) != "<null>" {
                                releaseDate = sneakerResult!["releaseDate"]! as! String
                            }
                            if String(describing: sneakerResult!["styleId"]!) != "<null>" {
                                styleId = sneakerResult!["styleId"]! as! String
                            }
                            let media = sneakerResult!["media"]! as! NSDictionary
                            var imageUrl: UIImage! = UIImage(named: "Default Sneaker")
                            var toUrl: URL = URL(string: "google.com")!
                            if String(describing: media["imageUrl"]) != "Optional(<null>)" {
                                do {
                                    // print("Image URL: \(String(describing: media["imageUrl"]))")
                                    toUrl = URL(string: String((media["imageUrl"] as! String)))!
                                    let data = try Data(contentsOf: toUrl)
                                    imageUrl = UIImage(data: data)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            self.returnedResults.addResult(addBrand: brand, addName: title, addRetail: retailPrice, addReleased: releaseDate, addStyleID: styleId, addImage: imageUrl!, addURL: toUrl)
                            let indexPath = IndexPath(row: i, section: 0)
                            self.searchTable.beginUpdates()
                            self.searchTable.insertRows(at: [indexPath], with: .automatic)
                            self.searchTable.endUpdates()
                        }
                    }
                    print("JSON Query successful")
                }
                
            }).resume()
        } else {
            let error = UIAlertController(title: "Error", message: "Please enter a sneaker to search for", preferredStyle: .alert)
            error.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(error, animated: true)
        }
    }
    
    // Add the sneaker manually
    @IBAction func addManuallyPressed(_ sender: UIButton) {
        manually = true
        performSegue(withIdentifier: "toAddView", sender: self)
    }
    
    // Segue handling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAddView") {
            if let addView: AddViewController = segue.destination as? AddViewController {
                addView.items = self.items
                if manually == false {
                    addView.manual = self.manually
                    addView.result = selectedResult
                }
            }
            print("Segue to AddViewController Complete")
        }
    }
    
    @IBAction func unwindToSearchView(segue: UIStoryboardSegue) {
        if let source = segue.source as? AddViewController {
           
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Creates the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: "Search Result Cell", for: indexPath) as! SearchResultCellView
        cell.layer.borderWidth = 1.0
        
        // Get result object from model
        let result = returnedResults.getResultAt(index: indexPath.row)
        cell.resultBrand.text = "Brand: \(String(result.resBrand!))"
        cell.resultName.text = "Name: \(String(result.resName!))"
        cell.resultPrice.text = "Retail Price: \(String(result.resRetail!))"
        cell.resultReleased.text = "Released: \(String(result.resReleased!))"
        cell.resultStyleID.text = "Style ID: \(String(result.resStyleID!))"
        cell.resultImage.image = result.resImage
        
        return cell
    }
    
    // Setting the number of sections in the table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set the title of the header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Results"
    }
    
    // Setting the amount of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnedResults.getCount()
    }
    
    // Setting the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    // Is called whenever a cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = returnedResults.getResultAt(index: indexPath.row)
        selectedResult = result
        print("\(String(describing: result.resName))'s cell tapped")
        manually = false
        performSegue(withIdentifier: "toAddView", sender: self)
    }
}

