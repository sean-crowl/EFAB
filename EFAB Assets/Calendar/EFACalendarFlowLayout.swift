//
//  EFACalendarFlowLayout.swift
//  EFAB
//
//  Created by Brett Keck on 5/20/16.
//  Copyright © 2016 Eleven Fifty Academy. All rights reserved.
//

import UIKit

class EFACalendarFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElementsInRect(rect)?.map {
            attributes in
            let attributesCopy = attributes.copy() as! UICollectionViewLayoutAttributes
            self.applyLayoutAttributes(attributesCopy)
            return attributesCopy
        }
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForItemAtIndexPath(indexPath) {
            let attributesCopy = attributes.copy() as! UICollectionViewLayoutAttributes
            self.applyLayoutAttributes(attributesCopy)
            return attributesCopy
        }
        return nil
    }
    
    func applyLayoutAttributes(attributes : UICollectionViewLayoutAttributes) {
        if attributes.representedElementKind != nil {
            return
        }
        
        if let collectionView = self.collectionView {
            let stride = (self.scrollDirection == .Horizontal) ? collectionView.frame.size.width : collectionView.frame.size.height
            let offset = CGFloat(attributes.indexPath.section) * stride
            var xCellOffset: CGFloat = CGFloat(attributes.indexPath.item % 7) * self.itemSize.width
            var yCellOffset: CGFloat = CGFloat(attributes.indexPath.item / 7) * self.itemSize.height
            if self.scrollDirection == .Horizontal {
                xCellOffset += offset;
            } else {
                yCellOffset += offset
            }
            attributes.frame = CGRectMake(xCellOffset, yCellOffset, self.itemSize.width, self.itemSize.height)
        }
    }
}