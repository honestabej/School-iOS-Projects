//
//  ViewController.swift
//  ClassProject
//
//  Created by Abe Johnson on 3/15/21.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    // UI outlet variables
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // Code variables
    // var sneakerCloset:sneakers = sneakers()
    var items = [SneakerListItem]()
    var selectedSneaker: SneakerListItem?
    var removeDefault: Bool?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let methods = SneakerListItemMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        items = self.methods.getAllItems()
        self.updateRecent()
    }
        
    // Adding sneaker button
    @IBAction func addSneaker(_ sender: UIButton) {
        print("Add Sneaker button pressed")
        performSegue(withIdentifier: "toSearchView", sender: self)
    }
    
    // Segue handling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSearchView") {
            if let searchView: SearchViewController = segue.destination as? SearchViewController {
                searchView.items = self.items
            }
            print("Segue to SearchViewController Complete")
        } else if (segue.identifier == "toDetailView") {
            if let detailView: DetailViewController = segue.destination as? DetailViewController {
                detailView.sneaker = selectedSneaker
            }
            print("Segue to DetailViewController Complete")
        }
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        if let source = segue.source as? AddViewController {
            if source.fromBack == false {
                DispatchQueue.main.async {
                    self.items = self.methods.getAllItems()
                    print("Sneaker Closet Count: \(self.items.count)")
                    self.updateRecent()
                    let indexPath = IndexPath(row: self.items.count - 1, section: 0)
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                }
            }
            self.tableView.reloadData()
            print("Unwound from AddViewController")
        } else if let source = segue.source as? DetailViewController {
            self.tableView.reloadData()
            self.updateRecent()
            print("Unwound from DetailViewController")
        }
    }
    
    func updateRecent() {
        if self.methods.getCount() > 0 {
            self.mainImage.image = UIImage(data: items[self.methods.getCount() - 1].image!)
            self.mainName.text = items[self.methods.getCount() - 1].name
        } else {
            self.mainImage.image = UIImage(named: "Default Sneaker")
            self.mainName.text = "No Sneakers In Collection"
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Creates the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Sneaker Cell", for: indexPath) as! SneakerCellView
        cell.layer.borderWidth = 1.0
        
        // get the sneaker object from the model
        let sneakerObj = items[indexPath.row]
        cell.sneakerName.text = sneakerObj.name
        cell.sneakerImage.image = UIImage(data: sneakerObj.image!)
        
        print("Cell created")
        return cell
    }
    
    // Setting the number of sections in the table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set the title of the header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sneaker Closet"
    }
    
    // Setting the amount of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection Called: \(items.count)")
        return items.count
    }
    
    // Setting the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Is called whenever a cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sneakerObj = items[indexPath.row]
        selectedSneaker = sneakerObj
        print("\(String(describing: sneakerObj.name))'s cell tapped")
        performSegue(withIdentifier: "toDetailView", sender: self)
    }
    
    // Delete a cell in the table
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle { return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // delete data from sneaker table,
        DispatchQueue.main.async {
            self.methods.deleteItem(item: self.items[indexPath.row])
            self.items = self.methods.getAllItems()
            self.updateRecent()
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

