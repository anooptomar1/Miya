//
//  Box.swift
//  Effex
//
//  Created by Steven Hurtado on 10/6/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import CoreLocation

open class Box: NSObject, NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kID: String = "id"
    internal let kActions: String = "actions"
    internal let kPosition: String = "position"
    
    // MARK: Properties
    open var id: String?
    open var actions: [Action]?
    open var position: CLLocation?
    
    // MARK: Initializers
    /**
     Instantiates the class based on the object
     - parameter object: The object of either Dictionary or Array type that was passed.
     - returns: An initialized instance of the class.
     */
    convenience public init(object: AnyObject) {
        self.init(dict: object as? NSDictionary)
    }
    
    /**
     Instantiates the class based on the JSON that was passed.
     - parameter dict: optional NSDictionary object.
     - returns: An initialized instance of the class.
     */
    required public init(dict: NSDictionary?) {
        guard let json = dict else {return}
        id = json[kID] as? String
        actions = []
        
        if let items = json[kActions] as? NSArray {
            for item in items {
                let action = Action(object: item as AnyObject)
                actions?.append(action)
            }
        } else {
            actions = nil
        }
        position = json[kPosition] as? CLLocation
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: kID) as? String
        self.actions = aDecoder.decodeObject(forKey: kActions) as? [Action]
        self.position = aDecoder.decodeObject(forKey: kPosition) as? CLLocation
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: kID)
        aCoder.encode(actions, forKey: kActions)
        aCoder.encode(position, forKey: kPosition)
    }
}
