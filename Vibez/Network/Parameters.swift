//
//  Parameters.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/6/20.
//

import Foundation

enum Parameters {
    case tokenRefreshCode(refreshToken: String)
    case durationOfTime(duration: String)
    case tokenCode(accessCode: String)
    
    func constructParameters() -> [String:Any] {
        switch self {
        case .tokenCode(let code):
            return ["grant_type": "authorization_code",
                    "redirect_uri": Key.REDIRECT_URI,
                    "code": "\(code)"]
        case .durationOfTime(let duration):
            return ["time_duration": duration]
            
        case .tokenRefreshCode(let refreshToken):
            return ["grant_type": "refresh_token",
                    "refresh_token": refreshToken
            ]
        }
    }
}
