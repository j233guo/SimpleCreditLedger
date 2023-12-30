//
//  CompareDates.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-29.
//

import Foundation

/// Checks if two dates are equal considering only day, month, and year components.
/// - Parameters:
///   - date1: The first date to compare.
///   - date2: The second date to compare.
/// - Returns: Boolean value indicating if the dates are equal.
func isDate(_ date1: Date, equalTo date2: Date) -> Bool {
    let calendar = Calendar.current
    let components1 = calendar.dateComponents([.day, .month, .year], from: date1)
    let components2 = calendar.dateComponents([.day, .month, .year], from: date2)
    return components1.day == components2.day &&
           components1.month == components2.month &&
           components1.year == components2.year
}

/// Determines if one date is strictly greater than another, comparing day, month, and year components.
/// - Parameters:
///   - date1: The first date to compare.
///   - date2: The second date to compare.
/// - Returns: Boolean value indicating if `date1` is later than `date2`.
func isDate(_ date1: Date, greaterThan date2: Date) -> Bool {
    let calendar = Calendar.current
    let components1 = calendar.dateComponents([.day, .month, .year], from: date1)
    let components2 = calendar.dateComponents([.day, .month, .year], from: date2)
    if components1.year! > components2.year! {
        return true
    } else if components1.year == components2.year {
        if components1.month! > components2.month! {
            return true
        } else if components1.month == components2.month {
            if components1.day! > components2.day! {
                return true
            }
        }
    }
    return false
}

/// Determines if one date is strictly less than another, comparing only day, month, and year components.
/// - Parameters:
///   - date1: The first date to compare.
///   - date2: The second date to compare.
/// - Returns: Boolean value indicating if `date1` is earlier than `date2`.
func isDate(_ date1: Date, lessThan date2: Date) -> Bool {
    let calendar = Calendar.current
    let components1 = calendar.dateComponents([.day, .month, .year], from: date1)
    let components2 = calendar.dateComponents([.day, .month, .year], from: date2)
    if components1.year! < components2.year! {
        return true
    } else if components1.year == components2.year {
        if components1.month! < components2.month! {
            return true
        } else if components1.month == components2.month {
            if components1.day! < components2.day! {
                return true
            }
        }
    }
    return false
}

/// Checks if one date is greater than or equal to another date, considering day, month, and year.
/// - Parameters:
///   - date1: The first date to compare.
///   - date2: The second date to compare.
/// - Returns: Boolean value indicating if `date1` is the same or later than `date2`.
func isDate(_ date1: Date, greaterThanOrEqualTo date2: Date) -> Bool {
    return isDate(date1, equalTo: date2) || isDate(date1, greaterThan: date2)
}

/// Checks if one date is less than or equal to another date, considering day, month, and year.
/// - Parameters:
///   - date1: The first date to compare.
///   - date2: The second date to compare.
/// - Returns: Boolean value indicating if `date1` is the same or earlier than `date2`.
func isDate(_ date1: Date, lessThanOrEqualTo date2: Date) -> Bool {
    return isDate(date1, lessThan: date2) || isDate(date1, equalTo: date2)
}
