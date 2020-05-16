//
//  GamesViewController.swift
//  HaloStats
//
//  Created by Joshua Shinkle on 5/11/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit
import Firebase

class GamesListTableViewController: UITableViewController {

  // MARK: Constants
  let listToUsers = "ListToUsers"
  
  // MARK: Properties
  var items: [Game] = []
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!
  let ref = Database.database().reference(withPath: "games")
  let usersRef = Database.database().reference(withPath: "online")
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: UIViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    
    /*userCountBarButtonItem = UIBarButtonItem(title: "1",
                                             style: .plain,
                                             target: self,
                                             action: #selector(userCountButtonDidTouch))
    userCountBarButtonItem.tintColor = UIColor.white
    navigationItem.leftBarButtonItem = userCountBarButtonItem*/
    
    user = User(uid: "FakeId", email: "hungry@person.food")
    
    ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
      var newItems: [Game] = []
      for child in snapshot.children {
        if let snapshot = child as? DataSnapshot,
           let game = Game(snapshot: snapshot) {
          newItems.append(game)
        }
      }
      
      self.items = newItems
      self.tableView.reloadData()
    })
    
    Auth.auth().addStateDidChangeListener { auth, user in
      guard let user = user else { return }
      self.user = User(authData: user)
      // 1
      let currentUserRef = self.usersRef.child(self.user.uid)
      // 2
      currentUserRef.setValue(self.user.email)
      // 3
      currentUserRef.onDisconnectRemoveValue()
    }
    
    usersRef.observe(.value, with: { snapshot in
      if snapshot.exists() {
        self.userCountBarButtonItem?.title = snapshot.childrenCount.description
      } else {
        self.userCountBarButtonItem?.title = "0"
      }
    })
  }
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let game = items[indexPath.row]
    
    cell.textLabel?.text = game.name
    cell.detailTextLabel?.text = game.addedByUser
    
    toggleCellCheckbox(cell, isCompleted: game.completed)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let groceryItem = items[indexPath.row]
      groceryItem.ref?.removeValue()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 1
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    // 2
    let game = items[indexPath.row]
    // 3
    let toggledCompletion = !game.completed
    // 4
    toggleCellCheckbox(cell, isCompleted: toggledCompletion)
    // 5
    game.ref?.updateChildValues([
      "completed": toggledCompletion
    ])
  }
  
  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = .black
      cell.detailTextLabel?.textColor = .black
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = .gray
      cell.detailTextLabel?.textColor = .gray
    }
  }
  
  // MARK: Add Item
  
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Game",
                                  message: "Add a Game",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { _ in
        // 1
        guard let textField = alert.textFields?.first,
          let text = textField.text else { return }

        // 2
        let game = Game(name: text,
                               addedByUser: self.user.email,
                                 completed: false)
        // 3
        let gameRef = self.ref.child(text.lowercased())

        // 4
        gameRef.setValue(game.toAnyObject())
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)
    
    alert.addTextField()
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  /*@objc func userCountButtonDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }*/
}
