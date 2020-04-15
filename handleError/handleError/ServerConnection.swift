//
//  ServerConnection.swift
//  handleError
//
//  Created by Nguyễn Lâm on 4/14/20.
//  Copyright © 2020 Nguyễn Lâm. All rights reserved.
//

import Foundation
import UIKit

protocol ServerConnectionProtocol {
    func fetchAPIFromURL(_ url: String, complitionHandler: @escaping (String?, String?) -> Void) -> Void
}

class ServerConnection {
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    /// Fetch data from API
    var dataTask: URLSessionDataTask?
    /// Download resources from API (image, pdf, music)
    var downloadTask: URLSessionDownloadTask?
    /// Update image to server
    var uploadTask: URLSessionUploadTask?
    
}

extension ServerConnection: ServerConnectionProtocol{
    func fetchAPIFromURL(_ url: String, complitionHandler: @escaping (String?, String?) -> Void) {
        guard let url = URL(string: url) else {
            complitionHandler(nil, "URL incorrect")
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            if let error = error as? String {
                complitionHandler(nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                complitionHandler(nil, "Unknow Error")
                return
            }
            switch httpResponse.statusCode {
            case 200...299:
                guard let _data = data else {
                    return
                }
                let string = String(data: _data, encoding: .utf8)
                complitionHandler(string, nil)
            case 404:
                complitionHandler(nil, "Your request was not found")
            case 500:
                complitionHandler(nil, "Internal error")
            case 503:
                complitionHandler(nil, "You don't have permission to view this page")
            default: complitionHandler(nil, nil)
            }
        }

        dataTask?.resume()
    }
    
    
}
