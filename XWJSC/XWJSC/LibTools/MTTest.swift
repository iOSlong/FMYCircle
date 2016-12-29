//
//  MTTest.swift
//  XWJSC
//
//  Created by xuewu.long on 16/12/26.
//  Copyright © 2016年 fmylove. All rights reserved.
//

import UIKit

class MTTest: NSObject {
    
    var name:String? = nil
    var ID:String?  = nil
    
    override var description: String {
        return "name:" + self.name! + "," + "ID:" + self.ID!
    }
}
