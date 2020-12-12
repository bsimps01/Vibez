//
//  Parameters.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/6/20.
//

import Foundation

enum Parameters {
    case tokenRefreshCode(refreshToken: String)
    case durationOfTime(range: String)
    case tokenCode(accessCode: String)
    
    func buildParameters() -> [String:Any] {
        switch self {
        case .tokenCode(let code):
            return ["grant_type": "authorization_code",
                    "code": "\(code)",
                    "redirect_uri": Key.REDIRECT_URI]
        case .durationOfTime(let range):
            return ["time_range": range]
            
        case .tokenRefreshCode(let refreshToken):
            return ["grant_type": "refresh_token",
                    "refresh_token": refreshToken]
        }
    }
}
