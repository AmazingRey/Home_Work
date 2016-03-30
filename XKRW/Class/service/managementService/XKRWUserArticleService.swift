//
//  XKRWUserArticleService.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/22.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit
/**
文章状态

- Draft:          草稿
- DeleteByUser:   用户删除
- DeleteByAdmin:  管理员删除
- Recommended:    已推荐
- Unrecommended:  未推荐
*/
@objc enum XKRWUserArticleStatus: Int {
    case Draft = 0
    case DeleteByUser = 2, DeleteByAdmin = 3, Recommended, Unrecommended
}
/**
 帖子状态
 
 - Draft:
 - DeleteByUser:  用户删除
 - DeleteByAdmin: 管理员删除
 */
@objc enum XKRWPostStatus:Int{
    case Draft = 0
    case DeleteByUser = 2, DeleteByAdmin = 3
}

/**
 瘦身分享举报类型
 
 - Article: 文章举报
 - Comment: 评论举报
 */
@objc enum XKRWUserReport:Int {
    case Article = 1, Comment = 2, Post = 3
}

private let shareInstance = XKRWUserArticleService()
private let pic_directory = "UserPictures"

public let kOneThumb = "-1thumb"
public let kNineThumb = "-9thumb"
public let kCoverThumb = "-cover"

public let kCoverRatio: CGFloat = 9 / 16

var userPicturesDirectory: NSString {

    get {
        let document = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first! as NSString
        let path = document.stringByAppendingPathComponent(pic_directory)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(path) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                Log.debug_println(error)
            }
        }
        return path as NSString
    }
}

var photoVerifingPicturePath: String {
    get {
        if UIScreen.mainScreen().scale == 2 {
            return NSBundle.mainBundle().pathForResource("share_photo_verify@2x", ofType: ".png")!
        } else {
            return NSBundle.mainBundle().pathForResource("share_photo_verify@3x", ofType: ".png")!
        }
    }
}

var coverVerifingPicturePath: String {
    get {
        if UIScreen.mainScreen().scale == 2 {       
            return NSBundle.mainBundle().pathForResource("share_cover_verify@2x", ofType: ".png")!

        } else {
            return NSBundle.mainBundle().pathForResource("share_cover_verify@3x", ofType: ".png")!
        }
    }
}

class XKRWUserArticleService: XKRWBaseService {

