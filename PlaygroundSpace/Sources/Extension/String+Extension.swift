//
//  String+Extension.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation

extension String {
    var formatPhoneNumber: String {
        
        print("before",self)
        var phoneNumber = self
        
        phoneNumber = phoneNumber.filter { $0.isNumber == true }
        
        if phoneNumber.count >= 12 {
            phoneNumber = String(phoneNumber.prefix(11))
        }
        
        var result = ""
        let mask: String
        
        if phoneNumber.count == 11 {
            mask = "XXX-XXXX-XXXX"
        } else {
            mask = "XXX-XXX-XXXX"
        }
        
        var index = phoneNumber.startIndex
        
        for change in mask where index < phoneNumber.endIndex {
            if change == "X" {
                result.append(phoneNumber[index])
                index = phoneNumber.index(after: index)
            } else {
                result.append(change)
            }
        }
        
        print(result)
        return result
    }
    
    var toDate: Date? {
        return DateManager.shared.toDateISO(self)
    }
}
