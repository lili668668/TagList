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
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var entryList = [entry] ()
    var startHeight: Int = 10
    var startWidth: Int = 20
    var intervalHeight: Int = 30
    var intervalWidth:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.entryListView.delegate = self
        self.entryListView.dataSource = self
        
        selectEntries()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectEntries() {
        if delegate.db != nil {
            let sql = "SELECT id, entry, is_finish FROM tag_list ORDER BY id;"
            var res: OpaquePointer? = nil
            
            if sqlite3_prepare(delegate.db, sql, -1, &res, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("prepare error \(errmsg)")
            }
            
            while sqlite3_step(res) == SQLITE_ROW {
                let one = entry()
                let id = sqlite3_column_int(res, 0)
                let content = sqlite3_column_text(res, 1)
                //let is_finish = sqlite3_column_text(res, 2)
                
                    
                if content != nil {
                    one.content = String(cString: content!)
                    entryList.insert(one, at: Int(id))
                }
            }
            
            sqlite3_finalize(res)
            entryListView.reloadData()
        }
    }
    
    func insertEntry(_ id: Int, _ entry: String) {
        if delegate.db != nil {
            let entry_c = entry.cString(using: .utf8)
            let sql = "INSERT INTO tag_list(id, entry) VALUES(?, ?);"
            var res: OpaquePointer? = nil
            
            if sqlite3_prepare(delegate.db, sql, -1, &res, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("prepare error \(errmsg)")
            }
            
            if sqlite3_bind_int(res, 1, Int32(id)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("bind error \(errmsg)")
            }
            
            if sqlite3_bind_text(res, 2, entry_c, -1, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("bind error \(errmsg)")
            }
            
            if sqlite3_step(res) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("insert error \(errmsg)")
            }
            sqlite3_finalize(res)
        }
    }
    
    func updateEntry(_ id: Int, _ entry: String) {
        if delegate.db != nil {
            let entry_c = entry.cString(using: .utf8)
            let sql = "UPDATE tag_list SET entry=? WHERE id=?;"
            var res: OpaquePointer? = nil
            
            if sqlite3_prepare(delegate.db, sql, -1, &res, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("prepare error \(errmsg)")
            }
            
            if sqlite3_bind_text(res, 1, entry_c, -1, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("bind error \(errmsg)")
            }
            
            if sqlite3_bind_int(res, 2, Int32(id)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("bind error \(errmsg)")
            }
            
            if sqlite3_step(res) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("insert error \(errmsg)")
            }
            sqlite3_finalize(res)
        }
    }
    
    func deleteEntry(_ id: Int) {
        if delegate.db != nil {
            let sql = "DELETE FROM tag_list WHERE id=?"
            var res: OpaquePointer? = nil
            
            if sqlite3_prepare(delegate.db, sql, -1, &res, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("prepare error \(errmsg)")
            }
            
            if sqlite3_bind_int(res, 1, Int32(id)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("bind error \(errmsg)")
            }
            
            if sqlite3_step(res) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(delegate.db))
                print("insert error \(errmsg)")
            }
            sqlite3_finalize(res)
        }
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

        let one: entry = entry()
        one.content = newEntryTextbox.text!
        
        entryList.append(one)
        entryListView.reloadData()
        insertEntry(entryList.count - 1, one.content)
        
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
        entry.textLabel?.text = entryList[indexPath.row].content
        return entry
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmp = entryList[sourceIndexPath.row]
        entryList.remove(at: sourceIndexPath.row)
        entryList.insert(tmp, at: destinationIndexPath.row)
        
        for cnt in 0 ... entryList.count {
            let one: entry = entryList[cnt]
            updateEntry(cnt, one.content)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        entryList.remove(at: indexPath.row)
        entryListView.deleteRows(at: [indexPath], with: .automatic)
        deleteEntry(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "刪除"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEntry" {
            let vc: EditEntryViewController = segue.destination as! EditEntryViewController
            vc.entryId = entryListView.indexPathForSelectedRow?.row
            vc.entryTitle = entryList[(entryListView.indexPathForSelectedRow?.row)!].content
        }
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "EditEntryBack" {
            let vc: EditEntryViewController = unwindSegue.source as! EditEntryViewController
            let one: entry = entry()
            one.content = vc.entryTitle!
            entryList[vc.entryId!] = one
            entryListView.reloadData()
            updateEntry(vc.entryId!, one.content)
        }
    }


}

