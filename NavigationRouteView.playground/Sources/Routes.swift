//
//  Routes.swift
//  RouterExample
//
//  Created by Felipe Menezes on 02/05/23.
//

import Foundation

public enum Routes: Equatable {
    case user_list, user_create, user_info(User), user_edit(User)
    case error_screen(Error)
    case none
    
    public static func == (lhs: Routes, rhs: Routes) -> Bool {
        switch (lhs, rhs) {
        case (.user_list, .user_list),
            (.user_create, .user_create),
            (.user_info, .user_info),
            (.user_edit, .user_edit),
            (.none, .none):
            return true
            
        case let (.error_screen(error1), .error_screen(error2)):
            return error1.localizedDescription == error2.localizedDescription
            
        default:
            return false
        }
    }
}

