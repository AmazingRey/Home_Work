//
//  XKRWOneMinUndLoseFat.swift
//  XKRW
//
//  Created by 忘、 on 15/5/22.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//


import UIKit

class XKRWOneMinUndLoseFat: XKRWBaseVC,UIScrollViewDelegate {

    var fromWhichVC:FromWhichVC?

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MobClick.event("in_OneMinute")
        
        scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH*7, UI_SCREEN_HEIGHT);
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true        
        scrollView.delegate = self;
        for i in 0  ..< 7  {
            let imageView: UIImageView = UIImageView(frame: CGRectMake( UI_SCREEN_WIDTH * CGFloat(i), 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT))
            if(UI_SCREEN_HEIGHT == 480)
            {
                 imageView.image = UIImage(named: NSString(format:"knowSlim_480_0%d",i) as String)
            }else if(UI_SCREEN_HEIGHT == 667){
                imageView.image = UIImage(named: NSString(format:"knowSlim_1080_0%d",i) as String)
            }
            else{
                imageView.image = UIImage(named: NSString(format:"knowSlim_0%d",i) as String)
            }
            scrollView .addSubview(imageView)
        }
        
        pageControl.numberOfPages = 7
        pageControl.currentPageIndicatorTintColor = XK_MAIN_TONE_COLOR
        pageControl.pageIndicatorTintColor = XK_ASSIST_LINE_COLOR
        pageControl.enabled = false
        //创建我已了解按钮
        let accessButton:UIButton = UIButton(type: UIButtonType.Custom)
        accessButton.layer.cornerRadius = 3
        accessButton.layer.masksToBounds = true
        accessButton.setTitle("我已了解",  forState:UIControlState.Normal)
        accessButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
//        let topLine:UIView = UIView.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5))
//        topLine.backgroundColor = XK_ASSIST_LINE_COLOR
//        let bottomLine:UIView = UIView.init(frame: CGRectMake(0, 50.5, UI_SCREEN_WIDTH, 0.5))
//        bottomLine.backgroundColor = XK_ASSIST_LINE_COLOR
//        accessButton.setTitleColor(XKMainSchemeColor, forState: UIControlState.Normal)
//        accessButton.addSubview(topLine)
//        accessButton.addSubview(bottomLine)
//        accessButton.titleLabel?.font = XKDEFAULFONT
        accessButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        accessButton.setBackgroundImage(UIImage(named:"buttonGreen"), forState:UIControlState.Normal)
        accessButton.setBackgroundImage(UIImage(named:"buttonGreen_p"), forState: UIControlState.Selected)
        accessButton.setBackgroundImage(UIImage(named:"buttonGreen_p"), forState: UIControlState.Highlighted)
        
        accessButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        
        accessButton.addTarget(self, action: #selector(XKRWOneMinUndLoseFat.jumpOneMinOrEntryRegisterVC(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        accessButton.tag = 1000
        
        let jumpButton:UIButton = UIButton(type: UIButtonType.Custom)
        jumpButton.layer.cornerRadius = 5
        jumpButton.layer.masksToBounds = true
        jumpButton.setTitle("跳过",  forState:UIControlState.Normal)
        jumpButton.setTitleColor(XK_TEXT_COLOR, forState: UIControlState.Normal)
        jumpButton.setTitleColor(XK_TEXT_COLOR, forState: UIControlState.Highlighted)
        jumpButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        jumpButton.tag = 1001
        
        jumpButton.addTarget(self, action: #selector(XKRWOneMinUndLoseFat.jumpOneMinOrEntryRegisterVC(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        jumpButton.frame = CGRectMake((UI_SCREEN_WIDTH - 60)/2 ,UI_SCREEN_HEIGHT-30-48, 60, 30)
        
        accessButton.frame = CGRectMake(15 + 6*UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-72, UI_SCREEN_WIDTH-30, 42)
        

        if(fromWhichVC != FromWhichVC.MyVC){
            scrollView.addSubview(jumpButton)
        }
        scrollView .addSubview(accessButton)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
 
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
    }
    
    
    func jumpOneMinOrEntryRegisterVC (button:UIButton ) {
        
        if(fromWhichVC == FromWhichVC.MyVC){
            MobClick.event("clk_GetIt")
            self.navigationController?.navigationBarHidden = false
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            if(button.tag == 1000){
                MobClick.event("clk_GetIt")
            }else{
                MobClick.event("clk_Skip")
            }
            let registerVC:XKRWRegisterVC = XKRWRegisterVC(nibName: "XKRWRegisterVC", bundle: nil)
            self.navigationController?.pushViewController(registerVC , animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setFromWhichVC(type:FromWhichVC){
        fromWhichVC = type
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / UI_SCREEN_WIDTH)
        pageControl.currentPage = currentPage
//        println(scrollView.contentOffset.x / UI_SCREEN_WIDTH)
        if(scrollView.contentOffset.x / UI_SCREEN_WIDTH > 5)
        {
            pageControl.hidden = true
        }else{
            pageControl.hidden = false
        }
        
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
