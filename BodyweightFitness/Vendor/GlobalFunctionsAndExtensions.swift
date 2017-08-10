//
//  GlobalFunctionsAndExtensions.swift
//  Pods
//
//  Created by JayT on 2016-06-26.
//
//

import UIKit

extension Calendar {
    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.isLenient = true
        return dateFormatter
    }()
    
    
    func startOfMonth(for date: Date) -> Date? {
        guard let comp = dateFormatterComponents(from: date) else { return nil }
        return Calendar.formatter.date(from: "\(comp.year) \(comp.month) 01")
    }
    
    func endOfMonth(for date: Date) -> Date? {
        guard
            let comp = dateFormatterComponents(from: date),
            let day = self.range(of: .day, in: .month, for: date)?.count,
            let retVal = Calendar.formatter.date(from: "\(comp.year) \(comp.month) \(day)") else {
                return nil
        }
        return retVal
    }
    
    private func dateFormatterComponents(from date: Date) -> (month: Int, year: Int)? {
        
        // Setup the dateformatter to this instance's settings
        Calendar.formatter.timeZone = self.timeZone
        Calendar.formatter.locale = self.locale
        Calendar.formatter.calendar = self
        
        let comp = self.dateComponents([.year, .month], from: date)
        
        guard
            let month = comp.month,
            let year = comp.year else {
                return nil
        }
        return (month, year)
    }
}

extension Dictionary where Value: Equatable {
    func key(for value: Value) -> Key? {
        guard let index = index(where: { $0.1 == value }) else {
            return nil
        }
        return self[index].0
    }
}
