//
//  Swift-Extensions.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/16.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit
import ObjectiveC

extension String {
    
    /**
    Be able to use range to get substring, e.x.: "abced"[0...1] = "ab"
    */
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    /// length of String, number of characters -- Swift 2.0
    var length: Int {
        return self.characters.count
    }
    
    /// MD5 of string, need to #import <CommonCrypto/CommonCrypto.h> in bridge file
    var MD5: String {
        let cString = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let length = CUnsignedInt(
            self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        )
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(
            Int(CC_MD5_DIGEST_LENGTH)
        )
        
        CC_MD5(cString!, length, result)
        
        return String(format:
            "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15])
    }
}

private var imagePath: String = "image_path"
private var imageURL: String = "image_url"
private var c_image: String = "compressed_image"
private var image_info: String = "image_info"

extension UIImage {
    
    var path: String? {
        get {
            return objc_getAssociatedObject(self, &imagePath) as? String
        }
        set {
            objc_setAssociatedObject(self, &imagePath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var url: String? {
        get {
            return objc_getAssociatedObject(self, &imageURL) as? String
        }
        set {
            objc_setAssociatedObject(self, &imageURL, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var compressedImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &c_image) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &c_image, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var info: NSMutableDictionary {
        get {
            if let dic = objc_getAssociatedObject(self, &image_info) as? NSMutableDictionary {
                return dic
            } else {
                objc_setAssociatedObject(self, &image_info, NSMutableDictionary(), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return self.info
            }
        }
        set {
            objc_setAssociatedObject(self, &image_info, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
