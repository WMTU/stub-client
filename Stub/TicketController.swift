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
    
    var manager = Alamofire.Manager()
    var auth_headers = [String : String]()
    var appDelegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = (NSApplication.sharedApplication().delegate as! AppDelegate)
        
        // Trim protocol from hostname
        var hostname = appDelegate!.host
        hostname = hostname.stringByReplacingOccurrencesOfString("https://", withString: "")
        hostname = hostname.stringByReplacingOccurrencesOfString("http://", withString: "")
        
        // Setup auth token
        token_field.title = appDelegate!.token
        auth_headers = [
            "Authorization": "Token token=" + appDelegate!.token
        ]
        
        // Setup Server Trust Policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            hostname: .DisableEvaluation
        ]
        print(serverTrustPolicies)
        manager = Alamofire.Manager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
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
                printer_select.addItemWithTitle(tokens[1] )
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
        manager.request(.POST, appDelegate!.host + "/api/tickets/dj", headers: auth_headers)
        .responseString { response in
            self.spinner.hidden = true
            self.spinner.stopAnimation(self)
            self.print_label(response.result.value!)
        }
    }

    @IBAction func print_both(sender: AnyObject) {
        spinner.hidden = false
        spinner.startAnimation(self)
        manager.request(.POST, appDelegate!.host + "/api/tickets/both", headers: auth_headers)
        .responseString { response in
            self.spinner.hidden = true
            self.spinner.stopAnimation(self)
            self.print_label(response.result.value!)
        }
    }
    
    @IBAction func print_band(sender: AnyObject) {
        spinner.hidden = false
        spinner.startAnimation(self)
        manager.request(.POST, appDelegate!.host + "/api/tickets/band", headers: auth_headers)
        .responseString { response in
            self.spinner.hidden = true
            self.spinner.stopAnimation(self)
            self.print_label(response.result.value!)
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

