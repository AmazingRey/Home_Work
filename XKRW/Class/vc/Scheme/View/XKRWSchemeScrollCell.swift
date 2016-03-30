//
//  XKRWSchemeScrollCell.swift
//  XKRW
//
//  Created by XiKang on 15/5/26.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWSchemeScrollCell: UITableViewCell, UIScrollViewDelegate {
    
    var scrollView: UIScrollView = UIScrollView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 450))
    var tableView_left: UITableView = UITableView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 450))
    var tableView_center: UITableView = UITableView(frame: CGRectMake(UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, 450))
    var tableView_right: UITableView = UITableView(frame: CGRectMake(UI_SCREEN_WIDTH * 2, 0, UI_SCREEN_WIDTH, 315))
    
    var pageIndex: Int = 2
    
    var displayedTableView: UITableView {
        get {
            let tableView = self.scrollView.viewWithTag(100+self.pageIndex) as? UITableView
            
            if tableView != nil {
                return tableView!
            }
            return tableView_center
        }
    }
    
    weak var delegate: protocol<UITableViewDelegate, UITableViewDataSource>? {
        
        didSet {
            tableView_left.delegate = self.delegate
            tableView_center.delegate = self.delegate
            tableView_right.delegate = self.delegate
            
            tableView_left.dataSource = self.delegate
            tableView_center.dataSource = self.delegate
            tableView_right.dataSource = self.delegate
        }
    }
    
    //MARK: - Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSubviews()
    }
    
    internal func initSubviews() {
        
        self.selectionStyle = .None
        
        self.contentView.backgroundColor = XK_BACKGROUND_COLOR
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * 3, 0)

        self.scrollView.pagingEnabled = true
        self.scrollView.setContentOffset(CGPointMake(UI_SCREEN_WIDTH, 0), animated: false)
        //MARK: 暂设为不可滑动，只可在点击段选项卡时控制滑动
        self.scrollView.scrollEnabled = false
        
        self.scrollView.bounces = false
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(scrollView)
        
        var tag: Int = 101
        
        func configTableViews(tableView: UITableView) {
            
            tableView.backgroundColor = UIColor.clearColor()
            tableView.scrollEnabled = false
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            tableView.tag = tag++
            
            self.scrollView.addSubview(tableView)
            
            tableView.registerNib(UINib(nibName: "XKRWNoticeEntryCell", bundle: nil), forCellReuseIdentifier: "noticeCell")
        }
        configTableViews(tableView_left)
        configTableViews(tableView_center)
        configTableViews(tableView_right)
        
        tableView_left.registerNib(UINib(nibName: "XKRWMealSchemeCell", bundle: nil), forCellReuseIdentifier: "sportCell")
        tableView_center.registerNib(UINib(nibName: "XKRWMealSchemeCell", bundle: nil), forCellReuseIdentifier: "mealCell")
        tableView_right.registerNib(UINib(nibName: "XKRWHabitRecordCell", bundle: nil), forCellReuseIdentifier: "habitCell")
    }
    
    func setCellHeight(height: CGFloat) -> Void {
        self.height = height
        tableView_center.height = height
    }
    
    //MARK: resize cell's height and subViews height
    internal func resizeViews() {
        
    }
    
    //MARK: - Other functions
    /**
    Let the Scrollview scroll to the page
    
    - parameter page: Page, Start from 1
    */
    func scrollToPage(page: Int) {
        
        if page == pageIndex {
            return
        }
        let offSet = CGFloat(page - 1) * UI_SCREEN_WIDTH
        self.scrollView.setContentOffset(CGPointMake(offSet, 0), animated: true)
        
        pageIndex = page
    }
    
    func resizeSelf() -> Void {
        
        var maxHeight: CGFloat =  306.0
        
//        tableView_center.reloadData()
//        tableView_right.reloadData()
        
        if tableView_center.contentSize.height > tableView_right.contentSize.height {
            maxHeight = tableView_center.contentSize.height > maxHeight ? tableView_center.contentSize.height : maxHeight
        } else {
            maxHeight = tableView_right.contentSize.height > maxHeight ? tableView_right.contentSize.height : maxHeight
        }
        self.height = maxHeight
        self.scrollView.height = maxHeight
        tableView_center.height = maxHeight
        tableView_left.height = maxHeight
        tableView_right.height = maxHeight
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
