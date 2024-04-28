//
//  Convertor.swift
//  Tracker
//
//  Created by Dosh on 09.04.2024.
//

import Foundation
import UIKit

final class Convertor {
    
    func scheduleFromCoreData(schedule: String?) -> [Weekday] {
        guard let sheduleStr = schedule else { return [] }
        let scheduleList = sheduleStr.components(separatedBy: ",")
        var weekdays: [Weekday] = []

        for item in scheduleList {
            guard let weekday = Weekday(rawValue: item.trimmingCharacters(in: .whitespaces)) else {
                print("scheduleFromCoreData error")
                return [Weekday.mon]
            }
            weekdays.append(weekday)
        }
        
        return weekdays
    }
    
    func scheduleToCoreData(schedule: [Weekday]) -> String {
        return schedule.map { $0.rawValue }.joined(separator: ",")
    }
    
    func colorFromCoreData(color: String) throws -> UIColor {
        guard let uiColor = UIColor(named: color) else {
            throw ConvertorError.convertColorFromCoreDataError
        }
        return uiColor
    }
}
