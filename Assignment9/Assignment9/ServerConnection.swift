

import Foundation
import UIKit


protocol ServerConnectionProtocol {
    func fetchAPIFromURL(_ url: String, complitionHandler: @escaping (String?, String?) -> Void) -> Void
    func downloadImageFromURL(_ url: URL, complitionHandler: @escaping (UIImage?, String?) -> Void) -> Void
}

class ServerConnection {
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    /// Fetch data from API
    var dataTask: URLSessionDataTask?
    /// Download resources from API (image, pdf, music)
    var downloadTask: URLSessionDownloadTask?
    /// Update image to server
    var uploadTask: URLSessionUploadTask?
    
    private let endPoint = "https://vapor-mock.herokuapp.com"
}

extension ServerConnection: ServerConnectionProtocol {
    func downloadImageFromURL(_ url: URL, complitionHandler: @escaping (UIImage?, String?) -> Void) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        downloadTask = defaultSession.downloadTask(with: request, completionHandler: {(localURL, response, error) in
            if let imageURL = localURL {
                do {
                    let imageData = try Data(contentsOf: imageURL)
                    if let image = UIImage(data: imageData){
                        complitionHandler(image, nil)
                    } else {
                        complitionHandler(nil, "Error")
                    }
                    
                }catch let error {
                    complitionHandler(nil, error.localizedDescription)
                }
            } else {
                complitionHandler(nil, "Error")
            }
        })
        
        downloadTask?.resume()
    }
    
    func fetchAPIFromURL(_ url: String, complitionHandler: @escaping (String?, String?) -> Void) {
        
        guard let url = URL(string: "\(endPoint)\(url)") else {
            complitionHandler(nil, "URL incorrect")
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) {data, response, error in
            //handle error
            if let error = error as? String {
                complitionHandler(nil, error)
                return
            }
            //handle status code
            guard let httpResponse =  response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    complitionHandler(nil, "HTTP status failed")
                    return
            }
            
            guard let _data = data else {
                return
            }
            
            let string = String(data: _data, encoding: .utf8)
            complitionHandler(string,nil)
        }
        dataTask?.resume()
    }
    
//    func downloadImageFromURL(_ url: URL, complitionHandler: @escaping (UIImage?, String?) -> Void) {
//        
//    }
    
    
}
