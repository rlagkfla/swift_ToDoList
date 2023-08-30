//
//  ToDoListViewController.swift
//  Test1
//
//  Created by t2023-m0067 on 2023/08/07.
//

// 리팩토링,,,
// mvc 패턴 적용
// 1. crud class 생성
// 2. 고유 아이디 필터링해서 해당 메모만 불러와서 업데이트

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
struct Memo: Codable {
    var id = UUID()
    var category: String?
    var title: String?
    var isCompleted: Bool = false
}
// 클래스 생성, static변수 선언해서 데이터 받아오기, 싱글톤패턴
class MemoStore {
    static var data: Array<Memo> = []
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

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    // 테이블 뷰
    var tableView: UITableView!
    // 스위치 호출
    var onOff: UISwitch!

    // UserDefaults 객체 생성
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    // tableview section
    let sections: [String] = ["WORK", "LIFE"]
    // pickerview value
    var typeValue = String()


    override func viewDidLoad() {
        super.viewDidLoad()

        // 테이블 뷰 초기화
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self

        // 등록한 셀 호출
        CustomCell.register(target: self.tableView)

        // 테이블 뷰 등록
        view.addSubview(tableView)

        // 저장된 데이터 불러오기
        if let savedData = defaults.object(forKey: "memo") as? Data {
            if let savedObject = try? decoder.decode([Memo].self, from: savedData) {
                MemoStore.data = savedObject
            }
        }

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("App Directory path : \(NSHomeDirectory())")
        print("data : \(MemoStore.data)")
        // 디테일페이지에서 수정 후 데이터 reload
        tableView.reloadData()

    }

    // PickerView 설정
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

//        print("1 - row: \(row), typevalue: \(typeValue)")
        if row == 0 {
//            print(2)
            typeValue = sections[0]
        } else {
//            print(3)
            typeValue = sections[1]
        }
//        print("4 - row: \(row), typevalue: \(typeValue)")
    }

    // Picker View 액션(임시)
    @IBAction func PickerViewAction(_ sender: Any) {
        // 초기값 설정
        typeValue = sections[0]

        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 100)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: -20, width: 250, height: 100))

//        pickerView.selectRow(sections.firstIndex(of: typeValue)!, inComponent: 0, animated: true)

        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)

        let editRadiusAlert = UIAlertController(title: "할 일 작성", message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addTextField {(textField) in
            textField.placeholder = "할 일을 입력하세요"
        }
        editRadiusAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        editRadiusAlert.addAction(UIAlertAction(title: "선택", style: .default, handler: { action in
//            print("category: \(self.typeValue)")

            if let toDo = editRadiusAlert.textFields?.first?.text{
//                MemoStore.data.append(Memo(category: self.typeValue, title: toDo))
                // 등록 시 저장, encoded는 Data형
                if let encoded = try? self.encoder.encode(MemoStore.data) {
                    self.defaults.set(encoded, forKey: "memo")
                }
                self.tableView.reloadData()
            }
        }))

        self.present(editRadiusAlert, animated: true)
    }


    // 등록 처리
    @IBAction func BarButtonAction(_ sender: Any) {

//        let alert = UIAlertController(title: "등록", message: nil, preferredStyle: .alert)
//
//        alert.addTextField {(textField) in
//            textField.placeholder = "할 일을 입력하세요"
//        }
//
//        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
//
//        alert.addAction(UIAlertAction(title: "추가", style: .default, handler: { action in
//            if let toDo = alert.textFields?.first?.text{
//                MemoStore.data.append(Memo(title: toDo))
//                // 등록 시 저장, encoded는 Data형
//                if let encoded = try? self.encoder.encode(MemoStore.data) {
//                    self.defaults.set(encoded, forKey: "memo")
//                }
//                self.tableView.reloadData()
//            }
//        }))
//
//        self.present(alert, animated: true, completion: nil)
    }

    func filterCategory(category: String) -> [Memo] {
        return MemoStore.data.filter {
            $0.category == category
        }
    }


    // Section 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    // Section 이름
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    // 테이블 뷰 셀 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("11category: \(typeValue) , section: \(section)")
        if section == 0 {
//            print(11)

            return filterCategory(category: "WORK").count
        } else if section == 1{
//            print(22)
            return filterCategory(category: "LIFE").count
        } else {
//            print(33)
            return 0
        }

