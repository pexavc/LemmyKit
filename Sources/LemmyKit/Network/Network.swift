import Foundation
import Combine

class Network {
    struct Configuration: Codable {
        var endpoint : String
    }
    
    enum NetworkError: LocalizedError {
        case invalidRequestUrl
        case invalidResponse
        case unauthorized
        case backend(ErrorResponse)
        
        var errorDescription: String? {
            switch self {
            
            case .invalidRequestUrl:
                return "Invalid request URL."
                
            case .invalidResponse:
                return "Invalid response data."
                
            case .unauthorized:
                return "Insufficient rights to perform the request."
                
            case .backend(let response):
                return response.message
            
            }
        }
    }
    
    var headers = [String : String]()
    var configuration : Configuration
    
    init(_ endpoint: String) {
        configuration = .init(endpoint: endpoint)
    }
        
    func request<R : Request>(_ request : R,
                              options : RequestOptions = .init(),
                              progress : Progress? = nil) -> AnyPublisher<R.TransformedResponse, Error> {
      
        return makeUrlComponents(for: request)
            .flatMap { self.makeURLRequest(from: request, components: $0) }
            .flatMap { self.executeURLRequest(request, urlRequest: $0, progress: progress) }
            .flatMap { self.decodeURLResponse(request, urlResult: $0) }
            .receive(on: DispatchQueue.global(qos: .utility))
            .tryCatch { try self.handleErrors(request, options: options, error: $0) }
            .eraseToAnyPublisher()
    }
    
}

extension Network {
    
    fileprivate func checkAuthenticationStatus<R : Request>(for request : R) -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

extension Network {
    
    fileprivate func makeUrlComponents<R : Request>(for request : R) -> AnyPublisher<URLComponents, Error> {
        let urlString = "\(request.ignoresEndpoint == false ? configuration.endpoint : "")\(request.path)"
        
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
              let url = URL(string: encodedString),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return Fail(error: NetworkError.invalidRequestUrl)
                .eraseToAnyPublisher()
        }
        
        if request.method == .get || request.method == .delete {
            var items: [URLQueryItem] = []
            
            var data = request.data
            
            if let paginationData = data["pagination"] as? [String : Any] {

                for (key, value) in paginationData {
                    data[key] = value
                }
                
                data["pagination"] = nil
            }
            
            for (name, value) in data {
                if let array = value as? [String] {
                    items.append(contentsOf: array.map({ value in
                        URLQueryItem(name: name + "[]", value: "\(value)")
                    }))
                } else if type(of: value) == type(of: NSNumber(value: true)), let boolean = value as? Bool {
                    items.append(URLQueryItem(name: name, value: boolean == true ? "true" : "false"))
                } else {
                    items.append(URLQueryItem(name: name, value: "\(value)"))
                }
            }
            
            for (name, value) in request.customQueries {
                items.append(.init(name: name, value: value))
            }

            components.queryItems = items
        }
    
        return Just(components)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

extension Network {
    
    fileprivate func makeURLRequest<R : Request>(from request : R, components : URLComponents) -> AnyPublisher<URLRequest, Error> {
        var urlRequest = URLRequest(
            url: components.url!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        if let mp = request.multipartData {
            
            let mpRequest = MultipartFormDataRequest()
            mpRequest.addDataField(fieldName:  mp.fieldName,
                                   fileName: mp.fileName,
                                   data: mp.fileData,
                                   mimeType: mp.mimeType)
            
            urlRequest.setValue(mpRequest.contentType,
                                forHTTPHeaderField: "Content-Type")
            
            switch request.method {
            case .post, .put:
                mpRequest.addBoundary()
                urlRequest.httpBody = mpRequest.httpBody as Data
            default:
                break
            }
        } else {
            urlRequest.addValue("application/json",
                                forHTTPHeaderField: "Content-Type")
            
            switch request.method {
            case .post, .put:
                if let jsonData = try? JSONSerialization.data(withJSONObject: request.data, options: .prettyPrinted) {
                    urlRequest.httpBody = jsonData
                }
            default:
                break
            }
        }
        
        for (name, value) in request.customHeaders {
            urlRequest.addValue(value, forHTTPHeaderField: name)
        }

        urlRequest.httpMethod = request.method.rawValue.uppercased()
       
        return Just(urlRequest)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

extension Network {
    
    typealias URLRequestExecutionResult = (data : Data, response : URLResponse)
    
    fileprivate func executeURLRequest<R : Request>(_ request : R,
                                        urlRequest : URLRequest,
                                        progress : Progress? = nil) -> AnyPublisher<URLRequestExecutionResult, Error> {
        Deferred {
            Future<URLRequestExecutionResult, Error> { fulfill in
                let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if let error = error {
                        fulfill(.failure(error))
                    } else if let data = data, let response = response {
                        let result = (data: data, response: response)
                        fulfill(.success(result))
                    }
                }
                
                progress?.addChild(task.progress, withPendingUnitCount: 100)
                
                print("[NetworkService] Sending request: \(R.self) w/ \(String(describing: urlRequest.url))")
                
                task.resume()
            }
        }.eraseToAnyPublisher()
    }
}

extension Network {
    
    fileprivate func decodeURLResponse<R : Request>(_ request : R,
                                        urlResult : URLRequestExecutionResult) -> AnyPublisher<R.TransformedResponse, Error> {
        do {
            if let response = urlResult.response as? HTTPURLResponse {
                var headers = [String : String]()
                
                for (name, value) in response.allHeaderFields {
                    guard let name = name as? String else {
                        continue
                    }
                    
                    headers[name] = value as? String
                }
                
                self.headers = headers
            }
            
            let decoder = JSONDecoder()
            decoder.dataDecodingStrategy = .base64
            decoder.keyDecodingStrategy = .useDefaultKeys
            decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+∞", negativeInfinity: "-∞", nan: "NaN")
            
            let intermediateResponse = Just(try decoder.decode(R.Response.self, from: urlResult.data))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
            return try request.transform(intermediateResponse)
        }
        catch let error {
            print("[NetworkService] Generic error: \(error)")
            
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}

extension Network {
    fileprivate func handleErrors<R : Request>(_ request : R, options : RequestOptions, error : Error) throws -> AnyPublisher<R.TransformedResponse, Error> {
        if options.shouldSupressErrors == false && options.useMockData == false {
            print("[NetworkService] Error: \(error.localizedDescription)")
        }
        
        print("[NetworkService] Unauthorized access to the endpoint.")
        
        throw error
    }
}
