//
//  PollViewController.swift
//  ParseStarterProject
//
//  Created by Matus Lang on 13.12.15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
class PollViewController: UIViewController {

    @IBOutlet weak var labelA: UILabel!
    @IBOutlet weak var labelB: UILabel!
    @IBOutlet weak var labelC: UILabel!
    @IBOutlet weak var labelD: UILabel!
    var countA : Int = 0
    var countB : Int = 0
    var countC : Int = 0
    var countD : Int = 0
    
    func continueaa(alert: UIAlertAction!){
        
    }
    
    @IBAction func buttonAPressed(sender: AnyObject) {
        var query = PFQuery(className: "Poll")
        
        var objects = try! query.findObjects()
        for i in objects! {
            if i.valueForKey("vote")==nil {
                var obj = PFObject(className: "Poll")
                obj.setObject(PFUser.currentUser()!.username!, forKey: "username")
                obj.setObject("A", forKey: "vote")
                obj.save()
            }
            
            else if i.valueForKey("vote") as! String == "A" || i.valueForKey("vote") as! String == "B" || i.valueForKey("vote") as! String == "C" ||
                i.valueForKey("vote") as! String == "D"{
                    let alrtController : UIAlertController = UIAlertController(title: "You have already voted!", message: "", preferredStyle:.Alert)
                    let continueAction: UIAlertAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default ,handler: self.continueaa)
                    
                    alrtController.addAction(continueAction)
                    
                    self.presentViewController(alrtController, animated: true, completion: nil)
            }
            /*else{
        var obj = PFObject(className: "Poll")
        obj.setObject(PFUser.currentUser()!.username!, forKey: "username")
        obj.setObject("A", forKey: "vote")
        obj.save()
            }*/
        }
        
        
    }
    @IBAction func buttonBPressed(sender: AnyObject) {
        var obj = PFObject(className: "Poll")
        var query = PFQuery(className: "Poll")

        var objects = try! query.findObjects()
        for i in objects! {
            if i.valueForKey("vote")==nil {var obj = PFObject(className: "Poll")
                obj.setObject(PFUser.currentUser()!.username!, forKey: "username")
                obj.setObject("B", forKey: "vote")
                obj.save()}
                
            else if i.valueForKey("vote") as! String == "A" || i.valueForKey("vote") as! String == "B" || i.valueForKey("vote") as! String == "C" ||
                i.valueForKey("vote") as! String == "D"{
                    let alrtController : UIAlertController = UIAlertController(title: "You have already voted!", message: "", preferredStyle:.Alert)
                    let continueAction: UIAlertAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default ,handler: self.continueaa)
                    
                    alrtController.addAction(continueAction)
                    
                    self.presentViewController(alrtController, animated: true, completion: nil)
            }/*
            else{
                var obj = PFObject(className: "Poll")
                obj.setObject(PFUser.currentUser()!.username!, forKey: "username")
                obj.setObject("B", forKey: "vote")
                obj.save()
            }
        */
        }
    }
    @IBAction func buttonCPressed(sender: AnyObject) {
        var obj = PFObject(className: "Poll")
        var query = PFQuery(className: "Poll")
        var objects = try! query.findObjects()
        for i in objects! {
            if i.valueForKey("vote")==nil {var obj = PFObject(className: "Poll")
                obj.setObject(PFUser.currentUser()!.username!, forKey: "username")
                obj.setObject("C", forKey: "vote")
                obj.save()}
                
            else if i.valueForKey("vote") as! String == "A" || i.valueForKey("vote") as! String == "B" || i.valueForKey("vote") as! String == "C" ||
                i.valueForKey("vote") as! String == "D"{
                    let alrtController : UIAlertController = UIAlertController(title: "You have already voted!", message: "", preferredStyle:.Alert)
                    let continueAction: UIAlertAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default ,handler: self.continueaa)
                    
                    alrtController.addAction(continueAction)
                    
                    self.presentViewController(alrtController, animated: true, completion: nil)
            }
            else{
                var obj = PFObject(className: "Poll")
                obj.setObject(PFUser.currentUser()!.username!, forKey: "username")
                obj.setObject("C", forKey: "vote")
                obj.save()
            }
        }
    }
    @IBAction func buttonDPressed(sender: AnyObject) {
        var obj = PFObject(className: "Poll")
        var query = PFQuery(className: "Poll")
        var objects = try! query.findObjects()
        for i in objects! {
            if i.valueForKey("vote")==nil {var obj = PFObject(className: "Poll")
                obj.setObject(PFUser.currentUser()!.username!, forKey: "username")
                obj.setObject("D", forKey: "vote")
                obj.save()}
                
            else if i.valueForKey("vote") as! String == "A" || i.valueForKey("vote") as! String == "B" || i.valueForKey("vote") as! String == "C" ||
                i.valueForKey("vote") as! String == "D"{
                    let alrtController : UIAlertController = UIAlertController(title: "You have already voted!", message: "", preferredStyle:.Alert)
                    let continueAction: UIAlertAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default ,handler: self.continueaa)
                    
                    alrtController.addAction(continueAction)
                    
                    self.presentViewController(alrtController, animated: true, completion: nil)
            }
            else{
                var obj = PFObject(className: "Poll")
                obj.setObject(PFUser.currentUser()!.username!, forKey: "username")
                obj.setObject("D", forKey: "vote")
                obj.save()
            }
        }

    }
    @IBOutlet weak var resultA: UILabel!
    @IBOutlet weak var resultB: UILabel!
    @IBOutlet weak var resultC: UILabel!
    @IBOutlet weak var resultD: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var query = PFQuery(className: "Poll")
        
        var objects = try! query.findObjects()
        for i in objects! {
            
        
            if i.objectForKey("A")==nil || i.objectForKey("B")==nil || i.objectForKey("C")==nil || i.objectForKey("D")==nil{
                if i.objectForKey("vote")==nil {}
                else{
                    if i.valueForKey("vote")! as! String == "A"{
                        countA++
                        resultA.text = "A: \(countA)"
                    }
                    if i.valueForKey("vote")! as! String == "B"{
                        countB++
                        resultB.text = "B: \(countB)"
                        
                    }
                    if i.valueForKey("vote")! as! String == "C"{
                        countC++
                        resultC.text = "C: \(countC)"
                        
                    }
                    if i.valueForKey("vote")! as! String == "D"{
                        countD++
                        resultD.text = "D: \(countD)"
                    }}
            }
        
            else{
        labelA.text = i.objectForKey("A")! as! String
        labelB.text = i.objectForKey("B")! as! String
        labelC.text = i.objectForKey("C")! as! String
        labelD.text = i.objectForKey("D")! as! String
            
        // Do any additional setup after loading the view.
        }}

    }

    
    
    func update(){
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("PollViewController") as! PollViewController
        self.presentViewController(vc, animated: true, completion: nil)
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
