//
//  OnlineUsersTableViewController.swift
//  HaloStats
//
//  Created by Joshua Shinkle on 5/15/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit
import Firebase

class OnlineUsersTableViewController: UITableViewController {
  
  // MARK: Constants
  let userCell = "UserCell"
  
  // MARK: Properties
  var currentUsers: [String] = []
  let usersRef = Database.database().reference(withPath: "online")
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // 1
    usersRef.observe(.childAdded, with: { snap in
      // 2
      guard let email = snap.value as? String else { return }
      self.currentUsers.append(email)
      // 3
      let row = self.currentUsers.count - 1
      // 4
      let indexPath = IndexPath(row: row, section: 0)
      // 5
      self.tableView.insertRows(at: [indexPath], with: .top)
    })
    
    usersRef.observe(.childRemoved, with: { snap in
      guard let emailToFind = snap.value as? String else { return }
      for (index, email) in self.currentUsers.enumerated() {
        if email == emailToFind {
          let indexPath = IndexPath(row: index, section: 0)
          self.currentUsers.remove(at: index)
          self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
      }
    })
  }
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentUsers.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
    let onlineUserEmail = currentUsers[indexPath.row]
    cell.textLabel?.text = onlineUserEmail
    return cell
  }
  
  // MARK: Actions
  
  @IBAction func signoutButtonPressed(_ sender: AnyObject) {
    // 1
    let user = Auth.auth().currentUser!
    let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")

    // 2
    onlineRef.removeValue { (error, _) in

      // 3
      if let error = error {
        print("Removing online failed: \(error)")
        return
      }

      // 4
      do {
        try Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
      } catch (let error) {
        print("Auth sign out failed: \(error)")
      }
    }
  }
}

