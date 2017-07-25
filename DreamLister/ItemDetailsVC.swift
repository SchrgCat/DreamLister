//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Mikołaj Skawiński on 24.07.2017.
//  Copyright © 2017 Mikołaj Skawiński. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    // MItemTableViewCellARK: - Properties
    
    var stores = [Store]()
    var itemToEdit: Item?
    
    // MARK: - VC's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
//        let store = Store(context: context)
//        store.name = "Frys Electronics"
//        let store1 = Store(context: context)
//        store1.name = "Amazon"
//        let store2 = Store(context: context)
//        store2.name = "Tesla Dealership"
//        let store3 = Store(context: context)
//        store3.name = "Best Buy"
//        let store4 = Store(context: context)
//        store4.name = "K Mart"
//        let store5 = Store(context: context)
//        store5.name = "Target"
//        
//        ad.saveContext()
        
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    // MARK: - Picker View Data Source
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: - Picker View Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let  store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    // MARK: - Methods
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            print(error)
        }
    }
    
    func loadItemData() {
        let item = itemToEdit!
        titleField.text = item.title
        priceField.text = "\(item.price)"
        detailsField.text = item.details
        
        if let store = item.toStore {
            if let index = stores.index(of: store) {
                storePicker.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func savePressed() {
        let item = itemToEdit != nil ? itemToEdit! : Item(context: context)
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text, price.isValidPrice {
            item.price = (price as NSString).doubleValue
        } else {
            priceField.layer.borderWidth = 1.0
            priceField.layer.borderColor = UIColor.red.cgColor
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
