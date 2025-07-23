//
//  NetworkManager.swift
//  Thapala
//
//  Created by ahex on 24/04/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

enum NetworkError: Error {
    case error(error: String)
    case sessionExpired(error: String)
}

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    private override init() {}
    private let baseURL = "http://128.199.21.237:8080/api/v1/"
    
    func request<T : Decodable>(type : T.Type, endPoint: String, httpMethod: HTTPMethod = .get, parameters: Encodable? = nil, isTokenRequired: Bool = true,passwordHash:String? = nil, pin:String? = nil, isSessionIdRequited: Bool = false, completion completionHandler: @escaping(Result<T, NetworkError>) -> Void){
        guard let url = URL(string: "\(baseURL)\(endPoint)") else {
            completionHandler(.failure(.error(error: "Invalid URL")))
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
//        if isSessionIdRequited {
//            let sessionManager = SessionManager()
//            request.setValue(sessionManager.sessionId, forHTTPHeaderField: "sessionId")
//        }
        if isSessionIdRequited {
            request.setValue(UserDataManager.shared.sessionId, forHTTPHeaderField: "sessionId")
        }
        if isTokenRequired {
            let sessionManager = SessionManager()
        //    request.setValue(sessionManager.token, forHTTPHeaderField: "token")
            request.setValue("Bearer \(sessionManager.token)", forHTTPHeaderField: "Authorization")
            print("sessionManager.token",sessionManager.token)
        }
        if passwordHash != nil{
            request.setValue(passwordHash, forHTTPHeaderField: "password")
        }
        if pin != nil{
            request.setValue(pin, forHTTPHeaderField: "pin")
        }
        
        if parameters != nil {
            if let params = parameters {
                guard let httpBody = try? JSONEncoder().encode(params) else {
                    completionHandler(.failure(.error(error: "Invalid parameters")))
                    return
                }
                request.httpBody = httpBody
            }
        }
        print("parameters",parameters)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        let session = URLSession(configuration: configuration)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print(error)
                switch error._code {
                case -1009:
                    DispatchQueue.main.async {
                        completionHandler(.failure(.error(error: "The Internet connection appears to be offline.")))
                    }
                    return
                case -1001:
                    DispatchQueue.main.async {
                        completionHandler(.failure(.error(error: "Time out connection server issue, please try again")))
                    }
                    return
                default:break
                }
                DispatchQueue.main.async {
                    completionHandler(.failure(.error(error: "Unable to complete, please try again later")))
                }
                return
            }
            guard let httpData = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.error(error: "Invalid Data, Please try again later")))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 500 {
                DispatchQueue.main.async {
                    completionHandler(.failure(.sessionExpired(error: "Session Expired, Please login again.")))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
                DispatchQueue.main.async {
                    completionHandler(.failure(.sessionExpired(error: "Session Expired, Please login again.")))
                }
                return
            }
            do
            {
                let jsonData = try JSONSerialization.jsonObject(with: httpData)
                print(jsonData)
                let json = try JSONDecoder().decode(T.self, from: httpData)
                DispatchQueue.main.async {
                    completionHandler(.success(json))
                }
            }catch{
                print(error)
                DispatchQueue.main.async {
                    completionHandler(.failure(.error(error: "Please try again later")))
                }
            }
        }.resume()
    }
    
    func getSessionId(endPoint: String, httpMethod: HTTPMethod = .get, parameters: Encodable? = nil,isFromForgot:Bool = false, completion completionHandler: @escaping(Result<CreateAccountModel, NetworkError>) -> Void){
        guard let url = URL(string: "\(baseURL)\(endPoint)") else {
            completionHandler(.failure(.error(error: "Invalid URL")))
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        if parameters != nil {
            if let params = parameters {
                guard let httpBody = try? JSONEncoder().encode(params) else {
                    completionHandler(.failure(.error(error: "Invalid parameters")))
                    return
                }
                request.httpBody = httpBody
            }
        }
        print(parameters)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        let session = URLSession(configuration: configuration)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print(error)
                switch error._code {
                case -1009:
                    DispatchQueue.main.async {
                        completionHandler(.failure(.error(error: "The Internet connection appears to be offline.")))
                    }
                    return
                case -1001:
                    DispatchQueue.main.async {
                        completionHandler(.failure(.error(error: "Time out, please try again")))
                    }
                    return
                default:break
                }
                DispatchQueue.main.async {
                    completionHandler(.failure(.error(error: "Unable to complete, please try again later")))
                }
                return
            }
            guard let httpData = data else{
                DispatchQueue.main.async {
                    completionHandler(.failure(.error(error: "Invalid Data, Please try again later")))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 500 {
                DispatchQueue.main.async {
                    completionHandler(.failure(.sessionExpired(error: "Session Expired, Please login again.")))
                }
                return
            }
            do
            {
                if isFromForgot{
                    let jsonData = try JSONSerialization.jsonObject(with: httpData)
                    print(jsonData)
                    let json = try JSONDecoder().decode(ResetpasswordModel.self, from: httpData)
                    let headers = (response as? HTTPURLResponse)?.allHeaderFields
                    let sessionId = headers?["sessionId"] as? String
                    print("sessionId Forgot==>",sessionId)
                    DispatchQueue.main.async {
                        completionHandler(.success(CreateAccountModel(message: json.resetToken ?? "", status: json.status, sessionId: sessionId ?? "")))
                    }
                    return
                }
                let jsonData = try JSONSerialization.jsonObject(with: httpData)
                print(jsonData)
                let json = try JSONDecoder().decode(CreateAccountModel.self, from: httpData)
                let headers = (response as? HTTPURLResponse)?.allHeaderFields
                let sessionId = headers?["sessionId"] as? String
                print("sessionId==>",sessionId)
                DispatchQueue.main.async {
                    completionHandler(.success(CreateAccountModel(message: json.message ?? "", status: json.status, sessionId: sessionId ?? "")))
                }
            }catch{
                print(error)
                DispatchQueue.main.async {
                    completionHandler(.failure(.error(error: "Decoding error")))
                }
            }
        }.resume()
    }

    func requestToken<T: Decodable>(type: T.Type, endPoint: String, httpMethod: HTTPMethod = .get, parameters: Encodable? = nil, isTokenRequired: Bool, completion: @escaping(Result<T, NetworkError>) -> Void) {
        
           var request = URLRequest(url: URL(string: "\(baseURL)\(endPoint)")!)
           request.httpMethod = httpMethod.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           if let params = parameters {
               guard let httpBody = try? JSONEncoder().encode(params) else {
                   DispatchQueue.main.async {
                       completion(.failure(.error(error: "Invalid parameters")))
                   }
                   return
               }
               request.httpBody = httpBody
           }
        
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               if let error = error {
                   completion(.failure(.error(error: error.localizedDescription)))
                   return
               }

               guard let httpResponse = response as? HTTPURLResponse else {
                   completion(.failure(.error(error: "Invalid response")))
                   return
               }

               guard (200...299).contains(httpResponse.statusCode) else {
                   completion(.failure(.error(error: "Server error with status code: \(httpResponse.statusCode)")))
                   return
               }

               if let data = data {
                   do {
                       let decodedResponse = try JSONSerialization.jsonObject(with: data)
                       print(decodedResponse)
                       let json = try JSONDecoder().decode(LoginModel.self, from: data)
                       let headers = (httpResponse).allHeaderFields
                       if let token = headers["token"] {
                           print("token header",token)
                       }
                       completion(.success(LoginResponse(model: json as? LoginModel, token: headers["token"] as? String) as! T))
                       
                   } catch {
                       completion(.failure(.error(error: "Failed to decode response")))
                   }
               } else {
                   completion(.failure(.error(error: "No data received")))
               }
           }
           task.resume()
       }
}
