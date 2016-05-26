//
//  XKRWRegisterVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWRegisterVC: XKRWBaseVC {

    @IBOutlet weak var thirdpartyLoginLabel: UILabel!
    @IBOutlet weak var weiboLabel: UILabel!
    @IBOutlet weak var weiboButton: UIButton!
    @IBOutlet weak var qqLabel: UILabel!
    @IBOutlet weak var qqButton: UIButton!
    @IBOutlet weak var wechatLabel: UILabel!
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var authCodeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phonoTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    
    @IBOutlet weak var shoushouServiceButton: UIButton!
    var fromWhichVC:FromWhichVC?
    var timer:NSTimer?
    var totalTimer = 60
    
    override func viewDidLoad() {
        self.forbidAutoAddPopButton = true
        super.viewDidLoad()
        self.title = "注册"
        MobClick.event("pg_reg")
        self.navigationItem.hidesBackButton = true
        
        if(fromWhichVC == FromWhichVC.LoginVC){
            self.addNaviBarBackButton()
        }else{
            let rightNaviBarButton:UIButton = UIButton(type: UIButtonType.Custom)
            rightNaviBarButton.setTitle("登录", forState: UIControlState.Normal)
            rightNaviBarButton.setTitleColor(XKMainSchemeColor, forState: .Normal)
            rightNaviBarButton.setTitleColor(XKGrayDefaultColor, forState: .Highlighted)
            rightNaviBarButton.titleLabel!.font = UIFont.systemFontOfSize(14)
            let width = ("登录" as NSString).boundingRectWithSize(CGSizeMake(100, 100), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14)], context: nil).size.width
            rightNaviBarButton.frame = CGRectMake(0, 0, width, 44)
            rightNaviBarButton.addTarget(self, action: #selector(XKRWRegisterVC.doClickNaviBarRightButton as (XKRWRegisterVC) -> () -> ()), forControlEvents:UIControlEvents.TouchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNaviBarButton)
        }
        

        shoushouServiceButton.setTitleColor(XKMainSchemeColor, forState: .Normal)
        shoushouServiceButton.setTitleColor(XKMainSchemeColor, forState: UIControlState.Highlighted)
        checkButton.setBackgroundImage(UIImage(named: "read_s"), forState: UIControlState.Selected)
        checkButton.setBackgroundImage(UIImage(named: "read"), forState: UIControlState.Normal)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(XKRWRegisterVC.hideKeyBoard))
        self.view.addGestureRecognizer(tapGesture)
        
        
        wechatLabel.hidden = true
        wechatButton.hidden = true
        qqButton.hidden = true
        qqLabel.hidden = true
        weiboButton.hidden = true
        weiboLabel.hidden = true
         thirdpartyLoginLabel.hidden = true
        
        self.downloadWithTaskID("showThirdpartyLogin", outputTask: { () -> AnyObject! in
            return  NSNumber(bool: XKRWServerPageService.sharedService().isShowPurchaseEntry_uploadVersion())
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false;
        
        // remove edge slide gesture
//        self.navigationController?.interactivePopGestureRecognizer.delegate = nil;
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //获取验证码
    @IBAction func getAuthCodeAction(sender: UIButton) {
        MobClick.event("btn_getcode")
        if(!self.checkStringIsPhoneNum(phonoTextField.text!)) {
//            println(self.checkStringIsPhoneNum(phonoTextField.text))
            XKRWCui.showInformationHudWithText("电话号码错误")
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(XKRWRegisterVC.timerStart), userInfo: nil, repeats: true)
//            NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
            
            authCodeButton.enabled = false
            authCodeButton.setBackgroundImage(UIImage(named: "buttonGray"), forState: .Normal)
            authCodeButton.setTitleColor(XKMainSchemeColor, forState: UIControlState.Normal)
            authCodeButton.setTitle(NSString(format: "%d秒",totalTimer) as String, forState: UIControlState.Normal)
//            let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier
            SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: phonoTextField.text, zone: "86", customIdentifier: nil, result: { (error:NSError?) -> Void in
//                println(error)
                if (error != nil)  {
                    XKRWCui.showInformationHudWithText(error?.debugDescription)
                }else{
                    
                }
            })
        }
    }
    
    
    //点击已阅读瘦瘦服务条款
    @IBAction func checkButtonAction(sender: UIButton) {
        checkButton.selected = !checkButton.selected;
    }
    
    //进入瘦瘦服务条款页面
    @IBAction func shoushouServiceAction(sender: UIButton) {
        
        if(checkButton.selected){
            let  agreementVC: XKRWAgreementVC = XKRWAgreementVC()
            self.navigationController?.pushViewController(agreementVC, animated: true)
        }else{
            XKRWCui.showInformationHudWithText("请阅读瘦瘦服务条款")
        }
    }

    //注册账号
    @IBAction func registerAccount(sender: UIButton) {
        
        MobClick.event("btn_regsuccess")
        if(!self.checkStringIsPhoneNum(phonoTextField.text!)){
//            println(self.checkStringIsPhoneNum(phonoTextField.text))
            XKRWCui.showInformationHudWithText("电话号码错误")
        }else if(authCodeTextField.text!.characters.count != 4){
            XKRWCui.showInformationHudWithText("验证码错误")
        }else if(passwordTextField.text!.characters.count == 0){
            XKRWCui.showInformationHudWithText("请输入密码")
        }else if(passwordTextField.text!.characters.count < 6){
            XKRWCui.showInformationHudWithText("最少输入六位密码")
        }else{
            self.registerUser()
        }
    }
    
    //点击获取验证码后 开始自动倒计时
    func timerStart(){
        
        if --totalTimer > 0{
//            self.authCodeButton.titleLabel?.text = String(format: "%d秒", self.totalTimer)
            self.authCodeButton.setTitle(String(format: "%d秒", self.totalTimer), forState: .Normal)
        }else{
            self.timerstop()
        }
    }
    
    //停止自动计时
    func timerstop(){
        timer!.invalidate()
        authCodeButton.enabled = true
        authCodeButton.setTitle("重新获取", forState: UIControlState.Normal)
        authCodeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        authCodeButton.setBackgroundImage(UIImage(named: "buttonGreen"), forState:UIControlState.Normal )
        authCodeButton.setBackgroundImage(UIImage(named: "buttonGreen_p"), forState: .Highlighted)
        totalTimer = 60
    }
    
    //检查是否是合法的电话号码
    func checkStringIsPhoneNum(phoneNum:NSString)->Bool{
        let mobile:NSString = "^1(3|5|7|8|4)\\d{9}$"
        let regextestmobile:NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobile)
        let res1:Bool = regextestmobile.evaluateWithObject(phoneNum)
        if res1 {
            return true
        }else{
            return false
        }
    }
    
    //点击登录按钮进行登录操作
    func doClickNaviBarRightButton(){
        
        let loginVC:XKRWLoginVC =  XKRWLoginVC(nibName: "XKRWLoginVC", bundle: nil)
        loginVC .setFromWhichVC(FromWhichVC.RegisterVC)
        self.navigationController?.pushViewController(loginVC, animated: true)
    
    }
    
    //注册用户账号
    func registerUser() {
        
        self.view.endEditing(true)
        
        self.downloadWithTaskID("phoneRegister", outputTask: { () -> AnyObject! in
            
            return XKRWAccountService.shareService().registeAccountWith(self.phonoTextField.text, andPassword:self.passwordTextField.text, andAuthCode: self.authCodeTextField.text, andAppKey:MSG_APPKEY , andzone: "86", needLong: true);
        })
        

    }
    
    func hideKeyBoard(){
        if phonoTextField .becomeFirstResponder(){
            phonoTextField.resignFirstResponder()
        }else if(passwordTextField.becomeFirstResponder()){
            passwordTextField.resignFirstResponder()
        }else if(authCodeTextField.becomeFirstResponder()){
            authCodeTextField.resignFirstResponder()
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        super.handleUploadProblem(problem, withTaskID: taskID)
        XKRWCui.hideProgressHud()
    }
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        
//        print(taskID)
        
        if(taskID == "showThirdpartyLogin"){
            if(result.boolValue == true){
                if (WXApi.isWXAppInstalled()) {
                    wechatLabel.hidden = false
                    wechatButton.hidden = false
                }
                qqLabel.hidden = false
                qqButton.hidden = false
                weiboLabel.hidden = false
                weiboButton.hidden = false
                thirdpartyLoginLabel.hidden = false
            }
        }else{
            XKRWUserDefaultService.setLogin(true)
            XKRWUserDefaultService.setCurrentUserId(XKRWUserService.sharedService().getUserId());
            if(taskID == "weiboLogin" || taskID == "qqLogin" || taskID == "weixinLogin")
            {
                XKRWUserService .sharedService().setThirdPartyLogin();
                XKRWCui.hideProgressHud()
             }
            self.navigationController?.popToRootViewControllerAnimated(false);
            }
        
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    

    @IBAction func thirdpartyLoginAction(sender: UIButton) {
        
        if sender.tag == 1000 {
            
            let snsPlatform: UMSocialSnsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToQQ)

            snsPlatform.loginClickHandler(self,UMSocialControllerService.defaultControllerService(),true,{
                (response: UMSocialResponseEntity!) -> Void in
                
                let usm = UMSResponseCodeSuccess
                let rcode = response.responseCode
                
                if rcode.rawValue == usm.rawValue {
                    var snsAccount = UMSocialAccountManager.socialAccountDictionary()
                    let qqUser:UMSocialAccountEntity =  snsAccount[UMShareToQQ] as! UMSocialAccountEntity

                    let token = qqUser.accessToken
                    
                    XKRWCui.showProgressHud("登录中...")
                    MobClick.event("clk_RgstQQ")
                    self.downloadWithTaskID("qqLogin", outputTask: { () -> AnyObject! in
                        XKRWAccountService.shareService().userThirdPartyLoginBytoken(token, openId: nil, thridType: "qq", needLong: true)
                    })
                } else {
                    XKRWCui.showInformationHudWithText("QQ授权失败")
                }
            });
        } else if sender.tag == 1001 {
            
            let snsPlatform:UMSocialSnsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToSina)
            
            snsPlatform.loginClickHandler(self,UMSocialControllerService.defaultControllerService(),true,{(response :UMSocialResponseEntity!) ->Void in
                
                let usm = UMSResponseCodeSuccess
                let rcode = response.responseCode
                
                if rcode.rawValue == usm.rawValue {
                    
                    var snsAccount = UMSocialAccountManager.socialAccountDictionary()
                    
                    let sniaUser:UMSocialAccountEntity =  snsAccount[UMShareToSina] as! UMSocialAccountEntity
                    
                    //                    println("微博用户数据\(sniaUser)")
                    
                    let token = sniaUser.accessToken
                    
                    let userid = sniaUser.usid
                    XKRWCui.showProgressHud("登录中...")
                    MobClick.event("clk_RgstWb")
                    self.downloadWithTaskID("weiboLogin", outputTask: { () -> AnyObject! in
                        XKRWAccountService.shareService().userThirdPartyLoginBytoken(token, openId: userid, thridType: "wb", needLong: true)
                    })
                } else {
                    XKRWCui.showInformationHudWithText("微博授权失败")
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            });
        }else {
            //            println("微信用户登录")
            
            
            let snsPlatform:UMSocialSnsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToWechatSession)
            
            //            var  response:UMSocialResponseEntity
            snsPlatform.loginClickHandler(self,UMSocialControllerService.defaultControllerService(),true,{(response :UMSocialResponseEntity!) ->Void in
                
                let usm = UMSResponseCodeSuccess
                let rcode = response.responseCode
                
                if rcode.rawValue == usm.rawValue {
                    
                    var wxAccount = UMSocialAccountManager.socialAccountDictionary()
                    
                    let wxUser:UMSocialAccountEntity =  wxAccount[UMShareToWechatSession] as! UMSocialAccountEntity
                    
                    
                    
                    let token = wxUser.accessToken
                    
                    let openId = wxUser.openId
                    XKRWCui.showProgressHud("登录中...")
                    MobClick.event("clk_RgstWc")
                    self.downloadWithTaskID("weixinLogin", outputTask: { () -> AnyObject! in
                        XKRWAccountService.shareService().userThirdPartyLoginBytoken(token, openId: openId, thridType: "wx", needLong: true)
                    })
                    
                } else {
                    XKRWCui.showInformationHudWithText("微信授权失败")
                }
            });
        }
    }
    
    
    func setFromWhichVC(type:FromWhichVC){
        fromWhichVC = type
    }

}
