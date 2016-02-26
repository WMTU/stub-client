//
//  AppDelegate.swift
//  Stub
//
//  Created by Neil Betham on 4/12/15.
//  Copyright (c) 2015 WMTU. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var token:String = ""
    var host:String = ""

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.stringForKey("host") != nil) {
            host = defaults.stringForKey("host")!
        } else {
            host = "http://localhost:3000"
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminate(sender: NSApplication) -> NSApplicationTerminateReply {

        // If we got here, it is time to quit.
        return .TerminateNow
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }

}

