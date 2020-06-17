//
//  ApiCall.swift
//  DirectAssistLib
//
//  Created by Gustavo Graña on 25/06/17.
//  Copyright © 2017 DirectAssist. All rights reserved.
//

import Foundation

public class ApiCall {

    public init() {}

    public func doCall() {
        request(URLPaths.Assist24h.createCase).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result

            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }

            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }

}
