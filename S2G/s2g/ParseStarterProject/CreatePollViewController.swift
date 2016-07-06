//
//  CreatePollViewController.swift
//  ParseStarterProject
//
//  Created by Matus Lang on 13.12.15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class CreatePollViewController: UIViewController {

    @IBOutlet weak var A: UITextField!
    @IBOutlet weak var B: UITextField!
    @IBOutlet weak var C: UITextField!
    @IBOutlet weak var D: UITextField!
    @IBOutlet weak var Create: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func CreatePressed(sender: AnyObject) {
       

        var obj = PFObject(className:"Poll")
        let name = PFUser.currentUser()?.valueForKey("username")
        obj.setObject(name!, forKey: "username")
        obj.setObject(A.text!, forKey: "A")
        obj.setObject(B.text!, forKey: "B")
        obj.setObject(C.text!, forKey: "C")
        obj.setObject(D.text!, forKey: "D")
        obj.setObject(Variables.MyVariables.akzeptiert, forKey: "akzeptiert")
        obj.save()
        Variables.MyVariables.poll=false
        
        print("pressed   \(A.text!)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("PollViewController") as! PollViewController
        self.presentViewController(vc, animated: true, completion: nil)

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
