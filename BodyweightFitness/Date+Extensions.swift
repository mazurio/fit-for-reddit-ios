import Foundation

func secondsToHoursMinutesSeconds(_ seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

extension Date {
    public var globalDescription: String {
        get {
            let month = dateFormattedStringWithFormat("MMMM", fromDate: self)
            let year = dateFormattedStringWithFormat("YYYY", fromDate: self)
            
            return "\(month) \(year)"
        }
    }
    
    public var commonDescription: String {
        get {
            let day = dateFormattedStringWithFormat("dd", fromDate: self)
            let month = dateFormattedStringWithFormat("MMMM", fromDate: self)
            let year = dateFormattedStringWithFormat("YYYY", fromDate: self)
            
            return "\(day) \(month) \(year)"
        }
    }

    public var description: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, d MMMM YYYY"

            return formatter.string(from: self)
        }
    }
    
    func dateFormattedStringWithFormat(_ format: String, fromDate date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }

    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])

        if components.year! >= 2 {
            return "\(components.year!) years ago"
        }

        if components.year! >= 1 {
            return "Last year"
        }

        if components.month! >= 2 {
            return "\(components.month!) months ago"
        }

        if components.month! >= 1 {
            return "Last month"
        }

        if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        }

        if components.weekOfYear! >= 1 {
            return "Last week"
        }

        if components.day! >= 2 {
            return "\(components.day!) days ago"
        }

        if components.day! >= 1 {
            return "Yesterday"
        }

        if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        }

        if components.hour! >= 1 {
            return "An hour ago"
        }

        if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        }

        if components.minute! >= 1 {
            return "A minute ago"
        }

        if components.second! >= 3 {
            return "\(components.second!) seconds ago"
        }

        return "Just now"
    }

    static func changeDaysBy(_ days : Int) -> Date {
        let startOfDay = Calendar.current.startOfDay(for: Date())

        var components = DateComponents()
        components.hour = 23
        components.minute = 59
        components.second = 59

        let currentDate = (Calendar.current as NSCalendar).date(
            byAdding: components,
            to: startOfDay,
            options: NSCalendar.Options(rawValue: 0))!

        var dateComponents = DateComponents()
        dateComponents.day = days
        return (Calendar.current as NSCalendar).date(
            byAdding: dateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
    }
}
