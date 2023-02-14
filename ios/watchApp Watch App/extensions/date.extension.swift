//
//  date.extension.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 13/02/2023.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func isBefore(_ otherDate:Date) -> Bool{
        return self < otherDate;
    }
    
    func isAfter(_ otherDate:Date) -> Bool{
        return self > otherDate;
    }
}
