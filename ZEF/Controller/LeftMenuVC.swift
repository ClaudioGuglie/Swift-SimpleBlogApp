//
//  LeftMenuVC.swift
//  ZEF
//
//  Created by Claudio on 11/13/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit

class LeftMenuVC: UIViewController {
    
    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        ImageLoader.sharedLoader.imageForUrl(UserPreferences.sharedInstance.picUrl, completionHandler:{(image: UIImage?, url: String) in
            self.profilePicImgView.image = image
        })
        
        self.profilePicImgView.layer.cornerRadius = self.profilePicImgView.frame.size.width / 2
        self.profilePicImgView.clipsToBounds = true
        self.profilePicImgView.layer.borderWidth = 3.0
        self.profilePicImgView.layer.borderColor = UIColor.whiteColor().CGColor
        
        usernameLbl.text = UserPreferences.sharedInstance.username;
        emailLbl.text = UserPreferences.sharedInstance.email;
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        UserPreferences.sharedInstance.clear()

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
        
        self.revealViewController().navigationController?.setViewControllers([viewController], animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
