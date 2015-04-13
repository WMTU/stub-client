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
    
    func get_token(email: String, password: String) {
        var params = [
            "session": [
                "email": email,
                "password": password
            ]
        ]
        
        var controller = self
        
        Alamofire.request(.POST, appDelegate!.host + "/api/tokens.json", parameters: params, encoding: .JSON)
        .responseJSON(completionHandler: handle_token_response)
    }
    
    func handle_token_response(request:NSURLRequest, response:NSHTTPURLResponse?, json: AnyObject?, error: NSError?) {
        appDelegate!.token = json?["key"] as! String
        performSegueWithIdentifier("loggedIn", sender: self)
    }
}

