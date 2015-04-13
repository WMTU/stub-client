//
//  SettingsController.swift
//  Stub
//
//  Created by Neil Betham on 4/13/15.
//  Copyright (c) 2015 WMTU. All rights reserved.
//

import Cocoa
import Alamofire

class SettingsController: NSViewController {
    @IBOutlet weak var server_text: NSTextField!
    var settings:NSUserDefaults!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings = NSUserDefaults.standardUserDefaults()
        appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        
        server_text.stringValue = appDelegate!.host
    }
    
    override func viewDidDisappear() {
        self
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func server_box(sender: NSTextField) {
        println(sender.stringValue)
        update_server_settings(sender)
    }
    
    @IBAction func close_sheet(sender: AnyObject) {
        update_server_settings(server_text)
    }
    
    func update_server_settings(text_field:NSTextField){
        appDelegate.host = text_field.stringValue
        settings.setObject(text_field.stringValue, forKey: "host")
        dismissViewController(self)
    }
}

