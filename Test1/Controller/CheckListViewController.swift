//
//  CheckListViewController.swift
//  Test1
//
//  Created by t2023-m0067 on 2023/08/09.
//

import UIKit


class CheckListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 선택한 셀 인덱스 값 받아오기
    var numOfCheckPage: Int?
    
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self

        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // iscompleted = true만 카운트
        // filter 고차함수
        let isOn = MemoStore.data.filter { Memo in
            Memo.isCompleted == true
        }
        
        return isOn.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        let isOn = MemoStore.data.filter { Memo in
            Memo.isCompleted == true
        }
        
        cell.textLabel?.text = isOn[indexPath.row].title
        
        return cell
    }

}
