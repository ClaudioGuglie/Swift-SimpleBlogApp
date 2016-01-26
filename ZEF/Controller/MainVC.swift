//
//  MainVC.swift
//  ZEF
//
//  Created by Claudio on 11/12/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit
//import SwiftyJSON
import Alamofire
import ImageLoader

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var mAppsList : NSMutableArray = NSMutableArray();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        self.loadAppItems()

        self.refreshControl.backgroundColor = UIColor.clearColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if revealViewController() != nil {
            menuBtn.addTarget(revealViewController(), action: "revealToggle:", forControlEvents: .TouchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func refresh(sender:AnyObject)
    {
        self.loadAppItems()
    }
    
    func loadAppItems()
    {
        
        let apiRequest = ApiRequest()
        
        apiRequest.getAppsRequest({ (isSuccess, jsonDic) -> Void in
            if (isSuccess) {
                //do good stuff here
                let resultDic = jsonDic["result"] as! NSDictionary
                let resultStatus = resultDic["status"]
                
                if (resultStatus!.isEqual("ok"))
                {
                    self.mAppsList.removeAllObjects()
                    let tempApps = jsonDic["apps"] as! NSMutableArray
                    self.mAppsList = tempApps.mutableCopy() as! NSMutableArray
                    SharedValue.sharedInstance.gAppsArray.removeAllObjects()

                    self.loadReportGroupList()
                    
                }
                else if (resultStatus!.isEqual("error"))
                {
                    self.refreshControl.endRefreshing()
                    NSLog("Fail to get apps")
                }
                
            }else{
                // do error handling here
                self.refreshControl.endRefreshing()
                NSLog("Fail to get apps")
            }
        })
    }
    
    func loadReportGroupList()
    {
        if (self.mAppsList.count <= 0)
        {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()

            return
        }

        let firstApp = self.mAppsList.objectAtIndex(0)
        
        self.loadReport(firstApp as! NSDictionary)
    }
    
    func loadReport (appDic : NSDictionary)
    {
        let apiRequest = ApiRequest()
        
        let appId = appDic.valueForKey("id") as? NSNumber
        let appIdStr = appId?.stringValue
        var lastHours = 0
        var userCount = 0

        let newApp = AppItem();
        
        newApp.mId = appIdStr!
        newApp.mName = appDic["name"] as! String
        newApp.mType = appDic["type"] as! String
        newApp.mCreated = self.convertDateFormater(appDic["created"] as! String)
        newApp.mModified = self.convertDateFormater(appDic["modified"] as! String)
        
        let shareDic = appDic["sharing"] as! NSDictionary
        let tempImgUrl = shareDic["shareImageUrl"] as! String
        
        if (tempImgUrl.containsString("http:"))
        {
            newApp.mShareImageUrl = tempImgUrl
        }
        else
        {
            newApp.mShareImageUrl = "http:" + tempImgUrl;
        }

        apiRequest.getReportRequest(appIdStr!, callback: { (isSuccess, jsonDic) -> Void in
            if (isSuccess) {
                //do good stuff here
                let resultStatus = jsonDic["status"] as! Int
                let userAuthorized = jsonDic["userAuthorized"] as! Bool
                
                if (resultStatus == 404 && userAuthorized)
                {
                    lastHours = 0
                    userCount = 0
                }
                else if (resultStatus == 200)
                {
                    let responseDic = jsonDic["responseObj"] as! NSMutableDictionary
                    let jsonModelDic = responseDic["jsonModel"] as! NSMutableDictionary
                    lastHours = jsonModelDic["last24hours"] as! Int
                    userCount = jsonModelDic["totalCount"] as! Int
                }
                else
                {
                    NSLog("Fail to get report")
                }
                
                newApp.mLastHours = lastHours
                newApp.mUsersCount = userCount
                
                SharedValue.sharedInstance.gAppsArray.addObject(newApp)
                
                if (self.mAppsList.count <= 0)
                {
                    self.loadReportGroupList()
                    return
                }
                self.mAppsList.removeObjectAtIndex(0)
                self.loadReportGroupList()
                
            }else{
                // do error handling here
                SharedValue.sharedInstance.gAppsArray.addObject(newApp)
                self.mAppsList.removeObjectAtIndex(0)
                self.loadReportGroupList()
                
            }
            
        })
    }
    
    func convertDateFormater(date: String) -> String
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(date)
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"///this is you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        
        return timeStamp
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedValue.sharedInstance.gAppsArray.count
    }
    
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return calculateHeight()
    }
    
    func calculateHeight () -> CGFloat {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            return 600 // iPad
        } else {
            return 300 // iPhone
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("blogCell", forIndexPath: indexPath) as! BlogCell

        if (SharedValue.sharedInstance.gAppsArray.count <= 0 || indexPath.row >= SharedValue.sharedInstance.gAppsArray.count)
        {
            return cell
        }
        let appItem : AppItem = SharedValue.sharedInstance.gAppsArray[indexPath.row] as! AppItem

        cell.nameLbl.text = appItem.mName;
        cell.appImgView.image = nil
        dispatch_async(dispatch_get_main_queue()) {
            cell.appImgView.load(appItem.mShareImageUrl, placeholder: nil) { _ in
            }
        }
        
        let typeImgStr = cell.getTypeImageName(appItem.mType)
        let typeImg: UIImage = UIImage(named: typeImgStr)!
        cell.typeImgView.image = typeImg
        
        cell.usersLbl.text = String(appItem.mUsersCount)
        cell.lastHourLbl.text = String(appItem.mLastHours)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("AppDetailVC") as! AppDetailVC;
        vc.selIndex = row
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func onDetail(sender: AnyObject) {
        let detailBtn = sender as! UIButton
        let view = detailBtn.superview!
        let cell = view.superview?.superview as! BlogCell
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ReportGroupsVC") as! ReportGroupsVC;
        vc.selIndex = (self.tableView.indexPathForCell(cell)?.row)!
        self.navigationController?.pushViewController(vc, animated: true);
    }
}
