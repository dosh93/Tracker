//
//  Weekday.swift
//  Tracker
//
//  Created by Dosh on 31.03.2024.
//

import Foundation

enum Weekday: String, CaseIterable {
    
    case mon = "Понедельник"
    case tue = "Вторник"
    case wed = "Среда"
    case thu = "Четверг"
    case fri = "Пятница"
    case sat = "Суббота"
    case sun = "Воскресенье"
    
    var getDayNumber: Int {
        switch self {
        case .mon: return 2
        case .tue: return 3
        case .wed: return 4
        case .thu: return 5
        case .fri: return 6
        case .sat: return 7
        case .sun: return 1
        }
    }
    
    var getShortDayName: String {
        switch self {
        case .mon: return "Пн"
        case .tue: return "Вт"
        case .wed: return "Ср"
        case .thu: return "Чт"
        case .fri: return "Пт"
        case .sat: return "Сб"
        case .sun: return "Вс"
        }
    }
}
