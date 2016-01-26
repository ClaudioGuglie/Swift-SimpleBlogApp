//
//  ReportGroupsVC.swift
//  ZEF
//
//  Created by Claudio on 11/17/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit
//import SwiftyJSON
import ImageLoader
import Alamofire

class ReportGroupsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var appImgView: UIImageView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createdLbl: UILabel!
    @IBOutlet weak var modifiedLbl: UILabel!
    @IBOutlet weak var socialView: UIView!
    @IBOutlet weak var reportLbl: UILabel!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var copiedView: UIView!
    
    var selIndex = 0
    var selReportId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
        if revealViewController() != nil {
            menuBtn.addTarget(revealViewController(), action: "revealToggle:", forControlEvents: .TouchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: "onMaskView:")
        self.maskView.addGestureRecognizer(gesture)
        
        self.loadAppItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        maskView.hidden = true
        socialView.hidden = true
        copiedView.hidden = true
        
        let appItem : AppItem = SharedValue.sharedInstance.gAppsArray[selIndex] as! AppItem
        
        self.titleLbl.text = appItem.mName;
//        ImageLoader.sharedLoader.imageForUrl(appItem.mShareImageUrl, completionHandler:{(image: UIImage?, url: String) in
//            self.appImgView.image = image
//        })
        dispatch_async(dispatch_get_main_queue()) {
            self.appImgView.load(appItem.mShareImageUrl, placeholder: nil) { _ in
            }
        }
        
        self.createdLbl.text = "Created: " + appItem.mCreated
        self.modifiedLbl.text = "Modified: " + appItem.mModified
    }
    
    func onMaskView(sender:UITapGestureRecognizer){
        // do other task
        self.hideSocialView()
    }
    
    func refresh(sender:AnyObject)
    {
        self.loadAppItems()
    }
    
    func loadAppItems()
    {
        let appItem : AppItem = SharedValue.sharedInstance.gAppsArray[selIndex] as! AppItem

        let apiRequest = ApiRequest()
        apiRequest.getReportGroupRequest(appItem.mId, callback: { (isSuccess, jsonDic) -> Void in
            if (isSuccess) {
                let resultStatus = jsonDic["status"] as! Int
                
                if (resultStatus == 401)
                {
                    NSLog("Error")
                }
                else if (resultStatus == 200)
                {
                    let responseDic = jsonDic["responseObj"]?.mutableCopy() as! NSMutableArray
                    appItem.mReportGroups.removeAllObjects()
                    
                    for report in responseDic {
                        
                        let newReport = Report();
                        newReport.mReportName = report["name"] as! String
                        newReport.mLinkHash = report["linkHash"] as! String
                        
                        appItem.mReportGroups.addObject(newReport)
                    }
                }
                self.tableView.reloadData()
            }else{
                // do error handling here
                self.tableView.reloadData()
            }
            
        })
     }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appItem : AppItem = SharedValue.sharedInstance.gAppsArray[selIndex] as! AppItem
        return appItem.mReportGroups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reportCell", forIndexPath: indexPath) as! ReportCell
        
        let appItem : AppItem = SharedValue.sharedInstance.gAppsArray[selIndex] as! AppItem
        let reportItem : Report = appItem.mReportGroups[indexPath.row] as! Report
        
        cell.nameLbl.text = reportItem.mReportName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ReportDetailVC") as! ReportDetailVC;
        vc.selIndex = selIndex
        vc.selReportId = row
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func onDetail(sender: AnyObject) {
        let deleteBtn = sender as! UIButton
        let view = deleteBtn.superview!
        let cell = view.superview as! ReportCell
        self.selReportId = (self.tableView.indexPathForCell(cell)?.row)!
        
        self.showSocialView(self.selReportId)
    }
    
    func showSocialView(selId : Int)
    {
        let appItem : AppItem = SharedValue.sharedInstance.gAppsArray[selIndex] as! AppItem
        let reportItem : Report = appItem.mReportGroups[selId] as! Report
        
        self.reportLbl.text = reportItem.mReportName
        maskView.hidden = false
        socialView.hidden = false
        
        UIView.animateWithDuration(0.25, delay: 0.3, options: [], animations: {
            self.socialView.frame.origin.y = self.socialView.frame.origin.y - self.socialView.frame.size.height
            }, completion: nil)
    }
    
    func hideSocialView()
    {
        UIView.animateWithDuration(0.25, delay: 0.3, options: [], animations: {
            self.socialView.frame.origin.y = self.socialView.frame.origin.y + self.socialView.frame.size.height
            }, completion: nil)

        maskView.hidden = true
    }
    
    @IBAction func onShareWhatsApp(sender: AnyObject) {
        self.hideSocialView()
        
        let whatsappURL = NSURL(string: "whatsapp://send?text=" + self.getLinkUrl())

        if UIApplication.sharedApplication().canOpenURL(whatsappURL!) {
            UIApplication.sharedApplication().openURL(whatsappURL!)
        }
    }

    @IBAction func onOpenInBrowser(sender: AnyObject) {
        self.hideSocialView()
        
        UIApplication.sharedApplication().openURL(NSURL(string: self.getLinkUrl())!)
    }

    @IBAction func onCopyLink(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = self.getLinkUrl()

        UIView.animateWithDuration(0.25, delay: 0.3, options: [], animations: {
            self.socialView.frame.origin.y = self.socialView.frame.origin.y + self.socialView.frame.size.height
            }, completion: { finished in
                self.copiedView.hidden = false
                UIView.animateWithDuration(10, delay: 5, options: [], animations: {
                    self.copiedView.hidden = false
                    }, completion: { finished in
                        self.copiedView.hidden = true
                })
 
        })
        
        maskView.hidden = true
    }

    func getLinkUrl() -> String
    {
        let appItem : AppItem = SharedValue.sharedInstance.gAppsArray[selIndex] as! AppItem
        let reportItem : Report = appItem.mReportGroups[self.selReportId] as! Report
        
        let dataUrl = kBaseReportHtmlUrl + reportItem.mLinkHash

        return dataUrl
    }
    
    @IBAction func onClose(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}