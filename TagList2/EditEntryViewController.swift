//
//  EditEntryViewController.swift
//  TagList2
//
//  Created by mac on 2017/3/12.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class EditEntryViewController: UIViewController {
    
    var entryTitle: String? = nil
    var entryId: Int? = nil
    
    @IBOutlet weak var entryTitleTextbox: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entryTitle = entryTitle {
            entryTitleTextbox.text = entryTitle
        }
        
        cancelButton.isEnabled = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onStart(_ sender: Any) {
        cancelButton.isEnabled = true
    }
    
    @IBAction func onCancelEdit(_ sender: Any) {
        entryTitleTextbox.text = entryTitle
        entryTitleTextbox.resignFirstResponder()
        cancelButton.isEnabled = false
    }
    
    @IBAction func onFinishEditTitle(_ sender: Any) {
        if entryTitleTextbox.text == "" || entryTitleTextbox.text == nil {
            onCancelEdit(sender)
            return
        }
        entryTitle = entryTitleTextbox.text
        entryTitleTextbox.resignFirstResponder()
        cancelButton.isEnabled = false
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
