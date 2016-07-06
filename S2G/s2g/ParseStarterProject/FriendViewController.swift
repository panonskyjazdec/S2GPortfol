//
//  MatchesTableViewController.swift
//  ParseStarterProject
//
//  Created by Matus Lang on 13.12.15.
//  Copyright © 2015 Parse. All rights reserved.


import UIKit
import Parse

class FriendTableViewController: UITableViewController{
    
    @IBOutlet var TapGesture: UITapGestureRecognizer!
    struct MyVariables {
        static var name = "someString"
    }
    
    var bilder = [UIImage]()
    
    @IBAction func TapGesture(sender: AnyObject) {
        var point = TapGesture.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)
        Variables.MyVariables.MessageTo = Variables.MyVariables.namesArray[indexPath!.row]
        Variables.MyVariables.mgsto.append(Variables.MyVariables.namesArray[indexPath!.row])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatView
        self.presentViewController(vc, animated: true, completion: nil)

        
    }
    
    @IBOutlet weak var FriendsOnline: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addGestureRecognizer(TapGesture)
        FriendsOnline.text = String (Variables.MyVariables.namesArray.count)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Variables.MyVariables.namesArray.count;
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "LabelCell", forIndexPath: indexPath)
        
        
        
        // Configure the cell...
        cell.textLabel?.text = (Variables.MyVariables.namesArray[indexPath.row])
        print(Variables.MyVariables.namesArray[indexPath.row])
        print(Variables.MyVariables.IdArray[indexPath.row])
        print(Variables.MyVariables.namesArray)
        print(Variables.MyVariables.sportt)
        
        
        let userId = Variables.MyVariables.IdArray[indexPath.row]
        let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=small"
        if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {

            
            if let data = NSData(contentsOfURL: fbpicUrl) {
                
        cell.imageView?.image = UIImage(data: data)
            }
        }
        
        
        cell.detailTextLabel?.text=Variables.MyVariables.sportt[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "online"
    }
    
    
    
}
