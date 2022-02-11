//
//  Model.swift
//  FAQmc2Soft
//
//  Created by Акифьев Максим  on 10.02.2022.
//

import Foundation

class DataModel
{
    var items: AnyObject!
    var returnArray: [String] = []
    
    func getHeadersId() -> [String]
    { 
        for item in (items as! [AnyObject])
        {
            let dict = item as! [String: AnyObject]
            returnArray.append(dict["name"] as! String)
        }
        return returnArray
    }
}
