//
//  ToDoListViewController.swift
//  Test1
//
//  Created by t2023-m0067 on 2023/08/07.
//

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

// 등록 데이터
struct Memo{
    var title: String?
    var isCompleted: Bool = false
}
// 클래스 생성, static변수 선언해서 데이터 받아오기, 싱글톤패턴
class MemoStore {
    static var data: Array<Memo> = []
}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // 테이블 뷰
    var tableView: UITableView!
    // 스위치 호출
    var onOff: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 테이블 뷰 초기화
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        // 등록한 셀 호출
        CustomCell.register(target: self.tableView)

        // 테이블 뷰 등록
        view.addSubview(tableView)
        
    }

    // 등록 처리
    @IBAction func BarButtonAction(_ sender: Any) {

        let alert = UIAlertController(title: "등록", message: nil, preferredStyle: .alert)
        
        alert.addTextField {(textField) in
            textField.placeholder = "할 일을 입력하세요"
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "추가", style: .default, handler: { action in
            if let toDo = alert.textFields?.first?.text{
                MemoStore.data.append(Memo(title: toDo))
                self.tableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 테이블 뷰 셀 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoStore.data.count
    }
    

    // 테이블 뷰 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "MyTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath)
        
        // 스위치 호출
        onOff = UISwitch(frame: .zero)
        // switch tag 지정
        onOff.tag = indexPath.row
        // 초기 생성 시 버튼 누르지 않은 채로 생성
        onOff.isOn = MemoStore.data[indexPath.row].isCompleted
        // switch addtarget 지정
        onOff.addTarget(self, action: #selector(self.switchDidChange(_:)), for: .valueChanged)
        //cell accessoryView를 switch로 지정
        cell.accessoryView = onOff

        // 테이블뷰 생성
        cell.textLabel?.text = MemoStore.data[indexPath.row].title
        
        return cell
    }

    // 스위치 상태 바뀔 때 마다 처리
    @objc func switchDidChange(_ sender: UISwitch){
       
        if sender.isOn == true {
            MemoStore.data[sender.tag].isCompleted = true
            
        }else{
            MemoStore.data[sender.tag].isCompleted = false
        }
        
    }
    
    // 테이블 뷰 셀 선택 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 셀의 항목 출력
        performSegue(withIdentifier: "ShowDetail", sender: indexPath.row)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 셀 선택 시 디테일 페이지 이동
        if segue.identifier == "ShowDetail" {
            let vc = segue.destination as? CellDetailViewController
            if let first_index = sender as? Int {
                vc?.numOfPage = first_index
            }
        }
        
        // 스위치 on 시 체크리스트 페이지로 이동
//        if segue.identifier == "ShowCheckList" {
//            let vc2 = segue.destination as? CheckListViewController
//            if let index = sender as? Int {
//                vc2?.numOfCheckPage = index
//            }
//        }
        
    }
    
}






