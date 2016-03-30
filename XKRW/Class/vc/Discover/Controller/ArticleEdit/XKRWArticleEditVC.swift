//
//  XKRWArticleEditVC.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/18.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWArticleEditVC: XKRWBaseVC {
    
    var testDictionary: [String: AnyObject]!
    var tableView: UITableView!
    
    var calculateView: XKRWArticleSectionView!
    var selectionView: KMPopSelectionView!
    var selectPicCell: XKRWArticleSelecPicCell!
    
    var saveButton: UIBarButtonItem!
    
    /// Not used for 5.1.0
    var draft: XKRWUserArticleEntity?
    // --------------------------------------
    
    var articleEntity = XKRWUserArticleEntity()
    var topics: [XKRWTopicEntity] = []
    
    var needReload: Bool = false
    var isImagesUploaded: Bool = false
    
    private var startTime: NSTimeInterval = 0
    private var uploadedTime: NSTimeInterval = 0
    private var finishTime: NSTimeInterval = 0
    
    var debugMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        func initData() {
            
            self.downloadWithTaskID("getTopics") { () -> AnyObject! in
                return XKRWUserArticleService.shareService.getTopicList()
            }
            
            if self.draft != nil {
                NSDictionary(propertiesFromObject: self.draft!).setPropertiesToObject(self.articleEntity)
                self.articleEntity.loadLocalImageCache()
                
                Log.debug_println(self.articleEntity.topic?.topicId)
            }
        }
        initData()
        
        self.title = "写分享"
        
        self.addNaviBarBackButton()
        
        self.saveButton = UIBarButtonItem(title: "发布", style: UIBarButtonItemStyle.Plain, target: self, action: "saveAction")
        let preview = UIBarButtonItem(title: "预览", style: UIBarButtonItemStyle.Plain, target: self, action: "previewAction")
        let fixed = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixed.width = 20.0
        
        self.navigationItem.rightBarButtonItems = [self.saveButton, fixed, preview]
        
        self.tableView = {
            
            let tableView = UITableView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, self.view.height - 64), style: .Plain)
            tableView.separatorStyle = .None
            tableView.backgroundColor = XK_BACKGROUND_COLOR
            self.view.addSubview(tableView)
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.keyboardDismissMode = .OnDrag
            
            tableView.registerNib(UINib(nibName: "XKRWEntryCell", bundle: nil), forCellReuseIdentifier: "entryCell")
            tableView.registerNib(UINib(nibName: "XKRWTextFieldCell", bundle: nil), forCellReuseIdentifier: "textFieldCell")
            tableView.registerNib(UINib(nibName: "XKRWArticleSelecPicCell", bundle: nil), forCellReuseIdentifier: "selectPicCell")
            tableView.registerNib(UINib(nibName: "XKRWAddSectionCell", bundle: nil), forCellReuseIdentifier: "addSectionCell")
            tableView.registerClass(XKRWArticleSectionCell.self, forCellReuseIdentifier: "sectionCell")
            
            return tableView
        }()
        
        self.calculateView = {
            let view = XKRWArticleSectionView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 10))
            return view
        }()
        
        self.selectPicCell = {
            return tableView.dequeueReusableCellWithIdentifier("selectPicCell") as! XKRWArticleSelecPicCell
        }()
        
        self.selectionView = {
            
            let options: NSMutableDictionary = [KMPSV_Text_alignment: NSNumber(integer: NSTextAlignment.Left.rawValue)]
            
            let view = KMPopSelectionView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 0), type: KMPopSelectionViewType.Default, titles: self.topics, options: options)
            view.delegate = self
            view.backColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
            
            return view
        }()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.needReload {
            self.needReload = false
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveAction() -> Void {
        
        MobClick.event("clk_publish")
        
        if self.articleEntity.checkComplete() {

            XKRWCui.showProgressHud("正在上传图片")
            
            self.startTime = NSDate().timeIntervalSince1970 * 1000
            
            // upload to server
            self.downloadWithTaskID("uploadImages", task: { () -> Void in
                
                XKRWUserArticleService.shareService.uploadPicturesWithEntity(&self.articleEntity, callback: { (isSuccess) -> Void in
                    if isSuccess {
                        self.uploadedTime = NSDate().timeIntervalSince1970 * 1000
                        
                        self.downloadWithTaskID("uploadArticle", outputTask: { () -> AnyObject! in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                XKRWCui.showProgressHud("正在发布瘦身分享")
                            })
                            return XKRWUserArticleService.shareService.uploadArticleWithEntity(self.articleEntity)
                        })
                    } else {
                        Log.debug_println("upload failed")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            XKRWCui.hideProgressHud()
                            XKRWCui.showInformationHudWithText("上传图片失败")
                        })
                    }
                })
            })
            
        } else {
            XKRWCui.showInformationHudWithText("请完成文章信息")
        }
    }

    func previewAction() -> Void {
        
        MobClick.event("clk_preview")
        
        if self.articleEntity.checkComplete() {
            let vc = XKRWUserArticleVC()
            vc.articleEntity = self.articleEntity
            vc.isPreview = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            XKRWCui.showInformationHudWithText("请完成文章信息")
        }
    }
    
    override func popView() {
        
        if self.articleEntity.checkNeedSaveAsDraft() {
            
            self.view.endEditing(true)
            let sheet = XKRWActionSheet(title: "需要保存为草稿么？", cancelButtonTitle: "取消", destructiveButtonTitle: "删除草稿", otherButtonTitle: nil)
            sheet.delegate = self
            sheet.addButtonWithTitle("保存草稿")
            sheet.showInView(self.view)
        } else {
            super.popView()
        }
    }
    
    // MARK: - Networking
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        
        if taskID == "getTopics" {
            self.topics = result as! [XKRWTopicEntity]
            
        } else if taskID == "uploadArticle" {
            
            if self.debugMode {
                
                self.finishTime = NSDate().timeIntervalSince1970 * 1000
                
                let compressCost = (XKRWUserArticleService.shareService.compressedTime - self.startTime) / 1000
                let upload = (self.uploadedTime - XKRWUserArticleService.shareService.compressedTime) / 1000
                let publish = (self.finishTime - self.uploadedTime) / 1000
                
                let msg = "compressed cost: \(compressCost)\nupload cost: \(upload)\npublish cost: \(publish)\n(单位：s)"
                
                let alert = UIAlertView(title: "debug info", message: msg, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
            XKRWCui.hideProgressHud()
            
            if let transfer = result as? [String: AnyObject],
               let data = transfer["data"] as? NSDictionary {
                
                Log.debug_println(data)
                
                if let _ = data["blogid"] as? String {
                    // 成功
                    XKRWCui.showInformationHudWithText("发布成功")
                    
                    self.articleEntity.status = XKRWUserArticleStatus.Unrecommended
                    XKRWUserArticleService.shareService.saveArticleToDatabaseWithEntity(self.articleEntity)
                    
                    super.popView()
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
        super.handleDownloadProblem(problem, withTaskID: taskID)
        XKRWCui.hideProgressHud()
    }
}

// MARK: - UITableView's delegate & datasource
extension XKRWArticleEditVC: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: Header
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: Cell
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return self.articleEntity.textContent.count + 2
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 44.00
        case 1:
            return 96.00
        case 2:
            if indexPath.row == 0 {
                return 30
            }
            else if indexPath.row < self.articleEntity.textContent.count + 1 {
                
                return self.calculateView.calculateSizeWithText(self.articleEntity.textContent[indexPath.row - 1], imageURLs: nil, ifHaveImages: self.articleEntity.originalImages[indexPath.row - 1]).size.height + 44
            } else {
                return 151
            }
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath) as? XKRWEntryCell {
                    
                    cell.titleLabel.font = UIFont.systemFontOfSize(14)
                    if self.articleEntity.topic ==  nil {
                        cell.titleLabel.text = "#添加话题#"
                        cell.titleLabel.textColor = XK_ASSIST_TEXT_COLOR
                    } else {
                        cell.titleLabel.text = self.articleEntity.topic!.name
                        cell.titleLabel.textColor = XK_TEXT_COLOR
                    }
                    cell.bottomLineLeadingSpace = 15
                    
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell") as? XKRWTextFieldCell {
                    
                    cell.textField.attributedPlaceholder = NSAttributedString(string: "添加标题", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14), NSForegroundColorAttributeName: XK_ASSIST_TEXT_COLOR])
                    cell.textField.font = UIFont.systemFontOfSize(14)
                    
                    if !self.articleEntity.articleTitle.isEmpty {
                        cell.textField.text = self.articleEntity.articleTitle
                    }
                    
                    cell.textField.delegate = self
                    cell.textField.clearButtonMode = .WhileEditing

                    cell.textField.addTarget(self, action: "changeTextField:", forControlEvents: .EditingChanged)
                    cell.topLine.hidden = true
                    
                    return cell
                }
            }
        case 1:
            if self.articleEntity.mainPicture != nil {
                self.selectPicCell.thumbImageView.image = self.articleEntity.mainPicture!
                self.selectPicCell.titleLabel.textColor = XK_TEXT_COLOR
            } else {
                self.selectPicCell.titleLabel.textColor = XK_ASSIST_TEXT_COLOR
            }
            return self.selectPicCell
        case 2:
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCellWithIdentifier("titleCell")
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "titleCell")
                    cell!.selectionStyle = .None
                    
                    let label = UILabel(frame: CGRectMake(15, 10, 100, 20))
                    label.font = UIFont.systemFontOfSize(14)
                    label.text = "正文"
                    label.tag = 101
                    
                    cell!.contentView.addSubview(label)
                }
                let label = cell!.contentView.viewWithTag(101) as! UILabel
                
                if self.articleEntity.originalImages.count > 0 {
                    label.textColor = XK_TEXT_COLOR
                } else {
                    label.textColor = XK_ASSIST_TEXT_COLOR
                }
                return cell!
            }
            else if indexPath.row < self.articleEntity.textContent.count + 1{
                
                let cell = tableView.dequeueReusableCellWithIdentifier("sectionCell") as! XKRWArticleSectionCell
                
                if indexPath.row == 1 {
                    cell.topLine.hidden = true
                } else {
                    cell.topLine.hidden = false
                }

                cell.setContentWithText(self.articleEntity.textContent[indexPath.row - 1], imageURLs: nil, ifHaveImages: self.articleEntity.originalImages[indexPath.row - 1], sectionNumber: indexPath.row)
                
                cell.actionEnable = false
                
                cell.moreButtonClickAction = {
                    
                    let option = KMSimpleMenuOption(backgroundColor: XK_TEXT_COLOR, textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14))
                    
                    let menu = KMSimpleMenu(titles: ["编辑", "删除"], type: KMSimpleMenuType.Landscape, option: option)
                    menu.clickAction = { (index: Int) -> Void in
                        if index == 0 {
                            // edit
                            let vc = XKRWUserArticleSectionEditVC(nibName: "XKRWUserArticleSectionEditVC", bundle: nil)
                            vc.articleEntity = self.articleEntity
                            vc.contentIndex = indexPath.row - 1
                            
                            self.needReload = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            // delete
                            self.articleEntity.deleteContentAtIndex(indexPath.row - 1)
                            self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
                        }
                    }   
                    menu.showAtPoint(CGPointMake(UI_SCREEN_WIDTH - 200, 10), direction: KMDirection.Left, inView: cell.contentView)
                }
                return cell
            }
            else {
                if let cell = tableView.dequeueReusableCellWithIdentifier("addSectionCell") as? XKRWAddSectionCell {
                    cell.descLabel.text = "第\(indexPath.row)段"
                    cell.nextLabel.text = "第\(indexPath.row + 1)段"
                    return cell
                }
            }
        default:
            return UITableViewCell()
        }
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "noneCell")
        cell.contentView.backgroundColor = UIColor.blackColor() 
        return cell
    }
    
    // MARK: Action
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                
                let cell = tableView.cellForRowAtIndexPath(indexPath)!
                cell.setSelected(false, animated: true)
                
                if self.selectionView.isShown {
                    self.selectionView.hide()
                    
                } else {
                    var titles = [String]()
                    
                    for topic in self.topics {
                        if topic.enabled {
                            titles.append(topic.name)
                        }
                    }
                    self.selectionView.setCellTitles(titles)
                    if (self.selectionView.size.height > (self.view.bounds.height - 54)) {
                        self.selectionView.tableView.scrollEnabled = true
                        self.selectionView.tableView.frame.size = CGSizeMake(UI_SCREEN_WIDTH, self.view.bounds.height - 54)
                    }
                    self.selectionView.doAnimationToPoint(CGPointMake(0, 54), inView: self.tableView, fromDirection: KMDirection.Up)
                }
            } else {
                
            }
        case 1:
            
            cell.setSelected(false, animated: true)
            
            // if wants to entry different vc, user method below
            if self.articleEntity.mainPicture != nil {

                let vc = XKRWPhotoBrowserVC()
                
                let attributes = [
                    NSFontAttributeName: UIFont.systemFontOfSize(14),
                    NSForegroundColorAttributeName: UIColor.whiteColor()
                ]
                let attributeString = NSAttributedString(string: "更换", attributes: attributes)
                
                vc.rightNavigationItemOption = XKRWPhotoBrowserVC.PBVCRightNaviItemOption(icon: UIImage(), text: attributeString) { (photoBrowserVC) -> Void in
                    
                    photoBrowserVC.dismissViewControllerAnimated(true, completion: nil)
                    
                    let pickerVC = UIImagePickerController()
                    pickerVC.allowsEditing = false
                    pickerVC.sourceType = .PhotoLibrary
                    pickerVC.delegate = self
                    
                    self.presentViewController(pickerVC, animated: true, completion: nil)
                }
                vc.images = [self.articleEntity.mainPicture!]
                self.presentViewController(vc, animated: true, completion: nil)
            }
            else {

                let vc = UIImagePickerController()
                vc.allowsEditing = false
                vc.sourceType = .PhotoLibrary
                vc.delegate = self

                self.presentViewController(vc, animated: true, completion: nil)
            }
        case 2:
            if indexPath.row == 0 {
                
            }
            else if indexPath.row < self.articleEntity.textContent.count + 1 {
                
                let vc = XKRWUserArticleSectionEditVC(nibName: "XKRWUserArticleSectionEditVC", bundle: nil)
                vc.articleEntity = self.articleEntity
                vc.contentIndex = indexPath.row - 1
                
                self.needReload = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                if self.articleEntity.originalImages.count < 10 {
                    
                    let vc = MLSelectPhotoPickerViewController()
                    vc.minCount = 9
                    
                    weak var weakSelf = self
                    vc.callBack = { (obj: AnyObject?) in
                        
                        var imageArray = [UIImage]()
                        
                        if let assets = obj as? [MLSelectPhotoAssets] {
                            
                            for temp in assets {
                                imageArray.append(temp.originImage())
                            }
                        }
                        let editVC = XKRWUserArticleSectionEditVC(nibName: "XKRWUserArticleSectionEditVC", bundle: nil)
                        editVC.articleEntity = self.articleEntity
                        editVC.imageArray =  imageArray
                        
                        weakSelf?.navigationController?.pushViewController(editVC, animated: true)
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                            weakSelf?.needReload = true
                        }
                    }
                    vc.showPickerVc(self)
                    
                } else {
                    XKRWCui.showInformationHudWithText("最多只能编写十段内容哦~")
                }
            }
        default:
            break
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension XKRWArticleEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        let vc = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.Custom)
        vc.delegate = self
        vc.dataSource = self
        vc.avoidEmptySpaceAroundImage = true
        vc.rotationEnabled = false
        
        picker.pushViewController(vc, animated: true)
    }
}

