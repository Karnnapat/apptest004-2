//
//  Date + Extension.swift
//  LUMPSUM
//
//  Created by macbook-Art on 30/8/2564 BE.
//  Copyright © 2564 BE OnlineAsset. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
    
    func stripTime() -> Date {
           let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
           let date = Calendar.current.date(from: components)
           return date!
       }
    
    func currentWeek(firstWeekday:Int) -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = firstWeekday // Start on Monday (or 1 for Sunday)
        let today = calendar.startOfDay(for: self)
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        
        return week
    }
    
    func getNumberOfWeek(firstWeekday:Int) -> Int {
        var number = 0
        let formatter = DateFormatter()
        let eng = NSLocale(localeIdentifier: "en-GB")
        formatter.locale = eng as Locale
        
        formatter.dateFormat = "dd MM yyyy"
        
        let result = formatter.string(from: self)
        let arrShow = result.components(separatedBy: " ")
        
        let week_size = 5

        for n in 1...week_size {
            let dc = DateComponents(
                year: Int(arrShow[2]),
                month: Int(arrShow[1]),
                weekday: firstWeekday,
                weekOfMonth: n
            )
            
            var calendarTemp = Calendar(identifier: .gregorian)
            calendarTemp.firstWeekday = firstWeekday
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = eng as Locale
            let date = calendarTemp.date(from: dc)!

            if currentWeek(firstWeekday: firstWeekday).contains(date){
                number = n
            }
        }
        
        return number
    }
    
    func convertDateToString() -> String {
        let formatter = DateFormatter()
        let eng = NSLocale(localeIdentifier: "en-GB")
        formatter.locale = eng as Locale
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    
    func getTodayWeekDay(firstWeekday: Int)-> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEE"
           dateFormatter.calendar.firstWeekday  = firstWeekday
           let weekDay = dateFormatter.string(from: self)
           return weekDay.uppercased()
     }
    
    func convertDateToStringSlash() -> String {
        let formatter = DateFormatter()
        let eng = NSLocale(localeIdentifier: "en-GB")
        formatter.locale = eng as Locale
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        let eng = NSLocale(localeIdentifier: "en-GB")
        dateFormatter.locale = eng as Locale
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        let eng = NSLocale(localeIdentifier: "en-GB")
        dateFormatter.locale = eng as Locale
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let dateFormatter = DateFormatter()
        let eng = NSLocale(localeIdentifier: "en-GB")
        dateFormatter.locale = eng as Locale
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    
    var hour: String {
        let dateFormatter = DateFormatter()
        let eng = NSLocale(localeIdentifier: "en-GB")
        dateFormatter.locale = eng as Locale
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }
    
    var minute: String {
        let dateFormatter = DateFormatter()
        let eng = NSLocale(localeIdentifier: "en-GB")
        dateFormatter.locale = eng as Locale
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self)
    }
    
    var second: String {
        let dateFormatter = DateFormatter()
        let eng = NSLocale(localeIdentifier: "en-GB")
        dateFormatter.locale = eng as Locale
        dateFormatter.dateFormat = "ss"
        return dateFormatter.string(from: self)
    }
    
    var onlyDate: Date? {
           get {
               let calender = Calendar.current
               var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
               //dateComponents.timeZone = NSTimeZone.system
               let eng = NSLocale(localeIdentifier: "en-GB")
               dateComponents.calendar?.locale = eng as Locale
               return calender.date(from: dateComponents)
           }
       }
    
    
}


class DateConverter {
    static func convertUnixTimestampToDateString(timestamp: TimeInterval) -> String {
        // Create Date from Unix timestamp
        let date = Date(timeIntervalSince1970: timestamp)

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
    static func convertUnixTimestampToMonthString(timestamp: TimeInterval) -> String {
        // Create Date from Unix timestamp
        let date = Date(timeIntervalSince1970: timestamp)

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "MMMM yyyy"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
    static func convertUnixTimestampToYearString(timestamp: TimeInterval) -> String {
        // Create Date from Unix timestamp
        let date = Date(timeIntervalSince1970: timestamp)

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
    static func convertUnixTimestampToDayString(timestamp: TimeInterval) -> String {
        // Create Date from Unix timestamp
        let date = Date(timeIntervalSince1970: timestamp)

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd MM yyyy"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
    static func convertUnixTimestampToWeekString(timestamp: TimeInterval) -> String {
        // Create Date from Unix timestamp
        let date = Date(timeIntervalSince1970: timestamp)

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd MM yyyy"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
    static func convertStringtoYearDate(string: String) -> Date {

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.date(from: string)

        return dateString!
    }
    static func convertStringtoMonthDate(string: String) -> Date {

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "MMM yyyy"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.date(from: string)

        return dateString!
    }
    static func convertStringtoDayDate(string: String) -> Date {

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd MM yyyy"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.date(from: string)

        return dateString!
    }
    static func convertStringtoWeekDate(string: String) -> Date {

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd MM yyyy"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.date(from: string)

        return dateString!
    }
    static func convertDatetoMonthString(date: Date) -> String {

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "MMMM yyyy"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
    static func convertDatetoDayString(date: Date) -> String {

        // Set the desired date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd MM yyyy"

        // Convert Date to a string representation of the date
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
}
