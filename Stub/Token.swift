//
//  Token.swift
//  Stub
//
//  Created by Neil Betham on 4/12/15.
//  Copyright (c) 2015 WMTU. All rights reserved.
//

import Foundation
import CoreData

class Token: NSManagedObject {

    @NSManaged var created_at: NSDate
    @NSManaged var token_key: String
    @NSManaged var updated_at: NSDate
    @NSManaged var user_id: NSNumber

}
