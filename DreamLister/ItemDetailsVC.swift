//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Mikołaj Skawiński on 24.07.2017.
//  Copyright © 2017 Mikołaj Skawiński. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Enumerations
    
    private enum ItemTypeEnum: String {
        case Cars
        case Electronics
        case Books
        case Other
        
        
        static var count = 4
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    
    // MItemTableViewCellARK: - Properties
    
    var stores = [Store]()
    var types = [ItemType]()
    var itemToEdit: Item?
    var imagePicker = UIImagePickerController()
    
    // MARK: - VC's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        imagePicker.delegate = self
        

        
        getStores()
        getTypes()
        
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
    
    // MARK: - Image Picker Controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            stores = try context.fetch(fetchRequest)
            if stores.isEmpty {
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
                self.stores += [store, store1, store2, store3, store4, store5]
            }
            
            storePicker.reloadAllComponents()
        } catch {
            print(error)
        }
    }
    
    func getTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.types = try context.fetch(fetchRequest)
            if self.types.isEmpty {
                let type1 = ItemType(context: context)
                type1.type = "Cars"
                let type2 = ItemType(context: context)
                type2.type = "Books"
                let type3 = ItemType(context: context)
                type3.type = "Electronics"
                let type4 = ItemType(context: context)
                type4.type = "Other"
                
                ad.saveContext()
                self.types += [type1, type2, type3, type4]
            }
            for i in 0..<ItemTypeEnum.count {
                typeSegmentedControl.setTitle(types[i].type, forSegmentAt: i)
            }
        } catch {
            print(error)
        }

    }
    
    func loadItemData() {
        let item = itemToEdit!
        titleField.text = item.title
        priceField.text = "\(item.price)"
        detailsField.text = item.details
        thumbImg.image = item.toImage?.image as? UIImage
        
        if let store = item.toStore {
            if let index = stores.index(of: store) {
                storePicker.selectRow(index, inComponent: 0, animated: true)
            }
        }
        
        if let type = item.toItemType?.type {
            if let index = types.index(where: {$0.type == type}) {
                typeSegmentedControl.selectedSegmentIndex = index
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func savePressed() {
        let item = itemToEdit != nil ? itemToEdit! : Item(context: context)
        
        let picture = Image(context: context)
        picture.image = thumbImg.image
        item.toImage = picture
        
        item.toItemType = types[typeSegmentedControl.selectedSegmentIndex]
        
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
    
    @IBAction func changeImage() {
        present(imagePicker, animated: true, completion: nil)
    }
}
