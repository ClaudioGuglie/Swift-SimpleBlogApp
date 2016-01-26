//
//  LoginVC.swift
//  ZEF
//
//  Created by Claudio on 11/13/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit
//import SwiftyJSON
import Alamofire

class LoginVC: UIViewController, GITClientDelegate, GITInterfaceManagerDelegate {
    
    var interfaceManager: GITInterfaceManager!
    @IBOutlet weak var signInFailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceManager = GITInterfaceManager()
        interfaceManager.delegate = self
        GITClient.sharedInstance().delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        signInFailView.hidden = true;
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        interfaceManager.startSignIn()
    }
    
    // Handles the response from the GitKit client, and retrieves an auth token fro, the gRPC server.
    //
    func client(client: GITClient!, didFinishSignInWithToken token: String!, account: GITAccount!,
        error: NSError!) {
            if error == nil {
                NSLog("Success");
                let apiRequest = ApiRequest()
                
                apiRequest.getInfoRequest(token, callback: { (isSuccess, jsonDic) -> Void in
                    if (isSuccess) {
                        //do good stuff here
                        let resultDic = jsonDic["result"] as! NSDictionary
                        let resultStatus = resultDic["status"]
                        
                        if (resultStatus!.isEqual("ok"))
                        {
                            let gitIdToken = GITIDToken.init(string: token)
                            
                            UserPreferences.sharedInstance.gToken = token
                            UserPreferences.sharedInstance.gTokenExpireAt = gitIdToken.expireAt
                            UserPreferences.sharedInstance.username = account.displayName
                            UserPreferences.sharedInstance.email = account.email
                            UserPreferences.sharedInstance.picUrl = account.photoURL
                            
                            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController;
                            self.navigationController?.pushViewController(vc, animated: true);
                        }
                        else if (resultStatus!.isEqual("error"))
                        {
                            self.signInFailView.hidden = false;
                        }

                    }else{
                        // do error handling here
                        self.signInFailView.hidden = false;
                    }
                })
            }
    }
}
