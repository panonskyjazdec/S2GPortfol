//
//  SettingsViewController.swift
//  ParseStarterProject
//
//  Created by Matus Lang on 17.11.15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var menSwitch: UISwitch!
    @IBOutlet weak var womenSwitch: UISwitch!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var kmlabel: UILabel!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        Variables.MyVariables.kmslider=currentValue
        kmlabel.text = "\(currentValue)"
    }
    
    @IBAction func selectMen(sender: UISwitch) {

        if sender.on{
        PFUser.currentUser()?["interestedInMen"] = true
        PFUser.currentUser()?.save()
        Variables.MyVariables.Man = true
            

        } else{
        PFUser.currentUser()?["interestedInMen"] = false
        PFUser.currentUser()?.save()
            Variables.MyVariables.Man = false
            


        }
        
        
    }
    
   
    
    @IBAction func selectWomen(sender: UISwitch) {
        
        
        if sender.on{
            PFUser.currentUser()?["interestedInWomen"] = true
            PFUser.currentUser()?.save()
            Variables.MyVariables.Woman = true

        }
        else {
            
            PFUser.currentUser()?["interestedInWomen"] = false
            PFUser.currentUser()?.save()
            Variables.MyVariables.Woman = false

        }

        
    }
    
    @IBAction func ChangeSportPressed(sender: UIButton) {
        
        PFUser.currentUser()!.removeObjectForKey("abgelehnt");
        PFUser.currentUser()!.removeObjectForKey("akzeptiert");
        PFUser.currentUser()!.saveInBackground();
        
        var query = PFQuery(className: "Poll")
        let objects = try! query.findObjects()
        for i in objects! {
            //print("akzzzzz\(i.valueForKey("akzeptiert") as! [String])")
          if i.valueForKey("username") as! String == PFUser.currentUser()?.username{
                i.removeObjectForKey("A")
                i.removeObjectForKey("B")
                i.removeObjectForKey("C")
                i.removeObjectForKey("D")
                i.save()
    }
        }
    }
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bla:Float = Float(Variables.MyVariables.kmslider)
        slider.value = bla;
        let str:String = String(Variables.MyVariables.kmslider)
        kmlabel.text=str;
        menSwitch.on=Variables.MyVariables.Man
        womenSwitch.on=Variables.MyVariables.Woman

       //Variables.MyVariables.Woman
        
        
        
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
