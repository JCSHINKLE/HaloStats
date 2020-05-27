//
//  User.swift
//  HaloStats
//
//  Created by Joshua Shinkle on 5/15/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  
  init(authData: Firebase.User) {
    uid = authData.uid
    email = authData.email!
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}
