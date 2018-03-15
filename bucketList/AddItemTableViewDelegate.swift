//
//  AddItemTableViewDelegate.swift
//  bucketList
//
//  Created by Josh Harsono on 3/12/18.
//  Copyright © 2018 Josh Harsono. All rights reserved.
//

import UIKit
import Foundation

//give two methods to the delegate. These come from the main ViewController and tell you which other view controllers can call these methods.
protocol AddItemTableViewControllerDelegate: class {
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?) //AddItemTableViewController can access this method and return parameters "text" and "indexPath"
    func cancelButtonPressed(by controller: AddItemTableViewController)
}