// MARK: - RSKImageCropViewControllerDelegate & datasource

extension XKRWArticleEditVC: RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource {
    
    // Datasource:
    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController!) -> CGRect {
        
        let maskSize = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_WIDTH * kCoverRatio)
        
        return CGRectMake(0, (controller.view.height - maskSize.height) * 0.5, maskSize.width, maskSize.height)
    }
    
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController!) -> UIBezierPath! {
        
        let rect = controller.maskRect
        let point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))
        let point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        let point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))
        let point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))
        
        let path = UIBezierPath()
        
        path.moveToPoint(point1)
        path.addLineToPoint(point2)
        path.addLineToPoint(point3)
        path.addLineToPoint(point4)
        path.closePath()
        
        return path;
    }
    
    // Delegate:
    
    func imageCropViewController(controller: RSKImageCropViewController!, didCropImage croppedImage: UIImage!, usingCropRect cropRect: CGRect) {
        
        controller.dismissViewControllerAnimated(true) { () -> Void in
            
            self.selectPicCell.thumbImageView.image = croppedImage
            self.selectPicCell.titleLabel.textColor = XK_TEXT_COLOR
            
            if self.articleEntity.mainPicture?.path != nil {
                XKRWUserArticleService.removeCachedImageWithPath(self.articleEntity.mainPicture!.path!)
            }
            self.articleEntity.mainPicture = croppedImage
        }
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController!) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension XKRWArticleEditVC: UITextFieldDelegate {
    
    func changeTextField(textField: UITextField) {
        if textField.text?.length >= 18 && textField.markedTextRange == nil {
            let title = textField.text!.substringToIndex(textField.text!.startIndex.advancedBy(18))
            textField.text = title
            self.articleEntity.articleTitle = title
            return
            
        } else {
            
            let length = textField.text?.length
            
            if(textField.text != nil){
                let str:NSString = NSString(string: textField.text!)
                if(str.isContainString("&")){
                    XKRWCui.showInformationHudWithText("包含特殊字符&")
                    textField.text = textField.text!.substringToIndex(textField.text!.startIndex.advancedBy(length!-1))
                    self.articleEntity.articleTitle = textField.text!
                }else{
                    self.articleEntity.articleTitle = textField.text!
                }
            }
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text!.length >= 18 && string != "" && string.length > range.length {
            XKRWCui.showInformationHudWithText("标题最长为18个字")
            return false
        }
        return true
    }
    
    
    

    
}

// MARK: - KMPopSelectionViewDelegate

extension XKRWArticleEditVC: KMPopSelectionViewDelegate {
    
    func popSelectionView(view: KMPopSelectionView!, didSelectIndex index: Int) {
        
        self.articleEntity.topic = self.topics[index]
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.cellForRowAtIndexPath(indexPath)!.setSelected(false, animated: true)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        
        view.hide()
    }
    
    func popSelectionViewDidCancel(view: KMPopSelectionView!) {
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.cellForRowAtIndexPath(indexPath)!.setSelected(false, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension XKRWArticleEditVC: UIGestureRecognizerDelegate {
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        super.touchesBegan(touches, withEvent: event)
//        
//        self.tableView.endEditing(true)
//    }
}

// MARK: - UIActionSheetDelegate

extension XKRWArticleEditVC: XKRWActionSheetDelegate {
    func actionSheet(actionSheet: XKRWActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == actionSheet.destructiveButtonIndex {
        XKRWUserArticleService.shareService.deleteLocalArticleWithEntity(self.articleEntity)
            super.popView()
        } else if buttonIndex == 0 {
            self.articleEntity.status = .Draft
            XKRWUserArticleService.shareService.saveDraftWithEntity(self.articleEntity)
            if self.draft != nil {
                NSDictionary(propertiesFromObject: self.articleEntity).setPropertiesToObject(self.draft!)
            }
            
            super.popView()
        }
    }
}