    private class var imageCount: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("user_pic_count")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "user_pic_count")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var compressedTime: NSTimeInterval!
    //
    class var shareService: XKRWUserArticleService {
        get {
            return shareInstance
        }
    }
    
    static let maxImageSize: Int = 200000
    
    // MARK: - Networking -
    
    // MARK: 获取话题列表
    /**
    获取话题列表
    
    - returns: 话题字符串数组
    */
    func getTopicList() -> [XKRWTopicEntity] {
        
        let url = NSURL(string: kNewServer + kGetTopicList)
        let param = ["enabled": 1]
        
        let result = self.syncBatchDataWith(url, andPostForm: param, withLongTime: false)

        var returnValue = [XKRWTopicEntity]()
        for dic in result["data"] as! NSArray where dic is NSDictionary {
            
            let entity = XKRWTopicEntity(id: (dic["id"] as! NSString).integerValue, name: dic["name"] as! String, enabled: true)
            returnValue.append(entity)
        }
        return returnValue
    }
    
    func uploadPictureWithEntity(inout entity: XKRWUserPostEntity,var callback: ((isSuccess:Bool) -> Void)!) ->Void{
        var success = true
    
        var starTime:NSTimeInterval!;
        starTime = NSDate().timeIntervalSince1970;
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        
        
     for image in entity.originalImages where image.compressedImage == nil {
        
            dispatch_group_async(group, queue, {
                
                image.compressedImage = XKRWUserArticleService.compressImage(image, aboveSize: XKRWUserArticleService.maxImageSize, maxWidth: UI_SCREEN_WIDTH * 1)
                
                Log.debug_println(UIImageJPEGRepresentation(image.compressedImage!, 1)!.length)
                
                if image.compressedImage == nil {
                    XKRWCui.showInformationHudWithText("压缩图片失败")
                    callback?(isSuccess: false)
                    callback = nil
                    return
                }
            })
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        self.compressedTime = NSDate().timeIntervalSince1970 * 1000
        Log.debug_println("压缩时间：\(self.compressedTime/1000-starTime)")
        
        var numOfPic = 0
        var uploadedNum = 0
        
        let url = NSURL(string: kNewServer + kGetBlogToken)
        
        let result = self.syncBatchDataWith(url, andPostForm: nil, withLongTime: false)
        let token = (result["data"] as! NSDictionary)["token"] as! String
        let domain = (result["data"] as! NSDictionary)["domain"] as! String
        
        let manage = QNUploadManager()
        
        for image in entity.originalImages {
            // if image isn't uploaded
            if image.url == nil {
                
                let data = UIImageJPEGRepresentation(image.compressedImage!, 1)
                
                let option = QNUploadOption(mime: nil, progressHandler: nil, params: ["x: position": ""], checkCrc: false, cancellationSignal: nil)
                
                let random = rand() % 1000000000
                let stamp = Int64(NSDate().timeIntervalSince1970 * 1000)
                let fileName = "\(random)_\(stamp).jpg"
                
                manage.putData(data, key: fileName, token: token, complete: { (info: QNResponseInfo!, key: String!, resp: [NSObject : AnyObject]!) -> Void in
                    
                    if resp != nil {
                        
                        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                            
                            let path = domain + "/" + fileName
                            
                            image.url = path
                            
                            image.info.setDictionary(["url": path, "flag": 1])
                            
                            if ++uploadedNum == numOfPic && success {
                                callback?(isSuccess: true)
                            }
                            
                            
                        })
                        
                    } else {
                        success = false
                        callback?(isSuccess: false)
                        callback = nil
                    }
                    }, option: option)
                //                        y++
                numOfPic++
            }
                // if image is uploaded but failed to analyze
            else if image.info.count == 0 {
                
                dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                    
                    let data = self.analyseImageWithPath(image.url!)
                    Log.debug_println("-L- \(data)")
                    
                    if !data.keys.contains("error") {
                        image.info.setDictionary(data)
                        
                        if ++uploadedNum == numOfPic && success {
                            callback?(isSuccess: true)
                        }
                    } else {
                        success = false
                        callback?(isSuccess: false)
                        callback = nil
                    }
                })
                numOfPic++
            }
        }

        Log.debug_println("上传时间：\(NSDate().timeIntervalSince1970-self.compressedTime/1000)")
        // if all image is uploaded and analyzed, callback immediately with success
        if numOfPic == 0 {
            callback?(isSuccess: true)
            callback = nil
        }
    }
    
    // MARK: 上传文章图片
    /**
    上传文章图片
    
    - parameter entity: 文章实体
    */
    func uploadPicturesWithEntity(inout entity: XKRWUserArticleEntity, var callback: ((isSuccess: Bool) -> Void)!) -> Void {
        
//        assert(entity.compressedImages.count > 0, "需要压缩图片数组不为空才能上传")
        
  
        
        var success = true
        
        // save user's article cache to database
        
        XKRWUserArticleService.shareService.saveDraftWithEntity(entity)
        
        // compress image and save path to entity.content
        var starTime:NSTimeInterval!;
        starTime = NSDate().timeIntervalSince1970;
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        
        for images in entity.originalImages {
            
            for image in images where image.compressedImage == nil {
                
                dispatch_group_async(group, queue, {
                    
                    image.compressedImage = XKRWUserArticleService.compressImage(image, aboveSize: XKRWUserArticleService.maxImageSize, maxWidth: UI_SCREEN_WIDTH * 1)
                    
                    Log.debug_println(UIImageJPEGRepresentation(image.compressedImage!, 1)!.length)
                    
                    if image.compressedImage == nil {
                        XKRWCui.showInformationHudWithText("压缩图片失败")
                        callback?(isSuccess: false)
                        callback = nil
                        return
                    }
                })
            }
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        
        if entity.mainPicture!.compressedImage == nil {
            
            entity.mainPicture!.compressedImage = XKRWUserArticleService.compressImage(entity.mainPicture!, aboveSize: XKRWUserArticleService.maxImageSize, maxWidth: UI_SCREEN_WIDTH * 2)
            
            if entity.mainPicture!.compressedImage == nil {
                XKRWCui.showInformationHudWithText("压缩图片失败")
                callback?(isSuccess: false)
                callback = nil
                return
            }
        }

        self.compressedTime = NSDate().timeIntervalSince1970 * 1000
        Log.debug_println("压缩时间：\(self.compressedTime/1000-starTime)")
        
        var numOfPic = 0
        var uploadedNum = 0
        
        let url = NSURL(string: kNewServer + kGetBlogToken)
        
        let result = self.syncBatchDataWith(url, andPostForm: nil, withLongTime: false)
        let token = (result["data"] as! NSDictionary)["token"] as! String
        let domain = (result["data"] as! NSDictionary)["domain"] as! String

        let manage = QNUploadManager()
        
//        let account = XKRWUserService.sharedService().getUserAccountName()
        
        // TODO:

        if entity.mainPicture!.url == nil {
            
            numOfPic++
            
            let data = UIImageJPEGRepresentation(entity.mainPicture!.compressedImage!, 1)
            let stamp = Int64(NSDate().timeIntervalSince1970 * 1000)
            
            let random = rand() % 1000000000
            let fileName = "\(random)_\(stamp).jpg"
            
            manage.putData(data, key: fileName, token: token, complete: { (info: QNResponseInfo!, key: String!, resp: [NSObject : AnyObject]!) -> Void in
                
                if resp != nil {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                        
                        let path = domain + "/" + fileName
                        entity.mainPicture!.url = path
                        
                        entity.mainPicture!.info.setDictionary(["url": path, "flag": 1])
                        
                        if ++uploadedNum == numOfPic && success {
                            callback?(isSuccess: true)
                        }

                    })
                } else {
                    success = false
                    callback?(isSuccess: false)
                    callback = nil
                }
            }, option: nil)
        }
        
        if success {
            
//            var x = 0, y = 0
            for array in entity.originalImages {
                
                for image in array {
                    // if image isn't uploaded
                    if image.url == nil {
                        
                        let data = UIImageJPEGRepresentation(image.compressedImage!, 1)
                        
                        let option = QNUploadOption(mime: nil, progressHandler: nil, params: ["x: position": ""], checkCrc: false, cancellationSignal: nil)
                        
                        let random = rand() % 1000000000
                        let stamp = Int64(NSDate().timeIntervalSince1970 * 1000)
                        let fileName = "\(random)_\(stamp).jpg"
                        
                        manage.putData(data, key: fileName, token: token, complete: { (info: QNResponseInfo!, key: String!, resp: [NSObject : AnyObject]!) -> Void in
                            
                            if resp != nil {

                                dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                                    
                                    let path = domain + "/" + fileName
                                    
                                    image.url = path
                                    
                                    image.info.setDictionary(["url": path, "flag": 1])
                                    
                                    if ++uploadedNum == numOfPic && success {
                                        callback?(isSuccess: true)
                                    }
                                    

                                })
                                
                            } else {
                                success = false
                                callback?(isSuccess: false)
                                callback = nil
                            }
                        }, option: option)
//                        y++
                        numOfPic++
                    }
                        // if image is uploaded but failed to analyze
                    else if image.info.count == 0 {
                        
                        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                            
                            let data = self.analyseImageWithPath(image.url!)
                            Log.debug_println("-L- \(data)")
                            
                            if !data.keys.contains("error") {
                                image.info.setDictionary(data)
                                
                                if ++uploadedNum == numOfPic && success {
                                    callback?(isSuccess: true)
                                }
                            } else {
                                success = false
                                callback?(isSuccess: false)
                                callback = nil
                            }
                        })
                        numOfPic++
                    }
                }
