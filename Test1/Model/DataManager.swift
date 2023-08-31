//
//  DataManager.swift
//  Test1
//
//  Created by t2023-m0067 on 2023/08/31.
//

import Foundation

class DataManager {
    // UserDefaults CRUD
    
    static let shared = DataManager()
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func readData(){
        if let savedData = defaults.object(forKey: "memo") as? Data {
            if let savedObject = try? decoder.decode([Memo].self, from: savedData) {
                MemoStore.data = savedObject
            }
        }
    }
    
    func saveData(){
        if let encoded = try? self.encoder.encode(MemoStore.data) {
            self.defaults.set(encoded, forKey: "memo")
        }
    }
    
    
    
    
}
