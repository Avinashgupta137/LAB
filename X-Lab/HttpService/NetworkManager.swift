//
//  NetworkManager.swift
//  X-Lab
//
//  Created by IPS-161 on 20/02/24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl(String)
    case serverError(Error)
    case dataDecodingError(Error)
}

public final class NetworkManager {
    func fetchData<T:Decodable>(urlString:String?,model:T.Type,completion:@escaping(Result<T?,NetworkError>)->()){
        guard let urlString = urlString else {
            completion(.failure(NetworkError.invalidUrl("Invalid Url.")))
            return
        }
        
        let headers = [
            "X-RapidAPI-Key": "021108c3cdmshf759245e646191bp1ef32ejsn38795d85e69c",
            "X-RapidAPI-Host": "movies-api14.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let urlSession = URLSession.shared
        urlSession.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.serverError(error)))
            }
            
            if let httpResponse = response as? HTTPURLResponse,(200...400).contains(httpResponse.statusCode){
                print(httpResponse)
            }
            
            if let data = data {
                do{
                    let jsonDecoder = JSONDecoder()
                    let decodedData = try jsonDecoder.decode(model, from: data)
                    completion(.success(decodedData))
                }catch let error {
                    completion(.failure(NetworkError.dataDecodingError(error)))
                }
            }
            
        }.resume()
    }
}
