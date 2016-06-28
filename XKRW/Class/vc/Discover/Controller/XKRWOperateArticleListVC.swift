//
//  XKRWOperateArticleListVC.swift
//  XKRW
//
//  Created by 忘、 on 16/1/26.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

enum OperateArticleType:String{
    case Knowledge = "jfzs"
    case SportRecommend = "ydtj"
    case Motivation = "lizhi"
    case PK = "pk"
}

enum ArticleType:NSInteger {
    case Knowledge = 1
    case SportRecommend = 2
    case Motivation = 3
    case PK = 4
}

class XKRWOperateArticleListVC: XKRWBaseVC,MJRefreshBaseViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var operateArticleTableView: XKRWUITableViewBase!
    var operateArticleType:OperateArticleType!
    var operateString:String?
    var page  = 1
    var operateArticle:[XKRWOperationArticleListEntity] = [XKRWOperationArticleListEntity]()
    var refreshFooterView:MJRefreshFooterView!
    
    var bigImageAndTitleCell:XKRWBigImageAndTitleCell?    //1
    var smallImageAndTitleAndDescribeCell:XKRWSmallImageAndTitleAndDescribeCell? //2
    var smallImageAndTitleCell:XKRWSmallImageAndTitleCell? //3
    var titleAndDescribeCell:XKRWTitleAndDescribeCell? //4
    var titleCell:XKRWTitleCell? //5
    var adArray:[XKRWShareAdverEntity]?
    let starLabel:NZLabel = NZLabel()
    let rightItemButton = UIButton(type: .Custom)
    let webview =  UIWebView()
    
    var selectIndexPath:NSIndexPath?
    
    var nids:String = String()
    var dateStr:String = String()
    let appdelegate : XKRWAppDelegate = UIApplication.sharedApplication().delegate as! XKRWAppDelegate
    let userid = XKRWUserService.sharedService().getUserId()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(selectIndexPath != nil){
            operateArticleTableView.reloadRowsAtIndexPaths([selectIndexPath!], withRowAnimation: .None)
            selectIndexPath = nil
        }
        self.getStarNum()
    }
    
    func initView(){
        
        if operateArticleType != nil{
            switch operateArticleType!{
            case .Knowledge:
                MobClick.event("in_knowledge")
                self.addStarView()
                self.title = "减肥知识"
            case .PK:
                MobClick.event("in_PK")
                self.title = "大家来PK"
            case .Motivation:
                MobClick.event("in_inspiring")
                self.addStarView()
                self.title = "每日励志"
            case .SportRecommend:
                MobClick.event("in_SportProposal")
                self.addStarView()
                self.title = "运动推荐"
            }
        }
        
        operateArticleTableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)
        operateArticleTableView.delegate = self;
        operateArticleTableView.dataSource = self

        operateArticleTableView.backgroundColor = UIColor.clearColor()
        operateArticleTableView.separatorStyle = .None
        operateArticleTableView.registerNib(UINib(nibName: "XKRWBigImageAndTitleCell", bundle: nil), forCellReuseIdentifier: "bigImageAndTitleCell")
        operateArticleTableView.registerNib(UINib(nibName: "XKRWSmallImageAndTitleAndDescribeCell", bundle: nil), forCellReuseIdentifier: "smallImageAndTitleAndDescribeCell")
        operateArticleTableView.registerNib(UINib(nibName: "XKRWSmallImageAndTitleCell", bundle: nil), forCellReuseIdentifier: "smallImageAndTitleCell")
        operateArticleTableView.registerNib(UINib(nibName: "XKRWTitleAndDescribeCell", bundle: nil), forCellReuseIdentifier: "titleAndDescribeCell")
        operateArticleTableView.registerNib(UINib(nibName: "XKRWTitleCell", bundle: nil), forCellReuseIdentifier: "titleCell")
        
        self.addFooterView()
    }
    
    func addFooterView(){
        refreshFooterView = MJRefreshFooterView(scrollView: operateArticleTableView)
        refreshFooterView.delegate = self
    }
    
    func addStarView() {
        starLabel.frame = CGRectMake(21, 0, 26, 22)
        starLabel.text = "0";
        starLabel.textColor = UIColor.blackColor();
        starLabel.font = XKDefaultFontWithSize(16);
        starLabel.textAlignment = .Left;
        starLabel.width = (starLabel.text! as NSString).boundingRectWithSize(CGSizeMake(100, 22), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:XKDefaultFontWithSize(16)], context: nil).size.width;
        
        let star = UIImageView()
        star.frame = CGRectMake(0, 3, 15, 15);
        star.image = UIImage(named: "star")
     
        rightItemButton.frame = CGRectMake(0, 0, 48, 22);
        rightItemButton.width = starLabel.origin.x+starLabel.width;
        
        rightItemButton.addTarget(self, action: #selector(XKRWOperateArticleListVC.pushToStarVC), forControlEvents: .TouchUpInside)
        
        rightItemButton.addSubview(star);
        rightItemButton.addSubview(starLabel);
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItemButton)
        
    }
    
    func refreshStarLabel(num:NSInteger){
        starLabel.text = "\(num)"
        starLabel.width = (starLabel.text! as NSString).boundingRectWithSize(CGSizeMake(100, 22), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:XKDefaultFontWithSize(16)], context: nil).size.width;
        rightItemButton.width = starLabel.origin.x+starLabel.width;

    }

    
    func initData(){
        self.getOperateArticleData(page, pageSize: 10)
        page += 1
    }
    
    
    func getStarNum(){
        if XKRWUtil.isNetWorkAvailable(){
            self.downloadWithTaskID("getStarNum", outputTask: { () -> AnyObject! in
                return XKRWManagementService5_0.sharedService().getUserStarNumFromServer()
                

            })
        }else{
            XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
    }
    
    func getOperateArticleData(page:Int,pageSize:Int){
        if XKRWUtil.isNetWorkAvailable(){
            self.downloadWithTaskID("OperateArticle", outputTask: { () -> AnyObject! in  //(self.operateString?.length == 0 ? self.operateArticleType.rawValue:self.operateString)
                return XKRWManagementService5_0.sharedService().getOperationArticleListWithType(self.operateString, andPage: page, andPageSize: pageSize)
            })
        }else{
            XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
    }
    
    func pushToStarVC() {
        let sgvc = XKRWStarGatherNumVC()
        sgvc.starNum = starLabel.text
        self.navigationController?.pushViewController(sgvc, animated: false)
    }
    
    //MARK: UTIL
    func readNumToString(readNum:Int)->String{
        if readNum < 10000{
            return "\(readNum)"
        }else{
            return "\(readNum / 10000) 万+"
        }
    }
    
    func checkIsShouldOpenFakeWeb(entity:XKRWOperationArticleListEntity) ->(show:Bool , adentity:XKRWShareAdverEntity){
        if(adArray != nil){
            var open = false
            let iCount = adArray!.count
            for i in 0 ..< iCount{
                if (entity.url != nil){
                    if((entity.url!.containsString("noss=\(adArray![i].adId)") )){
                        open = true
                        return (open,adArray![i] )
                    }
                }
            }
            return (open,XKRWShareAdverEntity())
        }else{
            return (false,XKRWShareAdverEntity())
        }
    }
    
    
    //MARK: UITableViewDelagate  UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return operateArticle.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         let entity = operateArticle[indexPath.section]
        if entity.showType == "1"{
           
            return  UI_SCREEN_WIDTH * 9 / 16
            
        }else if entity.showType == "2"{
            
             //  因为后台模板 只做了 1，3，5 故假如模板为2  默认显示3
            smallImageAndTitleCell = tableView.dequeueReusableCellWithIdentifier("smallImageAndTitleCell") as? XKRWSmallImageAndTitleCell
            return  XKRWUtil.getViewSize(smallImageAndTitleCell?.contentView).height + 1
            
            
        }else if entity.showType == "3"{
            smallImageAndTitleCell = tableView.dequeueReusableCellWithIdentifier("smallImageAndTitleCell") as? XKRWSmallImageAndTitleCell
            return  XKRWUtil.getViewSize(smallImageAndTitleCell?.contentView).height + 1
            
        }else if entity.showType == "4"{
    
            //  因为后台模板 只做了 1，3，5 故假如模板为4  默认显示5
            titleCell = tableView.dequeueReusableCellWithIdentifier("titleCell") as? XKRWTitleCell
            titleCell!.titleLabel.text = entity.title!
            titleCell!.titleLabel.preferredMaxLayoutWidth = UI_SCREEN_WIDTH - 50
            
            return  XKRWUtil.getViewSize(titleCell?.contentView).height + 1
            
            
        }else if entity.showType == "5"{
            titleCell = tableView.dequeueReusableCellWithIdentifier("titleCell") as? XKRWTitleCell
            titleCell!.titleLabel.text = entity.title!
            titleCell!.titleLabel.preferredMaxLayoutWidth = UI_SCREEN_WIDTH - 50
            return  XKRWUtil.getViewSize(titleCell?.contentView).height + 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRectMake(0,0,UI_SCREEN_WIDTH,10))
        sectionView.backgroundColor = UIColor.clearColor()

        return sectionView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let entity = operateArticle[indexPath.section]
        
        let date = appdelegate.timeFormatterOne.dateFromString(entity.date)
        if  date!.isDayEqualToDate(NSDate()) {
            dateStr = "今天"
        }else if date!.isDayEqualToDate(NSDate().offsetDay(-1)){
            dateStr = "昨天"
        }else if date!.isDayEqualToDate(NSDate().offsetDay(-2)){
            dateStr = "前天"
        }else{
            dateStr = entity.date
        }
        
        let hadRead = XKRWManagementService5_0.sharedService().operationArticleHadReadWithOperationArticleID(entity.nid)
        
        if entity.showType == "1"{
            bigImageAndTitleCell = tableView.dequeueReusableCellWithIdentifier("bigImageAndTitleCell") as? XKRWBigImageAndTitleCell

            bigImageAndTitleCell?.imageButton!.setImageWithURL(NSURL(string: entity.bigImageUrl!),  forState: .Normal, placeholderImage:UIImage(named: "sport_detail_defalut"),options:.RetryFailed)
            bigImageAndTitleCell?.imageButton.tag = indexPath.section
            bigImageAndTitleCell?.imageButton.addTarget(self, action: #selector(XKRWOperateArticleListVC.entryArticleButtonAction(_:)), forControlEvents: .TouchUpInside)
            
            bigImageAndTitleCell?.timeLabel.text = dateStr
            bigImageAndTitleCell?.titleLabel.text = entity.title!
            bigImageAndTitleCell?.readNumLabel.text = self.readNumToString(entity.pv)
            bigImageAndTitleCell?.starImageView.hidden = false

            if(entity.starState == 0){
                bigImageAndTitleCell?.starImageView.hidden = true
            }else if(entity.starState == 1){
                bigImageAndTitleCell?.starImageView.image = UIImage(named: "discover_star")
            }else{
                bigImageAndTitleCell?.starImageView.image = UIImage(named: "discover_star_hightlighted")
            }
            
            if(nids.containsString(entity.nid!)){
                bigImageAndTitleCell?.starImageView.image = UIImage(named: "discover_star")
            }
            
            return bigImageAndTitleCell!
        }else if entity.showType == "2"{

            //  因为后台模板 只做了 1，3，5 故假如模板为2  默认显示3
            smallImageAndTitleCell = tableView.dequeueReusableCellWithIdentifier("smallImageAndTitleCell") as? XKRWSmallImageAndTitleCell
            smallImageAndTitleCell?.timeLabel.text = dateStr
            smallImageAndTitleCell?.titleLabel.text = entity.title!
            smallImageAndTitleCell?.readNumLabel.text = self.readNumToString(entity.pv)
            smallImageAndTitleCell?.smallImageView?.setImageWithURL(NSURL(string:entity.smallImageUrl! ), placeholderImage: nil ,options:.RetryFailed)
            smallImageAndTitleCell?.starImageView.hidden = false
            if(entity.starState == 0){
                smallImageAndTitleCell?.starImageView.hidden = true
            }else if(entity.starState == 1){
                smallImageAndTitleCell?.starImageView.image = UIImage(named: "discover_star")
            }else{
                smallImageAndTitleCell?.starImageView.image = UIImage(named: "discover_star_hightlighted")
            }
            
            if(hadRead){
                smallImageAndTitleCell?.titleLabel.textColor =  XK_TEXT_COLOR
            }else{
                smallImageAndTitleCell?.titleLabel.textColor = XK_TITLE_COLOR
            }
            if(nids.containsString(entity.nid!)){
                smallImageAndTitleCell?.starImageView.image = UIImage(named: "discover_star")
            }
            
            return smallImageAndTitleCell!
            
        }else if entity.showType == "3"{
            smallImageAndTitleCell = tableView.dequeueReusableCellWithIdentifier("smallImageAndTitleCell") as? XKRWSmallImageAndTitleCell
            if indexPath.section == 0 {
                smallImageAndTitleCell?.newImage.hidden = !self.fetchArticleState(entity.nid!, moudle: self.operateString!)
            }else{
                smallImageAndTitleCell?.newImage.hidden = true
            }
            smallImageAndTitleCell?.timeLabel.text = dateStr
            smallImageAndTitleCell?.titleLabel.text = entity.title!
            smallImageAndTitleCell?.readNumLabel.text = self.readNumToString(entity.pv)
            smallImageAndTitleCell?.smallImageView?.setImageWithURL(NSURL(string:entity.smallImageUrl! ), placeholderImage: nil ,options:.RetryFailed)
            smallImageAndTitleCell?.starImageView.hidden = false
            if(entity.starState == 0){
                smallImageAndTitleCell?.starImageView.hidden = true
            }else if(entity.starState == 1){
                smallImageAndTitleCell?.starImageView.image = UIImage(named: "discover_star")
            }else{
                smallImageAndTitleCell?.starImageView.image = UIImage(named: "discover_star_hightlighted")
            }
            if(hadRead){
                smallImageAndTitleCell?.titleLabel.textColor =  XK_TEXT_COLOR
            }else{
                smallImageAndTitleCell?.titleLabel.textColor = XK_TITLE_COLOR
            }
            if(nids.containsString(entity.nid!)){
                smallImageAndTitleCell?.starImageView.image = UIImage(named: "discover_star")
            }
            
             return smallImageAndTitleCell!
        }else if entity.showType == "4"{

            //  因为后台模板 只做了 1，3，5 故假如模板为4  默认显示5

            titleCell = tableView.dequeueReusableCellWithIdentifier("titleCell") as? XKRWTitleCell
            
            titleCell?.timeLabel.text = dateStr
            titleCell?.titleLabel.text = entity.title!
            titleCell?.readNumLabel.text = self.readNumToString(entity.pv)
            titleCell?.starImageView.hidden = false
            if(entity.starState == 0){
                titleCell?.starImageView.hidden = true
            }else if(entity.starState == 1){
                titleCell?.starImageView.image = UIImage(named: "discover_star")
            }else{
                titleCell?.starImageView.image = UIImage(named: "discover_star_hightlighted")
            }
            if(hadRead){
                titleCell?.titleLabel.textColor =  XK_TEXT_COLOR
            }else{
                titleCell?.titleLabel.textColor = XK_TITLE_COLOR
            }
            
            if(nids.containsString(entity.nid!)){
                titleCell?.starImageView.image = UIImage(named: "discover_star")
            }
            
            return titleCell!
            
        }else if entity.showType == "5"{
            titleCell = tableView.dequeueReusableCellWithIdentifier("titleCell") as? XKRWTitleCell
            if indexPath.section == 0 {
                titleCell?.newImage.hidden = !self.fetchArticleState(entity.nid!, moudle: self.operateString!)
            }else{
                titleCell?.newImage.hidden = true
            }
            
            titleCell?.timeLabel.text = dateStr
            titleCell?.titleLabel.text = entity.title!
            titleCell?.readNumLabel.text = self.readNumToString(entity.pv)
            titleCell?.starImageView.hidden = false
            if(entity.starState == 0){
                titleCell?.starImageView.hidden = true
            }else if(entity.starState == 1){
                titleCell?.starImageView.image = UIImage(named: "discover_star")
            }else{
                titleCell?.starImageView.image = UIImage(named: "discover_star_hightlighted")
            }
            if(hadRead){
                titleCell?.titleLabel.textColor =  XK_TEXT_COLOR
            }else{
                titleCell?.titleLabel.textColor = XK_TITLE_COLOR
            }
            
            if(nids.containsString(entity.nid!)){
                titleCell?.starImageView.image = UIImage(named: "discover_star")
            }
            
            return titleCell!
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectIndexPath = indexPath
        let entity = operateArticle[indexPath.section]
        if(self.checkIsShouldOpenFakeWeb(entity).0){
            
            dispatch_async(dispatch_get_global_queue(0,0), { () -> Void in
                let entity:XKRWShareAdverEntity = self.checkIsShouldOpenFakeWeb(entity).1
                let request = NSURLRequest(URL:NSURL(string: entity.imgUrl)!)
                self.webview.loadRequest(request)
            })
        }
        self.entryArticle(entity)
        
        //insert to core data (nid/userid)
        if indexPath.section == 0 {
            self.setArticleState(entity.nid!, moudle: self.operateString!)
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    func entryArticleButtonAction(button :UIButton){

        let entity = operateArticle[button.tag]
        self.entryArticle(entity)
    }
    
    func entryArticle(entity:XKRWOperationArticleListEntity){
        let webViewVC = XKRWArticleWebView()
        let uid = XKRWUserService.sharedService().getUserId()
        if operateArticleType != nil{

            XKRWManagementService5_0.sharedService().setOperationArticleHadReadWithTitle(entity.title, withID: entity.nid)
            
            
            switch operateArticleType!{
            case .PK:
                let pkVC = XKRWPKVC(nibName:"XKRWPKVC",bundle:nil)
                pkVC.nid = entity.nid
                
                NSUserDefaults.standardUserDefaults().setObject(entity.nid, forKey: NSString(format: "pkNid_%@_%ld", entity.nid!,uid) as String)
                self.navigationController?.pushViewController(pkVC, animated: true)
                return
            case .Knowledge:
                webViewVC.category = eOperationKnowledge
                
                NSUserDefaults.standardUserDefaults().setObject(entity.nid, forKey: NSString(format: "KnowlegdeNId_%@_%ld", entity.nid!,uid) as String)
           
                break
            case .SportRecommend:
                webViewVC.category = eOperationSport
                
                NSUserDefaults.standardUserDefaults().setObject(entity.nid, forKey: NSString(format: "sportRecommendNid_%@_%ld", entity.nid!,uid) as String)
                break
            case .Motivation:
                webViewVC.category = eOperationEncourage
                
                NSUserDefaults.standardUserDefaults().setObject(entity.nid, forKey: NSString(format: "encouragementNid_%@_%ld", entity.nid!,uid) as String)
                break
                
            }
            
        }else {
            
            if operateString == "jfzs"{
                webViewVC.category = eOperationKnowledge
                NSUserDefaults.standardUserDefaults().setObject(entity.nid, forKey: NSString(format: "KnowlegdeNId_%@_%ld", entity.nid!,uid) as String)
            }else if operateString == "ydtj"{
                webViewVC.category = eOperationSport
                NSUserDefaults.standardUserDefaults().setObject(entity.nid, forKey: NSString(format: "sportRecommendNid_%@_%ld", entity.nid!,uid) as String)
            }else if operateString == "lizhi"{
                webViewVC.category = eOperationEncourage
                NSUserDefaults.standardUserDefaults().setObject(entity.nid, forKey: NSString(format: "encouragementNid_%@_%ld", entity.nid!,uid) as String)
            }else{
                NSUserDefaults.standardUserDefaults().setObject(entity.nid, forKey: NSString(format: "pkNid_%@_%ld", entity.nid!,uid) as String)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        webViewVC.source = eFromToday
        webViewVC.requestUrl = entity.url
        webViewVC.navTitle = entity.title

        webViewVC.entity = entity

        print(webViewVC.entity.nid)
        
        
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    //MARK: CoreData 存取文章是否为NEW
    
    func setArticleState(nid : String, moudle : String){
        let manageObjectContext = appdelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("ArticleNewStateEntity", inManagedObjectContext: manageObjectContext)
        let article = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: manageObjectContext)
        article.setValue(moudle + nid, forKey: "nid")
        article.setValue(userid, forKey: "userID")
        do {
            try manageObjectContext.save()
        }
        catch let error as NSError{
            print("😂 Can't insert CoreData.😂 Error: \(error).")
        }
    }
    
    func fetchArticleState(nid : String, moudle : String) -> Bool{
        
        let manageObjectContext = appdelegate.managedObjectContext!
        let fetchrequest = NSFetchRequest.init(entityName: "ArticleNewStateEntity")
        
        fetchrequest.predicate = NSPredicate(format: "nid = %@ and userID = %d",moudle + nid,userid)
        var articleEntityArray:[ArticleNewStateEntity]
        do{
            try articleEntityArray = manageObjectContext.executeFetchRequest(fetchrequest) as! [ArticleNewStateEntity]
            
            if articleEntityArray.count > 0{
                return false
            }
            return true
        }catch{
            Log.debug_println("从CoreData中获取TeamPostNumEntity失败")
            return false
        }
    }

    //MARK:   ---MJRefreshBaseViewDelegate
    
    func refreshViewBeginRefreshing(refreshView: MJRefreshBaseView!) {
        if(refreshView == refreshFooterView){
            self.getOperateArticleData(page, pageSize: 10)
            page += 1
        }
    }
    
    func refreshViewEndRefreshing(refreshView: MJRefreshBaseView!) {
        print("%@----刷新完毕");
    }
    
    func refreshView(refreshView: MJRefreshBaseView!, stateChange state: MJRefreshState) {
        
    }

    //MARK: Network
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        if taskID == "OperateArticle"{
            let operateArticleArray = (result as? [XKRWOperationArticleListEntity])!
            operateArticle += operateArticleArray
            refreshFooterView.endRefreshing()
            operateArticleTableView .reloadData()
        }
        
        if taskID == "getStarNum"{
//            print(result)
            nids = result["data"]!["nids"] as! String
            XKRWUserService.sharedService().setUserStarNum(result["data"]!["stars"]!.integerValue)
            XKRWUserService.sharedService().saveUserInfo()
            
            let starNum = XKRWUserService.sharedService().getUserStarNum()
            operateArticleTableView.reloadData()
            self.refreshStarLabel(starNum)
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        super.handleDownloadProblem(problem, withTaskID: taskID)
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        refreshFooterView?.free()
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
