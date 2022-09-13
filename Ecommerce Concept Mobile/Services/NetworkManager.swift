//
//  NetworkManager.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 25.08.2022.
//

import Foundation

// Api экранов
enum Urls: String {
    case homeStoreAPI = "https://run.mocky.io/v3/654bd15e-b121-49ba-a588-960956b15175"
    case specificationsAPI = "https://run.mocky.io/v3/6c14c560-15c6-4248-b9d2-b4508df7d4f5"
    case basketAPI = "https://run.mocky.io/v3/53539a72-3c5f-4f30-bbb1-6ca10d42c149"
}

struct NetworkManager {

    static let shared = NetworkManager()
    private init() {}

    
    // MARK: -
    
    typealias RailCompletionClosure = ((HomeStore?, Error?) -> Void)
    typealias SpecificationsCompletionClosure = ((Specifications?, Error?) -> Void)
    
    // Получаем данные из homeStoreAPI
    public func fetchHomeStoreData(completion: RailCompletionClosure?) {
        guard let request = createRequest(for: Urls.homeStoreAPI.rawValue) else {
            completion?(nil, NetworkError.invalidUrl)
            return
        }
        executeRequest(request: request, completion: completion)
    }
    
    // Получаем данные из homeStoreAPI
    public func fetchPhonesSpecifications(completion: SpecificationsCompletionClosure?) {
        guard let request = createRequest(for: Urls.specificationsAPI.rawValue) else {
            completion?(nil, NetworkError.invalidUrl)
            return
        }
        executeRequest(request: request, completion: completion)
    }
    
    // MARK: -
    
    // Создаем настраиваем URLRequest из строки URL
    private func createRequest(for url: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    // Выполняем сетевой запрос, используя URLRequest через URLSession
    private func executeRequest<T: Codable>(request: URLRequest, completion: ((T?, Error?) -> Void)?) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(nil, error)
                return
            }
            // Преобразовываем данные согласно поступившей модели данных
            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion?(decodedResponse, nil)
                }
            } else {
                completion?(nil, NetworkError.invalidData)
            }
        }
        dataTask.resume()
    }
    
}
    
// MARK: - Обработка ошибок интернет запросов
enum NetworkError: Error {
    case invalidUrl
    case invalidData
}
    
    
