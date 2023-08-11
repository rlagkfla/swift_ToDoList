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

        showMemo()
    }

    
    @IBOutlet weak var showLabel: UILabel! // page번호
    @IBOutlet weak var showDetail: UITextView! // text데이터
    
    // 전달받은 데이터 보여주기
    func showMemo(){
        
        guard let numOfPage = numOfPage else {return}
        guard let title = MemoStore.data[numOfPage].title else {return}
        
        showLabel.text = "\(numOfPage + 1) page"
        showDetail.text = "\(title)"
//        print(showDetail.text)
    }
    
    // 메모 수정
    // 여기서 입력받은 값을 변수에 담아서 뒤로가기 버튼 눌렀을 때 리스트뷰 컨트롤러로 전달
    
    
}
