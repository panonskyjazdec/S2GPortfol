//
//  MatchesTableViewController.swift
//  ParseStarterProject
//
//  Created by Matus Lang on 11.12.15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class MatchesTableViewController: UITableViewController {
    var updateTimer = NSTimer()
    let updateDelay = 2.0
    
    @IBOutlet var LongPress: UILongPressGestureRecognizer!
    var benuzterNamen = [String]()
    var bilder = [UIImage]()

    func continueaa(alert: UIAlertAction!){
    }
    
    func createa(alert: UIAlertAction!){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CreatePollViewController") as! CreatePollViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func PollPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("PollViewController") as! PollViewController
        var query = PFQuery(className: "Poll")
        let objects = try! query.findObjects()
        print("count \(objects?.count)")
        if objects?.count==0 {
            let alrtController : UIAlertController = UIAlertController(title: "No Poll at the moment!", message: "Do you want to create a new Poll?", preferredStyle:.Alert)
            let continueAction: UIAlertAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default ,handler: continueaa)
            let createAction: UIAlertAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.Default ,handler: self.createa)
            
            alrtController.addAction(continueAction)
            alrtController.addAction(createAction)
            
            self.presentViewController(alrtController, animated: true, completion: nil)
        }
        else{
        for i in objects! {
            //print("akzzzzz\(i.valueForKey("akzeptiert") as! [String])")
            if i.valueForKey("akzeptiert") == nil {}
            else{
            var arr = i.valueForKey("akzeptiert") as! [String]
            

        if arr.contains(PFUser.currentUser()!.username!)  || i.valueForKey("username")!.containsString((PFUser.currentUser()?.username)!) && (i.valueForKey("A") != nil || i.valueForKey("B") != nil || i.valueForKey("C") != nil || i.valueForKey("D") != nil) {
            self.presentViewController(vc, animated: true, completion: nil)
                }
            }
            }
            for i in objects! {
                //print("akzzzzz\(i.valueForKey("akzeptiert") as! [String])")
                if i.valueForKey("akzeptiert") == nil {}
                else{
                    var arr = i.valueForKey("akzeptiert") as! [String]
        if i.valueForKey("username")!.containsString((PFUser.currentUser()?.username)!) && (i.valueForKey("A") == nil || i.valueForKey("B") == nil || i.valueForKey("C") == nil || i.valueForKey("D") == nil)  {
            let alrtController : UIAlertController = UIAlertController(title: "No Poll at the moment!", message: "Do you want to create a new Poll?", preferredStyle:.Alert)
            let continueAction: UIAlertAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default ,handler: continueaa)
            let createAction: UIAlertAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.Default ,handler: self.createa)
            
            alrtController.addAction(continueAction)
            alrtController.addAction(createAction)

            self.presentViewController(alrtController, animated: true, completion: nil)
        }
            }}}
    }
    @IBAction func tapPressed(sender: AnyObject) {
        
        var point = tapRecognizer.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)
        if indexPath == nil {}
        else{
        Variables.MyVariables.MessageTo = benuzterNamen[indexPath!.row]
        print(Variables.MyVariables.MessageTo)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatView
        self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.tableView.addGestureRecognizer(LongPress)
        self.tableView.addGestureRecognizer(tapRecognizer)
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(updateDelay, target: self, selector: "update", userInfo: nil, repeats: true)

        let query = PFUser.query()
        
        query!.whereKey("akzeptiert", equalTo: (PFUser.currentUser()?.objectId)!)
        print(PFUser.currentUser()?["akzeptiert"])
        if PFUser.currentUser()?["akzeptiert"] != nil {
        query!.whereKey("objectId", containedIn: PFUser.currentUser()?["akzeptiert"] as! [String])
            
        query?.findObjectsInBackgroundWithBlock{(results, error) -> Void in
            
            if let results = results {
            
                for result in results as! [PFUser] {
                
                self.benuzterNamen.append(result.username!)
                    if Variables.MyVariables.akzeptiert.contains(result.username!){
                        
                    }
                    else{
                    Variables.MyVariables.akzeptiert.append(result.username!)
                    }
                    print("kkkkkkkkkkkkkk\(Variables.MyVariables.akzeptiert)")

                    
                    let imageFile = result["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            
                            print(error)
                            
                        } else {
                            
                            if let data = imageData {
                                
                                self.bilder.append(UIImage(data: data)!)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
        
        
        
                    
                }
            
                self.tableView.reloadData()
            }
        
        }
        
        
        }
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(updateDelay, target: self, selector: "update", userInfo: nil, repeats: true)


    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return benuzterNamen.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = benuzterNamen[indexPath.row]
        
        if bilder.count > indexPath.row {
            cell.imageView?.image = bilder[indexPath.row]
        
        }

        return cell
    }
    
    func continuea(alert: UIAlertAction!)
    {}
    
    func removeFromMatches(alert: UIAlertAction!){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MatchesTableViewController") as! MatchesTableViewController
        
        var query = PFUser.query()
        query?.whereKey("username", containsString: benuzterNamen[Variables.MyVariables.indexPathRow])
        query?.findObjectsInBackgroundWithBlock{(results, error) -> Void in
            
            if let objects = results as? [PFObject] {
                var firstObject = objects[0]
                print("vyyyyyysledoook    \(firstObject.valueForKey("objectId") as! String)")
                let objectId = firstObject.valueForKey("objectId") as! String
                PFUser.currentUser()?.removeObject(objectId, forKey: "akzeptiert")
                PFUser.currentUser()?.saveInBackground()
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
            
        }
    }
    
    @IBAction func LongPressPressed(sender: AnyObject) {
        
        var point = LongPress.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)
        if indexPath == nil {}
        else{
        Variables.MyVariables.indexPathRow=indexPath!.row
        
        let alrtController : UIAlertController = UIAlertController(title: "Do you want to ?", message: "", preferredStyle:.ActionSheet)
        
        let continueAction: UIAlertAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default ,handler: continuea)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Remove from Matches", style: UIAlertActionStyle.Destructive, handler: self.removeFromMatches)
        
        alrtController.addAction(cancelAction)
        alrtController.addAction(continueAction)
        
        
        self.presentViewController(alrtController, animated: true, completion: nil)
        }
    }

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
