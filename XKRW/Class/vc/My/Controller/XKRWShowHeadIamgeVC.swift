//
//  XKRWShowHeadIamgeVC.swift
//  XKRW
//
//  Created by 忘、 on 15/11/3.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWShowHeadIamgeVC: XKRWBaseVC {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var headImageUrl:String?
    
    @IBOutlet weak var headImageView: UIImageView!
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        headImageView.setImageWithURL(NSURL(string: headImageUrl!), placeholderImage: UIImage(named: "lead_nor_1920") ,options:.RetryFailed)
        let imageTap = UITapGestureRecognizer(target: self, action: "tapImageView")
        imageTap.numberOfTouchesRequired = 1
        imageTap.numberOfTapsRequired = 2
        headImageView.addGestureRecognizer(imageTap)
        headImageView.userInteractionEnabled = true
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(XKRWShowHeadIamgeVC.tapView))
        self.view.addGestureRecognizer(tap)
        
        tap.requireGestureRecognizerToFail(imageTap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapView(){
        self.dismissViewControllerAnimated(false) { () -> Void in
        }
    }
    
    func tapImageView(){
    
    
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
