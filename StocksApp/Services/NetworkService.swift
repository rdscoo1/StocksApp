import Foundation

class NetworkService {

    func requestQuote(for symbol: String, completion: @escaping (Result<Stock, RequestError>) -> Void) {
        let path = "\(symbol)/quote"

        makeRequest(Stock.self, path: path) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let stock):
                completion(.success(stock))
            }
        }
    }

    func requestLogoUrl(for stock: String, completion: @escaping (Result<String, RequestError>) -> Void) {
        let path = "\(stock)/logo"

        makeRequest(Logo.self, path: path) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let image):
                completion(.success(image.url))
            }
        }
    }

    func requestCompaniesList(completion: @escaping (Result<[Stock], RequestError>) -> Void) {
        let path = "market/list/mostactive"

        makeRequest([Stock].self, path: path) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let stocks):
                completion(.success(stocks))
            }
        }
    }

    func requestNewsFor(symbol: String, quantity: Int = 20, completion: @escaping (Result<[News], RequestError>) -> Void) {
        let path = "\(symbol)/news/last/\(quantity)"

        makeRequest([News].self, path: path) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let news):
                completion(.success(news))
            }
        }
    }

    func requestCompanyInfo(symbol: String, completion: @escaping (Result<Company, RequestError>) -> Void) {
        let path = "\(symbol)/company"

        makeRequest(Company.self, path: path) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let company):
                completion(.success(company))
            }
        }
    }

    // MARK: - Private method

    private func makeRequest<T: Decodable>(_ model: T.Type,
                                           path: String,
                                           completion: @escaping (Result<T, RequestError>) -> Void) {
        let request = buildRequest(path: path)

        let configuration = createConfiguration()
        let session = URLSession(configuration: configuration)

        print(request)

        session.dataTask(with: request) { (data, response, error) in
//                        print("↩️ ↩️ ↩️ Data request: \(String(describing: String(data: data ?? Data(), encoding: .utf8)))")
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.client))
                }
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.server))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let item = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(item))
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    completion(.failure(.unableToDecode))
                }
            }
        }.resume()
    }

    private func createConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Content-type": "application/json",
            "Accept-Charset": "utf-8"
        ]

        return configuration
    }

    private func buildRequest(path: String) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.baseUrl
        components.path = "/stable/stock/\(path)"

        components.queryItems = [URLQueryItem(name: "token", value: Constants.token)]

        var request = URLRequest(url: components.url!, timeoutInterval: 10.0)

        request.httpMethod = "GET"
        return request
    }

}
