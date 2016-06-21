//
//  XKRWUserArticleSectionEditVC.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/21.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWUserArticleSectionEditVC: XKRWBaseVC {
    
    weak var articleEntity: XKRWUserArticleEntity?
    
    private let gapWidth: CGFloat = 10.0
    private let imageWidth = (UI_SCREEN_WIDTH - 30 - 10 * 3) / 4
    
    var imageArray: [UIImage] = [UIImage]()
    var imagePaths = [String]()
    
    var contentIndex: Int?
    
    var removedPaths: [String] = []

    @IBOutlet weak var contentScrollView: UIScrollView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholder: UITextView!
    
    @IBOutlet weak var wordsNumberLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UIView!
    @IBOutlet weak var imagesCollectionViewHeight: NSLayoutConstraint!
    
    var addImageButton: UIButton!
    
    var isModified: Bool = false
    
    // MARK: - System's function
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        assert(self.articleEntity != nil, "XKRWUserArticleSectionEditVC:--必须传入文章实体")
        
        
        if self.imageArray .count > 0{
            isModified = true
        }
        
        
        self.addNaviBarBackButton()
        self.addNaviBarRightButtonWithText("完成", action: #selector(XKRWBaseVC.rightItemAction(_:)))
        
        self.addImageButton = {
            let button = UIButton(frame: CGRectMake(15, 15, self.imageWidth, self.imageWidth))
            button.backgroundColor = UIColor.clearColor()
            button.setBackgroundImage(UIImage(named: "add_"), forState: .Normal)
            
            button.addTarget(self, action: #selector(XKRWUserArticleSectionEditVC.addImageAction), forControlEvents: .TouchUpInside)
            
            return button
        }()
        
        if self.contentIndex != nil && self.contentIndex < self.articleEntity!.originalImages.count {
            
            self.imageArray = self.articleEntity!.originalImages[self.contentIndex!]
            self.textView.text = self.articleEntity!.textContent[self.contentIndex!]
            self.setWordsNumber(self.textView.text.length)
            
            self.placeholder.hidden = true
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.5
        
        self.textView.typingAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(14),NSForegroundColorAttributeName: XK_TEXT_COLOR, NSParagraphStyleAttributeName: paragraphStyle]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    override func rightItemAction(button: UIButton!) {
        
        self.saveAction()
    }
    
    func saveAction() -> Void {
        
        // do check
        
        if self.imageArray.count == 0 {
            XKRWCui.showInformationHudWithText("必须包含至少一张图片")
            return
        }
        
        // do delete if be edited
        
        for path in self.removedPaths {
            XKRWUserArticleService.removeCachedImageWithPath(path)
        }
        
        // do save
        
        if self.contentIndex != nil {
            self.articleEntity?.textContent[self.contentIndex!] = self.textView.text
            self.articleEntity?.originalImages[self.contentIndex!] = self.imageArray
        }
        else {
            self.articleEntity?.textContent.append(self.textView.text)
            self.articleEntity?.originalImages.append(self.imageArray)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func popView() {
        
        self.textView.resignFirstResponder()
        
        if self.isModified {
            
            if self.imageArray.count != 0 || !self.textView.text.isEmpty {
                let alert = UIAlertView(title: nil, message: "修改不会保存,\n确定退出？", delegate: self, cancelButtonTitle: "取消")
                alert.addButtonWithTitle("确定")
                alert.show()
            } else {
                super.popView()
            }
        } else {
            super.popView()
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
    
    func setWordsNumber(number: Int) {
        
        self.wordsNumberLabel.text = "\(number)/200字"
    }
}


extension XKRWUserArticleSectionEditVC: XKRWPhotoBrowserDelegate {
    
    func photoBrowserVC(vc: XKRWPhotoBrowserVC, deleteImageAtIndex index: Int) {
        
        if let path = self.imageArray.removeAtIndex(index).path {
            self.removedPaths.append(path)
            self.isModified = true
        }
    }
}

// MARK: - UITextViewDelegate

extension XKRWUserArticleSectionEditVC: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text.length >= 200 && text != "" && text.length > range.length {
            return false
        }
        
        if text != "" {
            self.placeholder.hidden = true
        } else if range.location == 0 && range.length == 1 {
            self.placeholder.hidden = false
        }
        
        

        return true
    }
    
    func textViewDidChange(textView: UITextView) {

        if textView.text.length > 200 && textView.markedTextRange == nil {
            XKRWCui.showInformationHudWithText("超过200字了哦~")
            self.setWordsNumber(200)
            
            let textStr = (textView.text as NSString).substringToIndex(200)
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

            self.setWordsNumber(textView.text.length)
        }
        self.isModified = true
    }
}

func contentSizeOfTextView(text: String, textWidth:CGFloat) -> CGSize {
    
    let mutableStr = XKRWUtil.createAttributeStringWithString(text, font: UIFont.systemFontOfSize(14), color: UIColor.blackColor(), lineSpacing: 3.5, alignment: NSTextAlignment.Left)
    let textSize = mutableStr.boundingRectWithSize(CGSizeMake(textWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil
    ).size
    
    return textSize
}
// MARK: - ImagePickerController's delegate

extension XKRWUserArticleSectionEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension XKRWUserArticleSectionEditVC: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if self.textView.isFirstResponder() {
            self.textView.resignFirstResponder()
        }
    }
}

extension XKRWUserArticleSectionEditVC: UIAlertViewDelegate {
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex != alertView.cancelButtonIndex {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
