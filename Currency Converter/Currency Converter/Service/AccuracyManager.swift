//
//  AccuracyManager.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/24/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

class AccuracyManager {
    static let shared = AccuracyManager()
    private let defaultAccuracy: Accuracy
    
    var accurancy: Int {
        get {
            guard let accuracyData = UserDefaults.standard.value(forKey: "accuracy") as? Data,
                let accuracy = Accuracy.decode(data: accuracyData) else {
                    return defaultAccuracy.rawValue
            }
            return accuracy.rawValue
        }
        
        set {
            guard let newAccurancy = Accuracy(rawValue: newValue) else {
                self.accurancy = defaultAccuracy.rawValue
                return
            }
            let accurancyData = Accuracy.encode(value: newAccurancy)
            UserDefaults.standard.set(accurancyData, forKey: "accuracy")
        }
    }
    
    private init() {
        defaultAccuracy = .defaultAccurancy
    }
    
    func formatNumber(_ number: Double) -> Double {
        let accuracy = Double(accurancy)
        return round(number * pow(10, accuracy)) / pow(10, accuracy)
    }
}
