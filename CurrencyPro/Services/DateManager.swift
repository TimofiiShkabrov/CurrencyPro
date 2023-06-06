//
//  DateManager.swift
//  CurrencyPro
//
//  Created by Тимофей Шкабров on 29.05.2023.
//

import Foundation

// Function for retrieving the current date using "dateFormatter".
func getDate() -> String {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "dd"
    let day = dateFormatter.string(from: Date())
    
    dateFormatter.dateFormat = "MM"
    let month = dateFormatter.string(from: Date())
    
    dateFormatter.dateFormat = "yyyy"
    let year = dateFormatter.string(from: Date())
    
    let dateString = combineDateToString(day: day, month: month, year: year)
    return dateString
}

// The "combineDateToString" function generates a valid "String" to add to the "URL" in the "NetworkManager".
func combineDateToString(day: String, month: String, year: String) -> String {
    let dateString = "\(day).\(month).\(year)"
    return dateString
}
