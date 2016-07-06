//
//  SearchUsersViewController.swift
//  ParseStarterProject
//
//  Created by Matus Lang on 17.11.15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class SearchUsersViewController: UIViewController {
    
    var updateTimer = NSTimer()
    let updateDelay = 2.0
    
    @IBOutlet weak var NoUsersLabel: UILabel!
    @IBAction func stoppressed(sender: AnyObject) {
        
        PFUser.currentUser()!.removeObjectForKey("abgelehnt");
        PFUser.currentUser()!.removeObjectForKey("akzeptiert");
        PFUser.currentUser()!.saveInBackground();

        PFUser.logOut()
    }
    
    @IBOutlet weak var userImage: UIImageView!
    var userId = ""

    
    
    @IBOutlet weak var FBFriends: UILabel!
    
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var akzeptiertOrAbgelehnt = ""
            
            if label.center.x < 100 {
                
                akzeptiertOrAbgelehnt = "abgelehnt"
               
               
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                akzeptiertOrAbgelehnt = "akzeptiert"
                
                
                
                
            }
            
            if akzeptiertOrAbgelehnt != "" {
                
                PFUser.currentUser()?.addUniqueObjectsFromArray([userId], forKey:akzeptiertOrAbgelehnt)
                
                PFUser.currentUser()?.save()
                
               
                
            }
            
    
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            updateImage()
            
        }
        
        
        
    }
    
    func fbgetFriends(){
        var x : Int = 0;
        var s : String = "";
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            
            if error == nil {
                print("Friends are : \(result.count)")
                x=result.count;
                s = String(x);
                if let dict = result as? [String: AnyObject]{
                    if let data = dict["data"] as? [AnyObject]{
                        for dict2 in data {
                            print(result);
                            print("menooooooo jeee: \(dict2["name"] as! String)")
                            if !Variables.MyVariables.namesArray.contains(dict2["name"] as! String){
                                Variables.MyVariables.namesArray.insert(dict2["name"] as! String, atIndex: 0) 
                            }
                            if !Variables.MyVariables.IdArray.contains(dict2["id"] as! String){
                                Variables.MyVariables.IdArray.insert(dict2["id"] as! String, atIndex: 0)
                            }
                            print(Variables.MyVariables.IdArray)
                        }
                    }
                }
                
            } else {
                
                print("Error Getting Friends \(error)");
                
            }
            
        }
    }
    
    
    func updateImage() {
    
        var query = PFUser.query()
        if let latitude = PFUser.currentUser()?["location"]?.latitude {
            
            if let longitude = PFUser.currentUser()?["location"]?.longitude {
                
                print(latitude)
                print(longitude)
                
                query!.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast:PFGeoPoint(latitude:latitude + 1, longitude: longitude + 1))
                
            }
            
        }
        
        var interessiertIn = ""
        var sportArt = PFUser.currentUser()?["sport"]
        var list = [""]
        
        
        
        
        
        
        
        if ((PFUser.currentUser()!["interestedInWomen"]! as! Bool == true) && (PFUser.currentUser()!["interestedInMen"]! as! Bool == true)) {
        
        interessiertIn = "egal"
        
        } else {
                if (PFUser.currentUser()!["interestedInWomen"]! as! Bool == true) && PFUser.currentUser()!["interestedInMen"]! as! Bool == false  {
                    interessiertIn = "female"
                
                } else {
                        interessiertIn = "male"

                        }
        
                }

        
        if interessiertIn != "egal"
            {
                query!.whereKey("gender", equalTo:interessiertIn)
            }

        
        if let acceptedUsers = PFUser.currentUser()?["akzeptiert"]  {
            
            list += acceptedUsers as! Array

            
        }
        
        if let rejectedUsers = PFUser.currentUser()?["abgelehnt"] {
            
            list += rejectedUsers as! Array
            
        }
        
        
        query!.whereKey("objectId", notContainedIn: list)
        query!.whereKey("sport", equalTo:sportArt!)
        query!.whereKey("objectId", notEqualTo: (PFUser.currentUser()?.username)!)
        

        
        
        
        query!.limit = 1
        
        query!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else if let objects = objects as? [PFObject] {
                
                for object in objects {
                    
                    self.userId = object.objectId!
                    
                    let imageFile = object["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            
                            print(error)
                            
                        } else {
                            
                            if object.objectId==PFUser.currentUser()?.objectId{
                            print("error")
                                self.NoUsersLabel.hidden=false
                            }
                            
                            else if let data = imageData {
                                self.userImage.hidden=false
                                self.userImage.image = UIImage(data: data)
                                self.NoUsersLabel.hidden=true

                                
                            }

                            
                        }

                        
                    }
                    
                }
                self.userImage.hidden=true
                self.NoUsersLabel.hidden=false

            }
            
        }

    
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    
    
    override func viewDidLoad() {
        viewWillAppear(true)
        super.viewDidLoad()
        fbgetFriends();
        FBFriends.text = String (Variables.MyVariables.namesArray.count)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        userImage.addGestureRecognizer(gesture)
        
        userImage.userInteractionEnabled = true
        
        
        updateImage()
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(updateDelay, target: self, selector: "updateImage", userInfo: nil, repeats: true)

        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func continuea(alert: UIAlertAction!){
        
    }
    @IBAction func MatchesPressed(sender: AnyObject) {
                let akzept = PFUser.currentUser()?.valueForKey("akzeptiert")
        
                print("ciiiiiislo \(akzept)")
                if akzept?.count == nil {
                let alrtController : UIAlertController = UIAlertController(title: "You have no Matches", message: "", preferredStyle:.Alert)
                
                
                let continueAction: UIAlertAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default ,handler: self.continuea)
                
                alrtController.addAction(continueAction)
                
                //self.navigationController?.pushViewController(alrtController, animated: true)
                self.presentViewController(alrtController, animated: true, completion: nil)
            }
            else {
            
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("MatchesTableViewController") as! MatchesTableViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

            }

