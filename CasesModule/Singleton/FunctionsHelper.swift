//
//  FunctionsHelper.swift
//  DayOneTask
//
//  Created by PGK Shiva Kumar on 30/08/22.
//

import Foundation
import UIKit

class FunctionsHelper {
    
    static let sharedInstance : FunctionsHelper = FunctionsHelper()
    private init(){}
    
    func getTimeFormat(customTime incomingEnum : TimeFormat) -> String {
        
        var finalString = ""
        
        switch incomingEnum {
        
        case .forView:
            finalString = "yyyy-MM-dd"
        case .forLogic :
            finalString = "dd-MMM-yyyy"
        case .forView1:
            finalString = "dd-MMM-yy hh:mm"
        }
        return finalString
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String , timeFormat : TimeFormat) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = getTimeFormat(customTime: timeFormat)//"dd-MMM-yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    func getCurrentDate()-> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yy hh:mm"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
}

public enum TimeFormat {
    case forView
    case forLogic
    case forView1
}
