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
    
    // MARK: - VC's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        let store = Store(context: context)
        store.name = "Frys Electronics"
        let store1 = Store(context: context)
        store1.name = "Amazon"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        let store3 = Store(context: context)
        store3.name = "Best Buy"
        let store4 = Store(context: context)
        store4.name = "K Mart"
        let store5 = Store(context: context)
        store5.name = "Target"
        
        ad.saveContext()
        
        getStores()
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
    
}
