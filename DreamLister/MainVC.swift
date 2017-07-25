//
//  MainVC.swift
//  DreamLister
//
//  Created by Mikołaj Skawiński on 23.07.2017.
//  Copyright © 2017 Mikołaj Skawiński. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    private enum SortType: Int, CustomStringConvertible {
        
        case Date = 0
        case Price
        case Title
        
        var description: String {
            switch  self {
            case .Date:
                return "created"
            case .Price:
                return "price"
            case .Title:
                return "title"
                
            }
        }
        
        var ascending: Bool {
            switch  self {
            case .Date:
                return false
            default:
                return true
            }
        }
        
        var selector: Selector {
            switch self {
            case .Date:
                return #selector(NSDate.compare(_:))
            case .Price:
                return #selector(NSNumber.compare(_:))
            case .Title:
                return #selector(NSString.caseInsensitiveCompare(_:))
                
            }
        }
    }
    
    // MARK: - Properties
    
    var fetchedResultController: NSFetchedResultsController<Item>!
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    
    // MARK: - VC's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // rgenerateTestData()
        attemptFetch()
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemCell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
        configureCell(cell: itemCell, indexPath: indexPath)
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func configureCell(cell: ItemTableViewCell, indexPath: IndexPath) {
        let item = fetchedResultController.object(at: indexPath)
        cell.configureCell(item: item)
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = fetchedResultController.fetchedObjects, !objs.isEmpty {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    // MARK: - Methods
    
    func generateTestData() {
        let item1 = Item(context: context)
        item1.title = "Macbook Pro 15\""
        item1.price = 4199
        item1.details = "3.1GHz quad-core processor,16GB RAM, 2TB SSD, Radeon Pro 560. Man That's beast."
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "But an, its so nice to be able to block out everyone with the noise cancelling "
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "Oh man this is a beautiful car. And one day I will own it."
        
        ad.saveContext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell
                configureCell(cell: cell, indexPath: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    private func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        let sortType = SortType(rawValue: segmentedControl.selectedSegmentIndex)!
        let sort = NSSortDescriptor(key: sortType.description, ascending: sortType.ascending, selector: sortType.selector)
        
        fetchRequest.sortDescriptors = [sort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Actions 
    
    @IBAction func segmentChange() {
        attemptFetch()
        tableView.reloadData()
    }
    
}

