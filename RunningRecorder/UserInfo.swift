//
//  UserInfo.swift
//  RunningRecorder
//
//  Created by 黄嘉华 on 2018/11/4.
//  Copyright © 2018 jhhuang. All rights reserved.
//

import Foundation

class UserInfo {
    var user_id: Int = -1
    var email: String = ""
    var user_name: String = ""
    var key: String = ""
    
    func update(user: User) {
        user_id = Int(user.id)
        email = user.email!
        user_name = user.username!
        key = user.key!
    }
}
