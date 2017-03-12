//
//  ViewController.swift
//  TagList2
//
//  Created by mac on 2017/3/11.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newEntryTextbox: UITextField!
    @IBOutlet weak var entryListView: UITableView!
    
    
    var entryList = [String] ()
    var startHeight: Int = 10
    var startWidth: Int = 20
    var intervalHeight: Int = 30
    var intervalWidth:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.entryListView.delegate = self
        self.entryListView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDismissNewEntry(_ sender: Any) {
        onClickAddEntry(sender)
        (sender as! UITextField).resignFirstResponder()
    }
    
    @IBAction func onClickEdit(_ sender: UIButton) {
        
        if (entryListView.isEditing) {
            entryListView.isEditing = false
           
            sender.setTitle("編輯", for: UIControlState.normal)
        } else {
            entryListView.isEditing = true
            
            sender.setTitle("檢視", for: UIControlState.normal)
        }
        
    }
    
    
    @IBAction func onClickAddEntry(_ sender: Any) {
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(finishEntry(_:)))
        
        if newEntryTextbox.text == "" || newEntryTextbox.text == nil {
            return
        }

        entryList.append(newEntryTextbox.text!)
        entryListView.reloadData()
        
        newEntryTextbox.text = ""
    }
    
    func finishEntry(_ sender: UITapGestureRecognizer) {
        let label = sender.view as? UILabel
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: label!.text!)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        label?.attributedText = attributeString
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = tableView.dequeueReusableCell(withIdentifier: "Entry", for: indexPath)
        entry.textLabel?.text = entryList[indexPath.row]
        return entry
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmp = entryList[sourceIndexPath.row]
        entryList.remove(at: sourceIndexPath.row)
        entryList.insert(tmp, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        entryList.remove(at: indexPath.row)
        entryListView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "刪除"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEntry" {
            let vc: EditEntryViewController = segue.destination as! EditEntryViewController
            vc.entryId = entryListView.indexPathForSelectedRow?.row
            vc.entryTitle = entryList[(entryListView.indexPathForSelectedRow?.row)!]
        }
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "EditEntryBack" {
            let vc: EditEntryViewController = unwindSegue.source as! EditEntryViewController
            entryList[vc.entryId!] = vc.entryTitle!
            entryListView.reloadData()
        }
    }


}

