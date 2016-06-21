//
//  XKRWEditPostVC.swift
//  XKRW
//
//  Created by 忘、 on 16/1/15.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWEditPostVC: XKRWBaseVC,UITextViewDelegate,UIScrollViewDelegate,XKRWPhotoBrowserDelegate,UIAlertViewDelegate {
    
    private let gapWidth: CGFloat = 10.0
    private let imageWidth = (UI_SCREEN_WIDTH - 30 - 10 * 3) / 4
    
    var imageArray: [UIImage] = [UIImage]()
    var imagePaths = [String]()
    var contentIndex: Int?
    var removedPaths: [String] = []
    var addImageButton: UIButton!
    var groupID:String?
    var helpState = "2"
    var sendPostButton:UIButton?
    @IBOutlet weak var postStateButton: UIButton!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentPlaceholder: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titlePlaceholder: UITextView!
    
    @IBOutlet weak var contentLimitLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UIView!
    @IBOutlet weak var imagesCollectionViewHeight: NSLayoutConstraint!
    
    var entity = XKRWUserPostEntity()
    
    var isModified: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadImages()
    }
    
    func initView(){
        
        self.setNavifationItemWithLeftItemTitle("取消", andRightItemTitle: "发布", andItemColor: UIColor.whiteColor(), andShowLeftRedDot: false, andShowRightRedDot: false, andLeftRedDotShowNum: false, andRightRedDotShowNum: false, andLeftItemIcon: nil, andRightItemIcon: nil)
        
        titleTextView.autocapitalizationType = .None
        contentTextView.autocapitalizationType = .None
        
        titleTextView.delegate = self
        contentTextView.delegate = self
        contentScrollView.delegate = self
        self.addImageButton = {
            let button = UIButton(frame: CGRectMake(15, 15, self.imageWidth, self.imageWidth))
            button.backgroundColor = UIColor.clearColor()
            button.setBackgroundImage(UIImage(named: "add_"), forState: .Normal)
            
            button.addTarget(self, action: #selector(XKRWEditPostVC.addImageAction), forControlEvents: .TouchUpInside)
            
            return button
            }()
        
        imagesCollectionView.addSubview(addImageButton)
        
    }
    
    
    @IBAction func postStateAction(sender: UIButton) {
        postStateButton.selected = !postStateButton.selected
        if postStateButton.selected {
            helpState = "1"
        }else{
            helpState = "2"
        }
        
    }
    
    override func leftItemAction(button: UIButton!) {
        
        let alertView = UIAlertView(title: "退出后,已编辑的内容将丢失,是否退出?", message:"", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "取消","确定")
        alertView.delegate = self
        
        alertView .show()
        
    }
    
    override func rightItemAction(button: UIButton!) {
        MobClick.event("clk_PushPost2")
        sendPostButton = button
        
        self.upLoadPostToNetwork()
    }
    
    //MARK: UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1){
            self.dismissViewControllerAnimated(true) { () -> Void in
                
            }
        }
    }
    
    
    //MARK: UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(textView.tag == 10000){
            if textView.text.length >= 30 && text != "" && text.length > range.length {
                return false
            }
            
            if text != "" {
                self.titlePlaceholder.hidden = true
            } else if range.location == 0 && range.length == 1 {
                self.titlePlaceholder.hidden = false
            }
        }
        
        if(textView.tag == 10001){
            if textView.text.length >= 2000 && text != "" && text.length > range.length {
                return false
            }
            
            if text != "" {
                self.contentPlaceholder.hidden = true
            } else if range.location == 0 && range.length == 1 {
                self.contentPlaceholder.hidden = false
            }
        }
        
        return true
    }
    
    
    func textViewDidChange(textView: UITextView) {
        if(textView.tag == 10000){
            if textView.text.length > 30 && textView.markedTextRange == nil {
                XKRWCui.showInformationHudWithText("超过30字了哦~")
                self.setWordsNumber(30,maxNumber: 30)
                let textStr = (textView.text as NSString).substringToIndex(30)
                textView.text = textStr as String
            } else {
                
                let length = textView.text?.length
                
                if(textView.text != nil){
                    let str:NSString = NSString(string: textView.text!)
                    if(str.isContainString("&")){
                        XKRWCui.showInformationHudWithText("包含特殊字符&")
                        textView.text = textView.text!.substringToIndex(textView.text!.startIndex.advancedBy(length!-1))
                    }
                }
                
                self.setWordsNumber(textView.text.length,maxNumber: 30)
            }
        }else if(textView.tag == 10001){
            if textView.text.length > 2000 && textView.markedTextRange == nil {
                XKRWCui.showInformationHudWithText("超过2000字了哦~")
                self.setWordsNumber(2000,maxNumber: 2000)
                let textStr = (textView.text as NSString).substringToIndex(2000)
                textView.text = textStr as String
            } else {
                
                let length = textView.text?.length
                
                if(textView.text != nil){
                    let str:NSString = NSString(string: textView.text!)
                    if(str.isContainString("&")){
                        XKRWCui.showInformationHudWithText("包含特殊字符&")
                        textView.text = textView.text!.substringToIndex(textView.text!.startIndex.advancedBy(length!-1))
                    }
                }
                
                self.setWordsNumber(textView.text.length,maxNumber: 2000)
            }
        }
        
        
        self.isModified = true
    }
    
    
    //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if self.contentTextView.isFirstResponder() {
            self.contentTextView.resignFirstResponder()
        }
        
        if self.titleTextView.isFirstResponder() {
            self.titleTextView.resignFirstResponder()
        }
        
    }
    
    //MARK: UIScrollViewDelegate
    func photoBrowserVC(vc: XKRWPhotoBrowserVC, deleteImageAtIndex index: Int) {
        
        if let path = self.imageArray.removeAtIndex(index).path {
            self.removedPaths.append(path)
            self.isModified = true
        }
    }
    
    
    
    //MARK: Tools
    func setWordsNumber(number: Int,maxNumber:Int) {
        if(maxNumber == 30){
            self.limitLabel.text = "\(number)/\(maxNumber)"
        }else{
            self.contentLimitLabel.text = "\(number)/\(maxNumber)"
        }
    }
    
    
    func addImageAction() -> Void {
        
        let vc = MLSelectPhotoPickerViewController()
        vc.minCount = 9 - self.imageArray.count
        
        weak var weakSelf = self
        vc.callBack = { (obj: AnyObject?) in
            
            XKRWCui.showProgressHud("载入照片中")
            weakSelf?.isModified = true
            
            if let assets = obj as? [MLSelectPhotoAssets] {
                
                for temp in assets {
                    weakSelf?.imageArray.append(temp.originImage())
                }
            }
            print(weakSelf?.imageArray)
            weakSelf?.reloadImages()
            XKRWCui.hideProgressHud()
        }
        vc.showPickerVc(self)
    }
    
    
    func reloadImages() {
        
        for view in self.imagesCollectionView.subviews {
            view.removeFromSuperview()
        }
        var xPoint: CGFloat = 15.0
        var yPoint: CGFloat = 15.0
        
        var tag = 0
        for image in self.imageArray {
            
            if xPoint >= UI_SCREEN_WIDTH - 15 {
                xPoint = 15.0
                yPoint += imageWidth + gapWidth
            }
            
            let view = UIButton(frame: CGRectMake(xPoint, yPoint, imageWidth, imageWidth))
            view.imageView?.contentMode = .ScaleAspectFill
            view.tag = tag++
            view.setImage(image, forState: .Normal)
            
            view.addTarget(self, action: "handleClickAction:", forControlEvents: .TouchUpInside)
            self.imagesCollectionView.addSubview(view)
            
            xPoint += imageWidth + gapWidth
        }
        
        if self.imageArray.count < 9 {
            
            if xPoint >= UI_SCREEN_WIDTH - 15 {
                xPoint = 15.0
                yPoint += imageWidth + gapWidth
            }
            
            self.addImageButton.left = xPoint
            self.addImageButton.top = yPoint
            
            self.imagesCollectionView.addSubview(self.addImageButton)
        }
        self.imagesCollectionViewHeight.constant = yPoint + imageWidth + 15.0
    }
    
    func handleClickAction(sender: UIButton) -> Void {
        let vc = XKRWPhotoBrowserVC()
        vc.images = self.imageArray
        vc.currentIndex = sender.tag
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    //MARK: NetWorkDeal
    
    func upLoadPostToNetwork(){
        
        entity.postGroupID = groupID
        print(imageArray)
        entity.originalImages = imageArray
        entity.postTitle = titleTextView.text
        entity.textContent = contentTextView.text
        entity.helpPost = helpState
        if(entity.checkComplete()){
            sendPostButton?.enabled = false
            if(imageArray .count > 0){
                XKRWCui.showProgressHud("正在上传图片")
            }else{
                XKRWCui.showProgressHud("正在发布帖子")
            }
            self.downloadWithTaskID("upLoadImage", task: { () -> Void in
                XKRWUserArticleService.shareService.uploadPictureWithEntity(&self.entity, callback: { (isSuccess) -> Void in
                    
                    if isSuccess {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            XKRWCui.hideProgressHud()
                            XKRWCui.showProgressHud("正在发布帖子")
                        })
                        self.downloadWithTaskID("uploadPost", outputTask: { () -> AnyObject! in
                            print(self.entity)
                            return XKRWUserArticleService.shareService.uploadPostWithEntity(self.entity)
                        })
                    } else {
                        self.sendPostButton?.enabled = true
                        Log.debug_println("upload failed")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            XKRWCui.hideProgressHud()
                            XKRWCui.showInformationHudWithText("上传图片失败")
                        })
                    }
                })
            })
        }
    }
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        
        if taskID == "uploadPost"{

            self.sendPostButton?.enabled = true
            
            if let transfer = result as? [String: AnyObject],
                let data = transfer["data"] as? NSDictionary {
                    
                    Log.debug_println(data)
                    
                    if let _ = data["postid"] as? String {
                        
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.75 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                            XKRWCui.showInformationHudWithText("发布成功")
                            NSNotificationCenter.defaultCenter().postNotificationName("ReportSuccessTorefreshData", object:     nil)
                            self.dismissViewControllerAnimated(true
                                , completion: { () -> Void in
                                    
                            })
                            
                        }
                        
                    } else {
                        // 失败异常
                        Log.debug_println(data)
                        
                        let alert = UIAlertView(title: "发布失败", message: data["msg"] as? String, delegate: nil, cancelButtonTitle: "知道了")
                        alert.show()
                    }
            }
            else {
                XKRWCui.showInformationHudWithText("发布失败，未知错误")
            }
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        super.handleUploadProblem(problem, withTaskID: taskID)
        if taskID == "uploadPost" {
            self.sendPostButton?.enabled = true
        }
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
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




