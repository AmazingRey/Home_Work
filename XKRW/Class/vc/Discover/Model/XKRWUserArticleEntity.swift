//
//  XKRWUserArticleEntity.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/18.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWUserArticleEntity: NSObject {
    
    static let textKey = "text"
    static let imgKey = "pics"
    
    /// 用户账号
    var user_account: String?
    /// 用户id
    var uid: Int = 0
    /// 用户昵称
    var user_nickname: String?
    /// 用户宣言
    var user_manifesto: String?
    /// 用户头像
    var user_avatar: String?
    /// 用户等级图片url -- big problem in future
    var user_level: String?
    /// 文章id
    var aid: String = ""
    /// 文章标题
    var articleTitle: String = ""
    
    /// 主图片path或URL
    var mainPicturePath: String?
    /// 主图片
    var mainPicture: UIImage?
    
    /// 话题
    var topic: XKRWTopicEntity?
    
    /// 阅读数
    var readNumber: Int = 0
    /// 点赞数
    var likeNumber: Int = 0
    
    /// 文章内容
    var textContent: [String] = []
    /// 文章内容中的原图图片数组
    var originalImages: [[UIImage]] = []
    
    /// 图片路径，对应content中的imgKey的内容，用于上传图片和出错后的续传
    var imagePath: [[String]] = []
    
    
//    /// 上传用的压缩处理过的图片，处理之前需清空该数组
//    var compressedImages: [[UIImage]] = []
//    /// 文章内容的图片缩略图数组
//    var thumbImages: [[UIImage]] = []
    
    /// 状态
    var status: XKRWUserArticleStatus = .Draft
    /// 创建时间
    var date: NSDate?
    /// 优先级（用于显示）
    var priorityLevel: Int = 0
    
    /// 是否已点击喜欢
    var isLike: Bool = false
    /// 文章分享链接
    var articleURL: String?
    /// 评论数
    var commentNum: Int = 0
    
    override init() {
        super.init()
    }
    
    func deleteContentAtIndex(index: Int) {
        self.textContent.removeAtIndex(index)
        
        let content = self.originalImages.removeAtIndex(index)
        
        for image in content where image.path != nil {
            XKRWUserArticleService.removeCachedImageWithPath(image.path!)
        }
    }
    
    func checkComplete() -> Bool {
        
        if self.articleTitle.isEmpty  {
            return false
        }
        
        if self.mainPicture == nil {
            return false
        }
        
        if self.topic == nil {
            return false
        }
        
        if self.textContent.isEmpty {
            return false
        }
        return true
    }
    
    func checkNeedSaveAsDraft() -> Bool {
        if !self.articleTitle.isEmpty {
            return true
        }
        
        if self.mainPicture != nil {
            return true
        }
        
        if self.topic != nil {
            return true
        }
        
        if !self.textContent.isEmpty {
            return true
        }
        return false
    }
    
    /**
    如果为草稿或离线，从本地读取缓存图片
    */
    func loadLocalImageCache() {
        
        self.originalImages = []
        
        for temp in self.imagePath {
            
            var images = [UIImage]()
            
            for path in temp {
                if let image = UIImage(contentsOfFile: path) {
                    image.path = path
                    images.append(image)
                }
            }
            self.originalImages.append(images)
        }
        
        if self.mainPicturePath != nil {
            self.mainPicture = UIImage(contentsOfFile: self.mainPicturePath!)
            self.mainPicture!.path = self.mainPicturePath!
        }
    }
    
    func deleteLocalImageCache() {
        
        for content in self.imagePath {
            for path in content {
                XKRWUserArticleService.removeCachedImageWithPath(path)
            }
        }
        if self.mainPicturePath != nil {
            XKRWUserArticleService.removeCachedImageWithPath(self.mainPicturePath!)
        }
    }
    
    /**
    Convert to ArticleListEntity, advice to delete that entity in later version.
    
    - returns: ArticleListEntity
    */
    func convertToListEntity() -> XKRWArticleListEntity {
        
        let entity                = XKRWArticleListEntity()
        entity.headImageUrl       = self.user_avatar ?? ""
        entity.blogId             = self.aid
        entity.coverImageUrl      = self.mainPicturePath ?? ""
        entity.createTime         = Int(self.date?.timeIntervalSince1970 ?? 0)
        entity.bePraisedNum       = self.likeNumber
        entity.userDegreeImageUrl = self.user_level ?? ""
        entity.manifesto          = self.user_manifesto ?? ""
        entity.articleState       = self.status
        entity.userNickname       = self.user_nickname ?? ""
        entity.title              = self.articleTitle
        entity.articleViewNums    = self.readNumber
        entity.topic              = self.topic
        entity.recommendState     = self.status
        return entity
    }
}
