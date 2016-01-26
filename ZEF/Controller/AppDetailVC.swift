//
//  AppDetailVC.swift
//  ZEF
//
//  Created by Claudio on 11/18/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit

class AppDetailVC: UIViewController {
    
    @IBOutlet weak var mWebView: UIWebView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var selIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appItem : AppItem = SharedValue.sharedInstance.gAppsArray[selIndex] as! AppItem
        self.nameLbl.text = appItem.mName
        
        self.refreshContent()
    }
    
    @IBAction func onBack(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onRefresh(sender: AnyObject)
    {
        self.refreshContent()
    }
    
    func refreshContent()
    {
        let appItem : AppItem = SharedValue.sharedInstance.gAppsArray[selIndex] as! AppItem
        let dataUrl = kBaseReportHtmlUrl + appItem.mId
        UIWebView.loadRequest(self.mWebView)(NSURLRequest(URL: NSURL(string: dataUrl)!))
    }
}
