//
//  FBChatTableViewController.swift
//  ParseStarterProject
//
//  Created by Matus Lang on 06/01/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse


class FBChatTableViewController: UITableViewController {

    var chattingWith = true
    @IBOutlet weak var MessageTo: UILabel!
    @IBOutlet var tableVieww: UITableView!
    @IBOutlet weak var message: UITextField!
    
    var updateTimer = NSTimer()
    let updateDelay = 1.0
    
    var currentData: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageTo.text="messaging with: \(Variables.MyVariables.MessageTo)"
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(updateDelay, target: self, selector: "update", userInfo: nil, repeats: true)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func tableVieww(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
      func tableVieww(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("customChatCell") as! chatCell
        cell.chatText.text = currentData[indexPath.row]["text"]!
        if currentData[indexPath.row]["username"] == PFUser.currentUser()?.valueForKey("username") as! String{
            cell.chatUser.textColor = UIColor.grayColor()
            cell.chatUser.text = "me"
        }
        else{
            cell.chatUser.text = currentData[indexPath.row]["username"]!
        }
        
        return cell
    }
    
    func update() {
        var query = PFQuery(className: "Chat")
        query.limit = 1000
        var objects = try! query.findObjects()
        currentData = []
        for i in objects! {
            var finalDictionary: [String: String] = [:]
            finalDictionary["username"] = i.objectForKey("username")! as! String
            finalDictionary["text"] = i.objectForKey("text")! as! String
            if chattingWith {
                if i.objectForKey("username")! as! String == Variables.MyVariables.MessageTo && i.objectForKey("to")! as! String == currentSessionUN || i.objectForKey("username")! as! String == currentSessionUN && i.objectForKey("to")! as! String == Variables.MyVariables.MessageTo {
                    currentData.append(finalDictionary)
                }
            } else {
                if i.objectForKey("to")! as! String == "" {
                    currentData.append(finalDictionary)
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func sendPressed(sender: AnyObject) {
        var obj = PFObject(className: "Chat")
        let name = PFUser.currentUser()?.valueForKey("username")
        obj.setObject(name!, forKey: "username")
        obj.setObject(message.text!, forKey: "text")
        obj.setObject(chattingWith ? Variables.MyVariables.MessageTo : "", forKey: "to")
        try! obj.save()
        message.text = ""
        self.view.endEditing(true)
    
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
