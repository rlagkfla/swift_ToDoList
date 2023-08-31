//
//  Helper.swift
//  Test1
//
//  Created by t2023-m0067 on 2023/08/31.
//

import Foundation
import UIKit

// 테이블 셀 등록 설정
protocol UITableViewRegisterable {
    static var cellId: String { get }
    static var isFromNib: Bool { get }
    
    static func register(target: UITableView)
}

extension UITableViewRegisterable where Self: UITableViewCell {
    static func register(target: UITableView){
        if self.isFromNib {
            target.register(UINib(nibName: self.cellId, bundle: nil), forCellReuseIdentifier: self.cellId)
        } else {
            target.register(Self.self, forCellReuseIdentifier: self.cellId)
        }
    }
}

class CustomCell:UITableViewCell, UITableViewRegisterable {
    static var cellId: String {
        get {
            return "MyTableViewCell"
        }
    }
    static var isFromNib: Bool {
        get {
            return false
        }
    }

}

// 완료 체크 시(스위치 on) 텍스트에 취소선 생성
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func removeStrikeThrough() -> NSAttributedString {
        let attributedString = NSAttributedString(string: self)
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttributedString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, mutableAttributedString.length))
        return mutableAttributedString
    }
}

