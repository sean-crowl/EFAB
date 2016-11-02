//
//  EFACalendarView.swift
//  EFAB
//
//  Created by Brett Keck on 5/20/16.
//  Copyright © 2016 Eleven Fifty Academy. All rights reserved.
//

import UIKit
import AFDateHelper

let numberOfDaysInWeek = 7
let maximumNumberOfRows = 6
let headerDefaultHeight: CGFloat = 60.0
let monthsInYear = 12



class EFACalendarView: UIView {

    
    private let startDate = Utils.adjustedTime().dateBySubtractingMonths(monthsInYear * 2)
    private let endDate = Utils.adjustedTime().dateByAddingMonths(monthsInYear * 2)
    
    private var calendarStartDate: NSDate = NSDate()
    private var todayIndexPath: NSIndexPath?
    private var dateBeingSelectedByUser: NSDate?
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: - UICollectionViewDataSource/Delegate
extension EFACalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
    
}


// MARK: - UIScrollViewDelegate
extension EFACalendarView: UIScrollViewDelegate {
    
}