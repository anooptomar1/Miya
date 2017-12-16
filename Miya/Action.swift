//
//  Action.swift
//  Miya
//
//  Created by Steven Hurtado on 10/6/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation

open class Action: NSObject, NSCoding
{
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kAction: String = "action"
    internal let kTriggered: String = "triggered"
    
    // MARK: Properties
    open var action: String?
    open var triggered: Bool?
    
    // MARK: SwiftyJSON Initalizers
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
        action = json[kAction] as? String
        triggered = json[kTriggered] as? Bool
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.action = aDecoder.decodeObject(forKey: kAction) as? String
        self.triggered = aDecoder.decodeObject(forKey: kTriggered) as? Bool
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(action, forKey: kAction)
        aCoder.encode(triggered, forKey: kTriggered)
    }
}
