//
//  EFACalendarDayCell.swift
//  EFAB
//
//  Created by Brett Keck on 5/20/16.
//  Copyright © 2016 Eleven Fifty Academy. All rights reserved.
//

import UIKit

class EFACalendarDayCell: UICollectionViewCell {
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var dot: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        bg.layer.cornerRadius = 4.0
        bg.layer.borderColor = borderColor.CGColor
        bg.layer.borderWidth = 0.0
        bg.center = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        bg.backgroundColor = ColorPalette.calendarCellColor
        
        dot.layer.cornerRadius = 3.0
        dot.backgroundColor = UIColor.clearColor()
    }
    
    var isToday : Bool = false {
        didSet {
            if isToday {
                bg.backgroundColor = ColorPalette.calendarTodayColor
            } else {
                bg.backgroundColor = ColorPalette.calendarCellColor
            }
        }
    }
    
    override var selected : Bool {
        didSet {
            if selected {
                bg.layer.borderWidth = 2.0
            } else {
                bg.layer.borderWidth = 0.0
            }
        }
    }
    
    var hasExpenses = false {
        didSet {
            if hasExpenses {
                dot.backgroundColor = ColorPalette.BlueColor
            } else {
                dot.backgroundColor = UIColor.clearColor()
            }
        }
    }
}