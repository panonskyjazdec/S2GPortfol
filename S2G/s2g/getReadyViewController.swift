//
//  getReadyViewController.swift
//  ParseStarterProject
//
//  Created by Matus Lang on 16.11.15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class getReadyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var selectedSport: String = ""
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    var pickerChoice:NSString!
    
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var userImage: UIImageView!
   
    var actionString: String?
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    
    override func viewDidLoad() {
        viewWillAppear(true)
        super.viewDidLoad()
        fbgetFriends()
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            
            if let geoPoint = geoPoint {
                
                PFUser.currentUser()?["location"] = geoPoint
                PFUser.currentUser()?.save()
                
            }
            
            
        }
        
        /*var userQuery: PFQuery = PFUser.query()!
        userQuery.whereKey("objectId", equalTo: (PFUser.currentUser()?.objectId)!)
        
        let query: PFQuery = PFInstallation.query()!
        query.whereKey("user", equalTo: PFUser())
        
        let push = PFPush()
        push.setQuery(query)
        push.setMessage("New message from \(PFUser.currentUser()!.username!)")
        push.sendPushInBackground()
        */
        

        // Do any additional setup after loading the view.
        
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender"])
        graphRequest.startWithCompletionHandler( {
            
            (connection, result, error) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else if let result = result {
                
                PFUser.currentUser()?["gender"] = result["gender"]
                PFUser.currentUser()?["name"] = result["name"]
                
                
                PFUser.currentUser()?.save()
                
                let userId = result["id"] as! String
                
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                    
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        
                        self.userImage.image = UIImage(data: data)
                        
                        let imageFile:PFFile = PFFile(data: data)
                        
                        PFUser.currentUser()?["image"] = imageFile
                        //PFUser.currentUser()?["sport"] = self.pickerData[self.picker.selectedRowInComponent(0)]
                            
                            //self.pickerChoice
                        PFUser.currentUser()?["interestedInWomen"] = true
                        PFUser.currentUser()?["interestedInMen"] = true
                        PFUser.currentUser()?["username"] = PFUser.currentUser()?["name"]
                        
                        
                        
                        //self.pickerData[self.picker.selectedRowInComponent(0)]
                        
                        PFUser.currentUser()?.save()
                        
                    }
                    
                }
                
            }
            
        })
        
        

        
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = ["Baseball", "Basketball", "Boxing", "Football", "Fitness", "Volleyball"]
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSport = pickerData[row]
        PFUser.currentUser()?["sport"] = pickerData[row]
        PFUser.currentUser()?.save()
        
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
                                
                                
                                let query = PFUser.query()
                                query!.whereKey("username", containsString: dict2["name"] as! String)
                                query?.findObjectsInBackgroundWithBlock{(results, error) -> Void in
                                    Variables.MyVariables.sportt.insert((results![0]["sport"] as! String), atIndex: 0)
                                }
                                

                                
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

    func dismissAlert(alert: UIAlertAction!)
    {
        //let secondViewController:SearchUsersViewController = SearchUsersViewController()
        //self.navigationController?.pushViewController(secondViewController, animated: true)
        //self.navigationController!.presentViewController(secondViewController, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("getReadyViewController") as! getReadyViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func continuea(alert: UIAlertAction!)
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SearchUsersViewController") as! SearchUsersViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func searchPressed(sender: AnyObject) {
        
        
        
        var query = PFUser.query()
        query!.whereKey("sport", containsString: selectedSport)
        query?.findObjectsInBackgroundWithBlock{(results, error) -> Void in
            print("sadkjfnsakdjfnsdsadkfnskld        \(results)")
            if results?.count<3{
        
        let alrtController : UIAlertController = UIAlertController(title: "Small amount of users searching for this sport", message: "Do you want to continue?", preferredStyle:.Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Change sport", style: .Cancel, handler: self.dismissAlert)
        
        let continueAction: UIAlertAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default ,handler: self.continuea)
        
        alrtController.addAction(cancelAction)
        alrtController.addAction(continueAction)
        
        //self.navigationController?.pushViewController(alrtController, animated: true)
        self.presentViewController(alrtController, animated: true, completion: nil)
            }
            else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("SearchUsersViewController") as! SearchUsersViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
        
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