//                x++
//                y = 0
            }

            Log.debug_println("上传时间：\(NSDate().timeIntervalSince1970-self.compressedTime/1000)")
            // if all image is uploaded and analyzed, callback immediately with success
            if numOfPic == 0 {
                callback?(isSuccess: true)
                callback = nil
            }
        }
    }
    
    /**
     上传帖子
     
     - parameter entity: 帖子实体
     
     - returns: 上传回调信息，body转JSON失败会返回nil
     */
    func uploadPostWithEntity(entity: XKRWUserPostEntity) -> [NSObject: AnyObject]?{
        let url = NSURL(string: kNewServer + kUpLoadPost)
        var pics:NSString
        do {
            var picsArray = [[String: AnyObject]]()
            if(entity.originalImages.count > 0){
                for image in entity.originalImages {
                    picsArray.append([
                        "url": image.url!,
                        "flag": image.info["flag"]!
                        ])
                }
                
                let picsData = try NSJSONSerialization.dataWithJSONObject(picsArray, options: .PrettyPrinted)
                
                pics = NSString(data: picsData, encoding: NSUTF8StringEncoding)!
            }else{
                pics = ""
            }
            
        }catch {
            Log.debug_println("JSON transfer failed")
            return nil
        }

        
        let param = ["title": entity.postTitle!, "groupid": entity.postGroupID!, "content": entity.textContent!, "pics": pics,"is_help":entity.helpPost!]
        let result = self.syncBatchDataUrl(url, andForm: param as [NSObject : AnyObject], andOutTime: 120)
        
        Log.debug_println(result)
        
        if let data = result["data"] as? NSDictionary {
            Log.debug_println(data)
            
            if let postId = data["postid"] as? String {
                
                dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                    self.serverAnalyseImageWithBlogId(postId)
                })
            }
        }
        
        return result
        
    }
    
    
    func getPostUserLimit()->[NSObject: AnyObject]{
        let url = NSURL(string: kNewServer + kPostLimit)
        let result = self.syncBatchDataUrl(url, andForm: nil, andOutTime: 10)
        print(result)
        return result
    }
    
    
    // MARK: Public: 上传文章
    /**
    上传文章
    
    - parameter entity: 文章实体
    
    - returns: 上传回调信息，body转JSON失败会返回nil
    */
    func uploadArticleWithEntity(entity: XKRWUserArticleEntity) -> [NSObject: AnyObject]? {
        
        let url = NSURL(string: kNewServer + kUploadArticle)
        
        var body: NSString
        do {
            var content = [[String: AnyObject]]()
            for var i = 0; i < entity.textContent.count; i++ {
                var pics = [[String: AnyObject]]()
                
                for image in entity.originalImages[i] {
                    pics.append([
                        "url": image.url!,
                        "flag": image.info["flag"]!
//                        "code": image.info["code"]!
                    ])
                }
                content.append([
                    "content": entity.textContent[i],
                    "pics": pics
                ])
            }
            let bodyData = try NSJSONSerialization.dataWithJSONObject(content, options: NSJSONWritingOptions.PrettyPrinted)
            body = NSString(data: bodyData, encoding: NSUTF8StringEncoding)!
        } catch {
            Log.debug_println("JSON transfer failed")
            return nil
        }
        
        var cover: NSString
        do {
            let coverData = try NSJSONSerialization.dataWithJSONObject(entity.mainPicture!.info, options: NSJSONWritingOptions.PrettyPrinted)
            cover = NSString(data: coverData, encoding: NSUTF8StringEncoding)!
        } catch {
            Log.debug_println("JSON transfer failed")
            return nil
        }
        
        let param = ["title": entity.articleTitle, "topic": entity.topic!.topicId, "cover_pic": cover, "body": body]
        
        let result = self.syncBatchDataUrl(url, andForm: param, andOutTime: 120)
        
        Log.debug_println(result)
        
        if let data = result["data"] as? NSDictionary {
            Log.debug_println(data)
            
            if let articleId = data["blogid"] as? String {
                
                dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                    self.serverAnalyseImageWithBlogId(articleId)
                })
                // 成功
                // 删除缓存原图
                for paths in entity.imagePath {
                    for path in paths { XKRWUserArticleService.removeCachedImageWithPath(path) }
                }
                entity.imagePath.removeAll()
                
                XKRWUserArticleService.removeCachedImageWithPath(entity.mainPicturePath!)
                
                // 缓存压缩图
                for images in entity.originalImages {
                    
                    var paths = [String]()
                    
                    for image in images {
                        if let path = XKRWUserArticleService.cacheImage(image.compressedImage!) {
                            paths.append(path)
                        }
                    }
                    entity.imagePath.append(paths)
                }
                entity.mainPicturePath = XKRWUserArticleService.cacheImage(entity.mainPicture!.compressedImage!)
                
                // 保存缓存信息到数据库
                entity.status = .Unrecommended
                entity.aid = articleId
                self.saveArticleToDatabaseWithEntity(entity)
                
            } else {
                // 失败
                
            }
        }
        return result
    }
    /**
    图片鉴定服务
    
    - parameter path: 图片URL
    
    - returns: 鉴定结果及校验code
    */
    func analyseImageWithPath(path: String) -> [String: AnyObject] {
        
        let url = NSURL(string: kNewServer + "/blog/picflag/")
        
        let param = ["url": path]

        if let result = self.noExceptionSyncBatchDataUrl(url!, andForm: param, andOutTime: 20),
           let data = result["data"] as? [String: AnyObject] {
            
            return data
        }
        return ["error": 1]
    }
    /**
     通知服务器鉴定图片
     
     - parameter blogId: 需要鉴定的图片的文章id
     */
    func serverAnalyseImageWithBlogId(blogId: String) -> Void {
        
        let url = NSURL(string: kNewServer + "/blog/validate/")
        let param = ["blogid": blogId]
        
        self.noExceptionSyncBatchDataUrl(url!, andForm: param, andOutTime: 20)
    }
    
    /**
    点赞
    
    :param: id blogId
    
    :returns: 是否成功（success：1 or 0）
    */
    func addUserArticleLikeById(id:String,type:String?) -> Bool {
        let url = NSURL(string: kNewServer + kAddArticleLike)
        var param:[NSObject:AnyObject]?
        if(type != nil){
            param = ["postid": id,"type":type!]
        }else{
            param = ["blogid": id]
        }
        if let data = self.syncBatchDataWith(url, andPostForm: param)["success"] as? Int {
            if data == 1 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    /**
    举报（文章/评论）
    
    :param: item_id comment_id/blog_id
    :param: type    1：瘦身分享
    :param: reason  report_id
    :param: blogId 举报评论时添加相应的blogId

    :returns: seccess:1成功
    */
    func reportWithItem_id(item_id:String, type:XKRWUserReport, blogId:String,reason:String) -> Bool {
        let url = NSURL(string: kNewServer + kAddReport)
        var param:Dictionary<String,String>
        
        if blogId.isEmpty {
            param = [
                "item_id":item_id,
                "type":String(type.rawValue),
                "reason":reason,
            ];
            
        } else {
            param = [
                "item_id":item_id,
                "type":String(type.rawValue),
                "reason":reason,
                "parent_id":blogId
            ];
        }
        
        if let data = self.syncBatchDataWith(url, andPostForm: param)["success"] as? Int {
            if data == 1{
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    /**
    取消赞
    
    :param: id blogId
    
    :returns: 是否成功（success：1 or 0）
    */
    func delUserArticleLikeById(id:String,type:String?) -> Bool {
        let url = NSURL(string: kNewServer + kDelArticleLike)
        var param:[NSObject:AnyObject]?
        if(type == nil){
            param = ["blogid": id]
        }else{
            param = ["postid": id,"type":type!]
        }
        if let data = self.syncBatchDataWith(url, andPostForm: param)["success"] as? Int {
            if data == 1 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    /**
    获取举报原因dic
    
    :param: enabled 是否可获取（1 or 0）
    
    :returns: 原因dic
    */
    func getReportReasonByEnabled(enabled: Int) -> [[String: String]] {
        let url = NSURL(string: kNewServer + kGetReportReason)
        let param = ["enabled":enabled]
        if let data = self.syncBatchDataWith(url, andPostForm: param)["data"] as? [[String: String]] {
            return data
        }else{
            return []
        }
    }
    
    /**
    根据文章id获取文章详情
    
    - parameter id: 文章id
    
    - returns: 文章实体对象
    */
    func getUserArticleDetailById(id: String) -> XKRWUserArticleEntity? {
        
        let url = NSURL(string: kNewServer + kGetArticleDetail)
        let param = ["blogid": id]
        
        let data = self.syncBatchDataWith(url, andPostForm: param)["data"] as! [String: AnyObject]
        print(data)
        Log.debug_println(data)
        
        // if server response have "status", means it couldn't be read by user
        if let status = data["status"] as? Int where status == 3 || status == 2 {
            let entity = XKRWUserArticleEntity()
            entity.status = XKRWUserArticleStatus(rawValue: status) ?? .DeleteByAdmin
            
            return entity
        }
        
        var topicId: Int
        if let temp = data["topic_key"] as? NSString {
            topicId = temp.integerValue
        } else if let temp = data["topic_key"] as? Int {
            topicId = temp
        } else {
            topicId = 0
        }
       
        let topic = XKRWTopicEntity(id: topicId, name: data["topic_name"] as! String, enabled: true)
        
        let entity = XKRWUserArticleEntity()
        entity.topic = topic
        
        entity.user_level = data["level"] as? String
        entity.user_avatar = data["avatar"] as? String
        entity.user_nickname = data["nickname"] as? String
        entity.user_manifesto = data["manifesto"] as? String
        
        entity.aid = id
        entity.articleTitle = data["title"] as! String
        entity.readNumber = data["views"] as! Int
        entity.likeNumber = data["goods"] as! Int
//        entity.commentNum = data["comment_nums"] as! Int
        
        entity.date = NSDate(timeIntervalSince1970: NSTimeInterval((data["ctime"] as! NSString).integerValue))
        entity.isLike = Bool(data["is_good"] as! Int)
        entity.articleURL = data["url"] as? String
        
        let jsonContent = data["body"] as! String
        let jsonCover = data["cover_pic"] as! String
        var content: NSArray
        var cover: NSDictionary
        do {
            content = try NSJSONSerialization.JSONObjectWithData(jsonContent.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as! NSArray
            cover = try NSJSONSerialization.JSONObjectWithData(jsonCover.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as! NSDictionary
        } catch {
            Log.debug_println("JSON parser error")
            return nil
        }
        
        if cover["flag"] as! Int == 1 {
            entity.mainPicturePath = cover["url"] as? String
        } else {
        
            entity.mainPicturePath = coverVerifingPicturePath
        }
     
        for dic in content where dic is NSDictionary {
            if(!dic.objectForKey("content")!.isKindOfClass(NSNull.classForCoder())){
                entity.textContent.append(dic["content"] as! String)
                var urls: [String] = []
                if((!dic["pics"]!.isKindOfClass(NSNull.classForCoder())) && (dic["pics"]!.isKindOfClass(NSArray.classForCoder()))){
                    for temp in dic["pics"] as! NSArray where temp is NSDictionary {
                        if(temp["flag"] != nil && temp["url"] != nil)
                        {
                            if temp["flag"] as! Int == 1 {
                                urls.append(temp["url"] as! String)
                            } else {
                                urls.append(photoVerifingPicturePath)
                            }
                        }
                    }
                    entity.imagePath.append(urls)
                }
            }
        }
        return entity
    }
    
    func deletePostById(id:String) -> Bool {
        let url = NSURL(string: kNewServer + kDeletePost)
        let param = ["postid": id]
        let data = self.syncBatchDataWith(url, andPostForm: param)
        return data["success"] as! Bool
    }
    /**
     通过PostID 获取帖子详情
     
     - parameter id: 帖子ID
     
     - returns: 帖子实体对象
     */
    func getUserPostDetailById(id: String) -> XKRWUserPostEntity? {
        let url = NSURL(string: kNewServer + kGetPostDetail)
        let param = ["postid": id]
        
        let data = self.syncBatchDataWith(url, andPostForm: param)["data"] as! [String: AnyObject]
   
        Log.debug_println(data)
        
        if let status = data["status"] as? Int where status == 3 || status == 2 {
            let entity = XKRWUserPostEntity()
            entity.status = XKRWPostStatus(rawValue: status) ?? .DeleteByAdmin
            return entity
        }
        let entity = XKRWUserPostEntity()
        
        entity.postID = data["postid"] as? String
        entity.postGroupID = data["groupid"] as? String
        entity.postGroupName = data["group_name"] as? String
        entity.postTitle = data["title"] as? String
        entity.textContent = data["content"] as? String
        print(data["pics"])
        
        if((!data["pics"]!.isKindOfClass(NSNull.classForCoder())) ){
            
            let jsonContent = data["pics"] as! String
            var content: NSArray
            do {
                content = try NSJSONSerialization.JSONObjectWithData(jsonContent.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as! NSArray
                
            } catch {
                Log.debug_println("JSON parser error")
                return nil
            }
            
            for temp in content  where temp is NSDictionary {
                if(temp["flag"] != nil && temp["url"] != nil)
                {
                    if temp["flag"] as! Int == 1 {
                        entity.imagePath.append(temp["url"] as! String)
                    } else {
                        entity.imagePath.append(photoVerifingPicturePath)
                    }
                }
            }
           
        }
        
        entity.postCreatTime = data["create_time"]!.integerValue
        entity.sharePostUrl =  data["url"] as? String
        entity.postViewNums = data["views"]!.integerValue
        entity.postBePraise = data["goods"]!.integerValue
        if(data["is_good"]!.integerValue == 0){
            entity.isThumpUp = false
        }else{
            entity.isThumpUp = true
        }
        if(data["group_user_in"]!.integerValue == 0){
            entity.groupUserJoin = false
        }else{
            entity.groupUserJoin = true
        }
        
        if(data["is_help"]!.integerValue == 0){
            entity.isHelpPost = false
        }else{
            entity.isHelpPost = true
        }
        
        if(data["is_essence"]!.integerValue == 0){
            entity.isEssencePost = false
        }else{
            entity.isEssencePost = true
        }
        
        if(data["is_top"]!.integerValue == 0){
            entity.isTopPost = false
        }else{
            entity.isTopPost = true
        }
        
        entity.userHeadUrl = data["avatar"] as? String
        entity.userName = data["nickname"] as? String
        entity.userManifesto = data["manifesto"] as? String
        entity.levelUrl = data["level"] as? String
        
        
        return entity
    }
   
    func getUserArticleListWithNickName(nickname: String?, page: Int, pagesize: Int) -> [NSObject: AnyObject]? {
        
        let url = NSURL(string: kNewServer + kGetUserArticleList)
        
        var param: [String: AnyObject]?
        if nickname != nil {
            param = ["nickname": nickname!, "page":page, "pagesize":pagesize]
        } else {
            param = ["nickname": "", "page":page, "pagesize":pagesize]
        }
        
        let result = self.syncBatchDataWith(url, andPostForm: param) as NSDictionary
        print(result)
        let success = result["success"]
        let data = result["data"] as! NSArray
        var entities = [XKRWArticleListEntity]()
        
        for dic in data where dic is NSDictionary {
            
            let temp             = XKRWArticleListEntity()
            temp.blogId          = dic["blogid"] as! String
            temp.createTime      = (dic["ctime"] as! NSString).integerValue
            
            if let status = dic["status"] as? NSString {
                temp.articleState = XKRWUserArticleStatus(rawValue: status.integerValue) ?? .Unrecommended
            } else if let status = dic["status"] as? Int {
                temp.articleState = XKRWUserArticleStatus(rawValue: status) ?? .Unrecommended
            }
            temp.recommendState  = temp.articleState
            temp.title           = dic["title"] as! String
            temp.bePraisedNum    = dic["goods"] as! Int
            temp.articleViewNums = dic["views"] as! Int

            let jsonCover        = dic["cover_pic"] as! NSString
  
            let topicEntity             = XKRWTopicEntity.init(id: (dic["topic_key"] as! NSString).integerValue, name: String(dic["topic_name"]), enabled: true)
            temp.topic = topicEntity;
            
            do {
                let coverDic = try NSJSONSerialization.JSONObjectWithData(jsonCover.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                
                temp.coverEnabled = coverDic["flag"] as! Int
                if temp.coverEnabled != 0 {
                    temp.coverImageUrl = coverDic["url"] as! String
                } else {
                    temp.coverImageUrl = coverVerifingPicturePath
                }
            } catch {

            }
            entities.append(temp)
        }
        let resultDic = ["success":success!,"data":entities]
        return resultDic
    }
    
    func deleteUserArticleById(id: String) -> Bool {
        
        let url = NSURL(string: kNewServer + kDeleteUserArticle)
        let param = ["blogid": id]
        
        self.syncBatchDataWith(url, andPostForm: param, withLongTime: true)
        self.deleteLocalArticleWithArticleId(id)
        
        return true
    }
    
    // MARK: - Local functions -
    
    /**
    保存文章实体到数据库
    
    - parameter entity: 文章实体
    
    - returns: 是否成功
    */
    func saveArticleToDatabaseWithEntity(entity: XKRWUserArticleEntity) -> Bool {
        
        if entity.date == nil {
            entity.date = NSDate()
        }
        
        let string = entity.date!.stringWithFormat("yyyy-MM-dd")
        let timestamp = Int(entity.date!.timeIntervalSince1970)
        let content = NSKeyedArchiver.archivedDataWithRootObject(entity.textContent)
        let imagePaths = NSKeyedArchiver.archivedDataWithRootObject(entity.imagePath)
        
        let param: NSMutableDictionary =
        [
            "user_id": entity.uid,
            "user_account": entity.user_account ?? NSNull(),
            "user_nickname": entity.user_nickname ?? NSNull(),
            "user_manifestro": entity.user_manifesto ?? NSNull(),
            "user_avatar": entity.user_avatar ?? NSNull(),
            "user_level": entity.user_level ?? NSNull(),
            "aid": entity.aid,
            "article_title": entity.articleTitle,
            "read_num": entity.readNumber,          "like_num": entity.likeNumber,
            "status": entity.status.rawValue,       "timestamp": timestamp,
            "date": string,
            "content": content,                     "image_paths": imagePaths
        ]
        
        // write code like this is cause of XCode 7.0's bug

        param["cover_image_url"] = entity.mainPicturePath ?? NSNull()
        
        if entity.topic != nil {
            param["topic_id"] = entity.topic!.topicId
            param["topic_name"] = entity.topic!.name
        } else {
            param["topic_id"] = NSNull()
            param["topic_name"] = NSNull()
        }
        Log.debug_println(param)
        
        let sql = "replace into user_article values (:user_id, :user_account, :user_nickname, :user_manifestro, :user_avatar, :user_level, :aid, :article_title, :cover_image_url, :topic_id, :topic_name, :read_num, :like_num, :content, :image_paths, :status, :timestamp, :date)"
        
        if self.executeSqlWithDictionary(sql, withParameterDictionary: param as [NSObject : AnyObject]) {
            return true
        }
        return false
    }
    
    /**
    保存草稿
    
    - parameter entity: 文章实体
    
    - returns: 是否成功
    */
    func saveDraftWithEntity(entity: XKRWUserArticleEntity) -> Bool {
        
        assert(entity.textContent.count == entity.originalImages.count, "文章模型文字和图片段数不符")
        guard entity.textContent.count == entity.originalImages.count else {
            return false
        }
        
        entity.user_account = XKRWUserService.sharedService().getUserAccountName()
        // TODO:
//        entity.user_level =
        entity.user_avatar    = XKRWUserService.sharedService().getUserAvatar()
        entity.user_nickname  = XKRWUserService.sharedService().getUserNickName()
        entity.user_manifesto = XKRWUserService.sharedService().getUserManifesto()
        entity.uid            = XKRWUserService.sharedService().getUserId()
        
        
        // save path to entity.content
        
        entity.imagePath.removeAll()
        
        for images in entity.originalImages {
            
            var paths = [String]()
            
            for image in images {
                
                if image.path == nil {
                    
                    if let path = XKRWUserArticleService.cacheImage(image) {
                        paths.append(path)
                        image.path = path
                    }
                    else { // out
                        XKRWCui.showInformationHudWithText("草稿缓存图片失败")
                        return false
                    }
                } else {
                    // because the imageName should be saved in database only
                    let imaegName = image.path!.componentsSeparatedByString("/").last!
                    paths.append(imaegName)
                }
            }
            entity.imagePath.append(paths)
        }
        
        if entity.mainPicture != nil && entity.mainPicture?.path == nil {
            entity.mainPicture?.path = XKRWUserArticleService.cacheImage(entity.mainPicture!)
            entity.mainPicturePath = entity.mainPicture?.path
        }
        // because the imageName should be saved in database only
        else if entity.mainPicture != nil {
            let imageName = entity.mainPicture!.path!.componentsSeparatedByString("/").last!
            entity.mainPicturePath = imageName
        }
        
        if !self.saveArticleToDatabaseWithEntity(entity) {
            return false
        }
        
        // change the image.path from image name to full path
        entity.imagePath.removeAll()
        for images in entity.originalImages {
            
            var paths = [String]()
            for image in images {
                
                let path = userPicturesDirectory.stringByAppendingPathComponent(image.path!)
                paths.append(path)
                image.path = path
            }
            entity.imagePath.append(paths)
        }
        
        if entity.mainPicture != nil && entity.mainPicture?.path != nil {
            entity.mainPicture?.path = userPicturesDirectory.stringByAppendingPathComponent(entity.mainPicture!.path!)
            entity.mainPicturePath = entity.mainPicture?.path
        }
        return true
    }
    
    /**
    更新数据库中文章状态
    
    - parameter entity: 文章实体对象
    - parameter status: 状态
    
    - returns: 是否成功
    */
    func updateStatusWithEntity(entity: XKRWUserArticleEntity, status: XKRWUserArticleStatus) -> Bool {
        
        entity.status = status
        
        let sql = "update user_article (status) values (\(entity.status.rawValue)) where user_account = \(entity.user_account!) and timestamp = \(Int(entity.date!.timeIntervalSince1970))"
        
        return self.executeSqlWithDictionary(sql, withParameterDictionary: nil)
    }
    /**
    Delete local user article data in database with article's id
    
    - parameter articleId: article's id
    
    - returns: Whether succeed
    */
    func deleteLocalArticleWithArticleId(articleId: String) -> Bool {
        
        if let entity = self.getUserArticleById(articleId) {
            entity.deleteLocalImageCache()
        }
        let sql = "delete from user_article where aid = '\(articleId)'";
        
        return self.executeSqlWithDictionary(sql, withParameterDictionary: nil)
    }
    /**
    Delete local user article data in database with the entity of user's article
    
    - parameter entity: Entity of user's article
    
    - returns: Success or not
    */
    func deleteLocalArticleWithEntity(entity: XKRWUserArticleEntity) -> Bool {
        
        if !entity.aid.isEmpty {
            return self.deleteLocalArticleWithArticleId(entity.aid)
        }
        else {
            entity.deleteLocalImageCache()
            
            if entity.user_account != nil && entity.date != nil {
                let sql = "delete from user_article where user_account = '\(entity.user_account!)' and timestamp = \(Int(entity.date!.timeIntervalSince1970))"
                return self.executeSqlWithDictionary(sql, withParameterDictionary: nil)
            } else {
                return true
            }
        }
    }
    
    func getAllLocalUserArticles() -> [XKRWUserArticleEntity] {
        
        let uid = XKRWUserService.sharedService().getUserId()
        let sql = "select * from user_article where status != 0 and user_id = \(uid) order by timestamp DESC"
        return self.queryUserArticlesWithSQL(sql)
    }
    
    func getUserArticleDraft() -> [XKRWUserArticleEntity] {
        
        let uid = XKRWUserService.sharedService().getUserId()
        let sql = "select * from user_article where status = 0 and user_id = \(uid) order by timestamp DESC"
        return self.queryUserArticlesWithSQL(sql)
    }
    
    func getUserArticleById(id: String) -> XKRWUserArticleEntity? {
        
        let sql = "select * from user_article where aid = '\(id)'"
        return self.queryUserArticlesWithSQL(sql).first
    }
    
    private func queryUserArticlesWithSQL(sql: String) -> [XKRWUserArticleEntity] {
        
        var entities = [XKRWUserArticleEntity]()
        
        if let rst = self.query(sql) {
            for dic in rst where dic is NSDictionary {
                let entity = self.convertDictionaryToEntity(dic as! NSDictionary)
                
                var paths = [[String]]()
                for temp in entity.imagePath {
                    
                    var group = [String]()
                    for imageName in temp {
                        let path = userPicturesDirectory.stringByAppendingPathComponent(imageName)
                        group.append(path)
                    }
                    paths.append(group)
                }
                entity.imagePath = paths
                
                if entity.mainPicturePath != nil {
                    let path = userPicturesDirectory.stringByAppendingPathComponent(entity.mainPicturePath!)
                    entity.mainPicturePath = path
                }
                entities.append(entity)
            }
        }
        return entities
    }
    
    private func convertDictionaryToEntity(dic: NSDictionary) -> XKRWUserArticleEntity {
        
        //TODO:
        let entity = XKRWUserArticleEntity()
        
        entity.user_level     = dic["user_level"] as? String
        entity.user_manifesto = dic["user_manifesto"] as? String
        entity.uid            = dic["user_id"] as! Int
        entity.user_nickname  = dic["user_nickname"] as? String
        entity.user_avatar    = dic["user_avatar"] as? String
        entity.user_account   = dic["user_account"] as? String

        entity.likeNumber     = dic["like_num"] as! Int
        entity.readNumber     = dic["read_num"] as! Int
        entity.aid            = dic["aid"] as! String
        
        entity.articleTitle = dic["article_title"] as! String
        entity.mainPicturePath = dic["cover_image_url"] as? String
        entity.textContent = NSKeyedUnarchiver.unarchiveObjectWithData(dic["content"] as! NSData) as! [String]
        entity.imagePath = NSKeyedUnarchiver.unarchiveObjectWithData(dic["image_paths"] as! NSData) as! [[String]]
        
        if let topicId = dic["topic_id"] as? Int, let topicName = dic["topic_name"] as? String {
            let topic = XKRWTopicEntity(id: topicId, name: topicName, enabled: true)
            entity.topic = topic
        }
        entity.status = XKRWUserArticleStatus(rawValue: dic["status"] as! Int)!
        entity.date = NSDate(timeIntervalSince1970: NSTimeInterval(dic["timestamp"] as! Int))
        
        return entity
    }
    
    // MARK: Public: 压缩图片
    /**
    压缩图片
    
    - parameter image:     图片
    - parameter aboveSize: 多少大小以上需要压缩（单位：byte）
    - parameter maxWidth:  最大宽度（image.size.width <= maxWidth）
    
    - returns: 压缩后的图片
    */
    class func compressImage(image: UIImage, aboveSize: Int, maxWidth: CGFloat?) -> UIImage {
        
        var downSizeImage: UIImage
        
        if maxWidth != nil {
            if image.size.width > maxWidth! {
                downSizeImage = image.scaleToSize(CGSizeMake(maxWidth!, image.size.height / image.size.width * maxWidth!))
            } else {
                downSizeImage = image
            }
        }
        // 默认处理
        else {
            if image.size.width > UI_SCREEN_WIDTH * 2 {
                 downSizeImage = image.scaleToSize(CGSizeMake(UI_SCREEN_WIDTH * 2, image.size.height / image.size.width * UI_SCREEN_WIDTH * 2))
            } else {
                downSizeImage = image.scaleToSize(CGSizeMake(image.size.width / 2, image.size.width / 2))
            }
        }
        if UIImagePNGRepresentation(downSizeImage)?.length > aboveSize {
            return UIImage(data: UIImageJPEGRepresentation(downSizeImage, 0.6)!)!
        } else {
            return downSizeImage
        }
    }
    
    /**
    压缩图片大小到maxSize以下，image.size会缩小
    
    - parameter image:   图片
    - parameter maxSize: 最大图片容量大小
    
    - returns: 压缩后的图片
    */
    class func compressImage(image: UIImage, maxSize: Int) -> UIImage {
        
        let downSizeImage = image.scaleToSize(CGSizeMake(image.size.width * 0.8, image.size.height * 0.8))
        
        if UIImagePNGRepresentation(downSizeImage)?.length > maxSize {
            
            var compressed = UIImage(data: UIImageJPEGRepresentation(downSizeImage, 0.0001)!)!
            
            if UIImagePNGRepresentation(compressed)?.length > maxSize {
                compressed = compressImage(compressed, maxSize: maxSize)
            }
            return compressed
        } else {
            return image
        }
    }
    
    // MARK: Public: 缓存图片
    /**
    缓存图片
    
    - parameter image: 图片对象
    
    - returns: 缓存的本地地址(路径)
    */
    class func cacheImage(image: UIImage) -> String? {
        
        let path = userPicturesDirectory
        
        let imageName = "image_cache_\(XKRWUserArticleService.imageCount++).png"
        let imagePath = path.stringByAppendingPathComponent(imageName)
        
        if UIImagePNGRepresentation(image)!.writeToFile(imagePath, atomically: true) {
            return imageName
        } else {
            return nil
        }
    }
    
    
    // MARK: Public: 删除缓存图片
    /**
    删除缓存的图片
    
    - parameter path: 图片缓存的本地路径
    */
    class func removeCachedImageWithPath(path: String) {
        do { try NSFileManager.defaultManager().removeItemAtPath(path) }
        catch { Log.debug_println(error) }
    }
    
}
