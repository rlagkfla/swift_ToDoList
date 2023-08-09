//
//  CellDetailViewController.swift
//  Test1
//
//  Created by t2023-m0067 on 2023/08/09.
//

import UIKit

class CellDetailViewController: UIViewController {

    // 선택한 셀 인덱스 값 받아오기
    var numOfPage: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    
    @IBOutlet weak var showLabel: UILabel! // page번호
    @IBOutlet weak var showDetail: UITextView! // text데이터
    
    
    func updateUI(){
        
        guard let numOfPage = numOfPage else {return}
        guard let title = MemoStore.data[numOfPage].title else {return}
        
        showLabel.text = "\(numOfPage + 1) page"
        showDetail.text = "\(title)"
    }

}
