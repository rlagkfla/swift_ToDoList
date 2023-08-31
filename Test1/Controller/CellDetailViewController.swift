//
//  CellDetailViewController.swift
//  Test1
//
//  Created by t2023-m0067 on 2023/08/09.
//

import UIKit

class CellDetailViewController: UIViewController {

    let memoManager = DataManager.shared
    
    // 선택한 셀 인덱스 값 받아오기
    var numOfPage: Int?
    
    // UserDefaults 객체 생성
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
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
    
    // UserDefaults 사용하여 Update 구현
    @IBAction func UpdateMemo(_ sender: Any) {
        
        let alert = UIAlertController(title: "수정하시겠습니까?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "수정", style: .destructive, handler: { action in
            if let updateMemo = self.showDetail.text {
                MemoStore.data[self.numOfPage!].title = updateMemo
                // 수정하여 저장 
                self.memoManager.saveData()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
