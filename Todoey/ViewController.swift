//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var todoeyTableView: UITableView!
    
    var array = [Item]()
    //let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath)
//
//        let newItem1 = Item()
//        newItem1.title = "kucing"
//        array.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "Anjing"
//        array.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Kuda"
//        array.append(newItem3)
//        //        if let items = defaults.array(forKey: "toDoListArray") as? [String] {
//        //            array = items
        
        loadItem()
    }
    
    @IBAction func addNewItemBtn(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.array.append(newItem)
            
            self.saveItem()
            
            //            self.defaults.set(self.array, forKey: "toDoListArray")
            
            
            self.todoeyTableView.reloadData()
            
        }
        alert.addTextField { (alertTexField) in
            alertTexField.placeholder = "Create New Item"
            textField = alertTexField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem(){
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(array)
            try data.write(to: dataFilePath!)
        } catch {
            print("eror encoding data aray \(error)")
        }
        
        self.todoeyTableView.reloadData()
        
    }
    
    func loadItem() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                array = try decoder.decode([Item].self, from: data)
            } catch {
                print("eror")
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoeyTableViewCell", for: indexPath) as! todoeyTableViewCell
        let item = array[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.status == true ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveItem()
        
        array[indexPath.row].status = !array[indexPath.row].status
        tableView.deselectRow(at: indexPath, animated: true)
        //
        //        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        //
        //
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

