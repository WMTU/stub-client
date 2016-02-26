//
//  LoginController.swift
//  Stub
//
//  Created by Neil Betham on 4/12/15.
//  Copyright (c) 2015 WMTU. All rights reserved.
//

import Cocoa
import Alamofire

class LoginController: NSViewController {

    @IBOutlet weak var email: NSTextField!
    @IBOutlet weak var password: NSSecureTextField!
    var appDelegate: AppDelegate?
    var manager = Alamofire.Manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.appDelegate = (NSApplication.sharedApplication().delegate as! AppDelegate)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func login(sender: AnyObject) {
        get_token(self.email.stringValue, password: self.password.stringValue)
    }
    @IBAction func password_submit(sender: AnyObject) {
        get_token(self.email.stringValue, password: self.password.stringValue)
    }
    
    func get_token(email: String, password: String) {
        let params = [
            "session": [
                "email": email,
                "password": password
            ]
        ]
        
        // Trim protocol from hostname
        var hostname = appDelegate!.host
        hostname = hostname.stringByReplacingOccurrencesOfString("https://", withString: "")
        hostname = hostname.stringByReplacingOccurrencesOfString("http://", withString: "")
        
        // Setup Server Trust Policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            hostname: .DisableEvaluation
        ]
        manager = Alamofire.Manager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        
        manager.request(.POST, appDelegate!.host + "/api/tokens.json", parameters: params, encoding: .JSON)
        .responseJSON(completionHandler: handle_token_response)
    }
    
    func handle_token_response(response:Response<AnyObject, NSError>) {
        if let value = response.result.value?["key"]! {
            debugPrint(response.result)
            appDelegate!.token = value as! String
            performSegueWithIdentifier("loggedIn", sender: self)
        } else {
            print("Get Token returned error")
            debugPrint(response.result)
            set_red_border(email)
            set_red_border(password)
        }
    }
    
    func set_red_border(field:NSView){
        field.layer?.cornerRadius = 1.0
        field.layer?.masksToBounds = true
        field.layer?.borderColor = NSColor( red: 255/255, green: 65/255, blue:54/255, alpha: 0.5 ).CGColor
        field.layer?.borderWidth = 3.0
    }
}

