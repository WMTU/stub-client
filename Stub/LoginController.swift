//
//  LoginController.swift
//  Stub
//
//  Created by Neil Betham on 4/12/15.
//  Copyright (c) 2015 WMTU. All rights reserved.
//

import Cocoa
import CoreData
import Alamofire

class LoginController: NSViewController {

    @IBOutlet weak var email: NSTextField!
    @IBOutlet weak var password: NSSecureTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        Alamofire.request(.POST, "http://localhost:3000/api/tokens.json", parameters: params, encoding: .JSON)
        .responseJSON { (_, _, JSON, _) in
            let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let entity =  NSEntityDescription.entityForName("Token", inManagedObjectContext: managedContext)
            let token = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            
            token.setValue(JSON?["key"], forKey: "token_key")
            token.setValue(NSDate(string: JSON?["created_at"] as! String), forKey: "created_at")
            token.setValue(NSDate(string: JSON?["updated_at"] as! String), forKey: "updated_at")
            token.setValue(JSON?["user_id"], forKey: "user_id")
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            } else {
                controller.performSegueWithIdentifier("loggedIn", sender: self)
            }
        }
    }
}

