//
//  Memo.swift
//  Test1
//
//  Created by t2023-m0067 on 2023/08/31.
//

import Foundation

// 등록 데이터
struct Memo: Codable {
    var title: String?
    var isCompleted: Bool = false
}
// 클래스 생성, static변수 선언해서 데이터 받아오기, 싱글톤패턴
class MemoStore {
    static var data: Array<Memo> = []
}
