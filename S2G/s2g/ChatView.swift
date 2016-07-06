//
//  ChatView.swift
//  ParseStarterProject
//
//  Created by Matus Lang on 13.12.15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

var currentSessionUN = ""
var currentSessionPW = ""

class ChatView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var MessageTo: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var message: UITextField!
    @IBOutlet var chatWith: UITextField!
    
    var chattingWith = false
    
    var updateTimer = NSTimer()
    let updateDelay = 1.0
    
    var currentData: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Variables.MyVariables.MessageTo==""{
            chattingWith = false
        }
        else {chattingWith = true
        }

        
        if chattingWith {
            MessageTo.text="Messaging with: \(Variables.MyVariables.MessageTo)"
        }
        else {MessageTo.text="Group Chat"}
        // Do any additional setup after loading the view, typically from a nib.
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(updateDelay, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    @IBAction func homePressed(sender: AnyObject) {
        Variables.MyVariables.MessageTo=""
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func update() {
        var query = PFQuery(className: "Chat")
        
        query.limit = 1000
        var objects = try! query.findObjects()
        print("oooobject\(objects?.count)")
        currentData = []
        for i in objects! {
            var finalDictionary: [String: String] = [:]
            finalDictionary["username"] = i.objectForKey("username")! as! String
            finalDictionary["text"] = i.objectForKey("text")! as! String
            
            if chattingWith {
                print("cuuuuuuurent\(PFUser.currentUser()?.username)")
                print("tooooooo \(i.valueForKey("username") as! String)")
                //print("tooooooo \(i.valueForKey("to") as! String)")
                
                /*if  PFUser.currentUser()!.username == i.valueForKey("to") as! String && Variables.MyVariables.MessageTo == i.valueForKey("from") as! String || PFUser.currentUser()!.username == i.valueForKey("from") as! String  && Variables.MyVariables.MessageTo == i.valueForKey("to") as! String*/
                
                var c = i.valueForKey("to")?.count
                for var index=0; index<c; ++index{
                if PFUser.currentUser()!.username == i.valueForKey("to")![index] as? String && Variables.MyVariables.MessageTo == i.valueForKey("from") as! String && i.valueForKey("incoming") as! String == "private" || PFUser.currentUser()!.username == i.valueForKey("from") as? String  && Variables.MyVariables.MessageTo == i.valueForKey("to")![index] as! String && i.valueForKey("incoming") as! String == "private"{
                    print("tuuuuuuuuuuuu \(i.valueForKey("username")! as! String)")
                    currentData.append(finalDictionary)
                    }}
            } else {
                
                    for j in Variables.MyVariables.akzeptiert {
                        print("totojej\(j)")
                        var jk = j as! String
                        var c = i.valueForKey("to")?.count
                        print("cccccc\(c)")
                        for var index=0; index<c; ++index{
                            print("index\(index)")
                        if  (i.valueForKey("to")![index] as! String==("Peťo Boros")) && i.valueForKey("incoming") as! String == "group"{
                            currentData.append(finalDictionary)
                            print("111111")}
                        else if i.valueForKey("from") as! String == jk && i.valueForKey("incoming") as! String == "group"{
                            currentData.append(finalDictionary)
                            print("2222")}
                        else if i.valueForKey("to")![index]as! String==PFUser.currentUser()!.username! && jk == i.valueForKey("from") as! String && i.valueForKey("incoming") as! String == "group"{currentData.append(finalDictionary)
                        print("33333")}
                        else if PFUser.currentUser()!.username! == i.valueForKey("from") as! String && i.valueForKey("to")![index] as! String==jk && i.valueForKey("incoming") as! String == "group"{
                    currentData.append(finalDictionary)
                            print("44444")
                            }}}
                print("nulaaaa")
            }
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("customChatCell") as! chatCell
        cell.chatText.text = currentData[indexPath.row]["text"]!
        if currentData[indexPath.row]["username"] == PFUser.currentUser()?.valueForKey("username") as! String{
            cell.chatUser.textColor = UIColor.grayColor()
            cell.chatUser.text = "me"
        }
        else{
            cell.chatUser.textColor = UIColor(red: 19/255, green: 150/255, blue: 241/255, alpha: 1.0)
            cell.chatUser.text = currentData[indexPath.row]["username"]!
        }
        
        return cell
    }
    
    @IBAction func send() {
        if message.text != ""{
            var obj = PFObject(className: "Chat")
            let name = PFUser.currentUser()?.valueForKey("username")
            obj.setObject(name!, forKey: "username")
            obj.setObject(message.text!, forKey: "text")
            var arr = Variables.MyVariables.akzeptiert
            if chattingWith {
                //obj["to"]?.appendString(Variables.MyVariables.MessageTo)
                print("chattingwith")
                obj.setValue(Variables.MyVariables.mgsto, forKey: "to")
                obj.setValue("private", forKey: "incoming")
            }
            else{
                obj.setValue(Variables.MyVariables.akzeptiert, forKey: "to")
                obj.setValue("group", forKey: "incoming")
            }

            obj.setObject((PFUser.currentUser()?.username)!, forKey: "from")
            try! obj.save()
            message.text = ""
            self.view.endEditing(true)
        }
    }
    
    @IBAction func initiatePrivateChat() {
        chattingWith = !chattingWith
        //chatWith.text = chattingWith ? chatWith.text! : ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

