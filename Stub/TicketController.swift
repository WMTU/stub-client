//
//  TicketController.swift
//  Stub
//
//  Created by Neil Betham on 4/12/15.
//  Copyright (c) 2015 WMTU. All rights reserved.
//

import Cocoa
import Alamofire

class TicketController: NSViewController {
    @IBOutlet weak var token_field: NSTextFieldCell!
    @IBOutlet weak var printer_select: NSPopUpButton!
    @IBOutlet weak var spinner: NSProgressIndicator!
    
    var manager = Alamofire.Manager(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var appDelegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = (NSApplication.sharedApplication().delegate as! AppDelegate)
        
        // Setup auth token
        token_field.title = appDelegate!.token
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": "Token token=" + appDelegate!.token
        ]
        
        // Get available printers
        let task = NSTask()
        task.launchPath = "/usr/bin/lpstat"
        task.arguments = ["-p"]
        let pipe = NSPipe()
        task.standardOutput = pipe
        
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: NSUTF8StringEncoding)
        let lines = output!.componentsSeparatedByString("\n")
        
        printer_select.removeAllItems()
        
        for line in lines {
            var tokens:Array = line.componentsSeparatedByString(" ")
            if tokens.count > 2 {
                printer_select.addItemWithTitle(tokens[1] as! String)
            }
        }
        
    }
    
    override func viewDidDisappear() {
        self
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func print_dj(sender: AnyObject) {
        spinner.hidden = false
        spinner.startAnimation(self)
        manager.request(.POST, appDelegate!.host + "/api/tickets/dj")
        .responseString { (_, _, string, _) in
            self.spinner.hidden = true
            self.spinner.stopAnimation(self)
            self.print_label(string!)
        }
        
    }

    @IBAction func print_both(sender: AnyObject) {
        spinner.hidden = false
        spinner.startAnimation(self)
        manager.request(.POST, appDelegate!.host + "/api/tickets/both")
        .responseString { (_, _, string, _) in
            self.spinner.hidden = true
            self.spinner.stopAnimation(self)
            self.print_label(string!)
        }
    }
    
    @IBAction func print_band(sender: AnyObject) {
        spinner.hidden = false
        spinner.startAnimation(self)
        manager.request(.POST, appDelegate!.host + "/api/tickets/band")
        .responseString { (_, _, string, _) in
            self.spinner.hidden = true
            self.spinner.stopAnimation(self)
            self.print_label(string!)
        }
    }
    
    func print_label(zpl: String){
        let input_pipe = NSPipe()
        
        let task = NSTask()
        task.launchPath = "/usr/bin/lpr"
        task.arguments = ["-P", printer_select.selectedItem!.title, "-o", "raw"]
        task.standardInput = input_pipe
        
        task.launch()
        
        input_pipe.fileHandleForWriting.writeData(zpl.dataUsingEncoding(NSUTF8StringEncoding)!)
        input_pipe.fileHandleForWriting.closeFile()
    }
}