//        print("11category: \(typeValue) , section: \(section)")
//        if typeValue == "WORK" {
//            print(11)
//            return MemoStore.data.count
//        } else {
//            print(22)
//            return MemoStore.data.count
//        }
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
//        onOff.isOn = filterCategory(category: )[indexPath.row].isCompleted
        // switch addtarget 지정
        onOff.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
        //cell accessoryView를 switch로 지정
//        cell.accessoryView = onOff

        print("typevalue: \(typeValue)")

        // 테이블뷰 생성(취소선 유무)
//        if onOff.isOn == true {
//            cell.textLabel?.attributedText = filterCategory(category: "WORK")[indexPath.row].title?.strikeThrough()
//        }else{
//            cell.textLabel?.attributedText = filterCategory(category: "LIFE")[indexPath.row].title?.removeStrikeThrough()
//        }

//        if indexPath.section == 0 {
//            cell.textLabel?.text = MemoStore.data[indexPath.row].title
//        }else if indexPath.section == 1 {
//            cell.textLabel?.text = MemoStore.data[indexPath.row].title
//        }else {
//            return UITableViewCell()
//        }
//        print("44category: \(typeValue)")
//        if typeValue == "WORK" {
////            print(44)
//            cell.textLabel?.text = filterCategory(category: "WORK")[indexPath.row].title
//        } else {
////            print(55)
//            cell.textLabel?.text = filterCategory(category: "LIFE")[indexPath.row].title
//        }

        switch indexPath.section {
        case 0:
//            cell.textLabel?.text = filterCategory(category: "WORK")[indexPath.row].title
            cell.textLabel?.attributedText = onOff.isOn == true ? filterCategory(category: "WORK")[indexPath.row].title?.strikeThrough() : filterCategory(category: "WORK")[indexPath.row].title?.removeStrikeThrough()
            onOff.isOn = filterCategory(category: "WORK")[indexPath.row].isCompleted
            cell.accessoryView = onOff
        case 1:
//            cell.textLabel?.text = filterCategory(category: "LIFE")[indexPath.row].title
            cell.textLabel?.attributedText = onOff.isOn == true ? filterCategory(category: "LIFE")[indexPath.row].title?.strikeThrough() : filterCategory(category: "LIFE")[indexPath.row].title?.removeStrikeThrough()
            onOff.isOn = filterCategory(category: "LIFE")[indexPath.row].isCompleted
            cell.accessoryView = onOff
        default:
            return UITableViewCell()
        }



        return cell
    }

    // 스위치 상태 바뀔 때 마다 처리
    @objc func switchDidChange(_ sender: UISwitch) {

        if sender.isOn == true {
            MemoStore.data[sender.tag].isCompleted = true

        }else{
            MemoStore.data[sender.tag].isCompleted = false
        }

        // switch 변경 시 저장(update), encoded는 Data형
        if let encoded = try? self.encoder.encode(MemoStore.data) {
            self.defaults.set(encoded, forKey: "memo")
        }
        // 해당 스위치의 인덱스 값을 태그로 받아옴
        let index = IndexPath(row: sender.tag, section: 0)
        // 스위치 상태 변화 했으니 테이블 로우 reload
        tableView.reloadRows(at: [index], with: .automatic)

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
//                if MemoStore.data[first_index].isCompleted == false {}
            }
        }

    }


    // 스와이프 삭제 구현
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            MemoStore.data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            // 데이터 삭제 된 배열을 다시 저장
            if let encoded = try? self.encoder.encode(MemoStore.data) {
                self.defaults.set(encoded, forKey: "memo")
            }

//            defaults.removeObject(forKey: "memo")
            //  키를 여러개 만들어서

            tableView.reloadData()
        }
    }



}







