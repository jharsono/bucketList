//
//  ViewController.swift
//  bucketList
//
//  Created by Josh Harsono on 3/12/18.
//  Copyright © 2018 Josh Harsono. All rights reserved.
//

import UIKit
import CoreData


class BucketListViewController: UITableViewController, AddItemTableViewControllerDelegate { //add the delegate to pass methods over to the AddItemTableViewController
    
    

    var items = [BucketListItem]() // bucketlistitem type from the datamodel
//    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // the scratchpad for our data which we will save to the database
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems() // run this function on load
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    } // how many rows to build, based off the number of items in the items array

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath)
            cell.textLabel?.text = items[indexPath.row].text!
            return cell
    
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)

    }
    //DELETE
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        managedObjectContext.delete(item)
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    //SEGUE TO ADD/EDIT
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
            
        } else if segue.identifier == "EditItemSegue" {
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
            
            let indexPath = sender as! NSIndexPath
            let item = items[indexPath.row]
            addItemTableViewController.item = item.text!
            addItemTableViewController.indexPath = indexPath
        }
//when the button is clicked to activate the segue, determine which segue is used. EditItemSegue will send the indexPath
    }
    
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItem") //define what you want to fetch
        do {
            let result = try managedObjectContext.fetch(request) //try fetching the objects
            items = result as! [BucketListItem]
        } catch {
            print("\(error)")
        }
    }
    
    func cancelButtonPressed(by controller: AddItemTableViewController) {
        print("hidden controller cancel button")
        dismiss(animated: true, completion: nil)
    }
    
    
    //SAVE ITEM
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?) { //item saved function, getting data from AddItemTableViewController, passing in data of "text" and the indexPath, which was sent from when you clicked the UIButton before going into the controller.

        if let ip = indexPath {
            let item = items[ip.row]
            item.text = text
        } else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: managedObjectContext) as! BucketListItem
                item.text = text
                items.append(item)
    }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)

    }

}
