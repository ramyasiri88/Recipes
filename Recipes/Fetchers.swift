import Combine
import Foundation

let API_BASE = "https://themealdb.com/api.php"
let FETCH_RECIPES = "https://themealdb.com/api/json/v1/1/filter.php"
let FETCH_RECIPE_DETAIL = "https://themealdb.com/api/json/v1/1/lookup.php"

enum LoadableState<T> {
    case loading
    case fetched(Result<T, FetchError>)
}

enum FetchError: Error {
    case error(String)
    
    var localizedDescription: String {
        switch self {
        case .error(let message):
            return message
        }
    }
}

class ImageFetcher: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    var data: Data = Data() {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    init(url: String) {
        guard let imageUrl = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { (data, _, _) in
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                self?.data = data
            }
        }.resume()
    }
}

class RecipeListFetcher: ObservableObject {
    var searchQuery: String = "" {
        didSet {
            self.update();
        }
    }
    
    let objectWillChange = ObservableObjectPublisher()
    
    var state: LoadableState<Response> = .loading {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    func update() {
        state = .loading
        let apiUrlString =  FETCH_RECIPES
        guard let apiUrl = URL(string: apiUrlString + "?c=Dessert") else {
            state = .fetched(.failure(.error("Malformed API URL.")))
            return
        }

        URLSession.shared.dataTask(with: apiUrl) { [weak self] (data, resp, error) in
            if let error = error {
                self?.state = .fetched(.failure(.error(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                self?.state = .fetched(.failure(.error("Malformed response data")))
                return
            }
            
            let httpResponse = resp as! HTTPURLResponse
            if (httpResponse.statusCode != 200) {
                self?.state = .fetched(.failure(.error("Bad HTTP Response: \(httpResponse.statusCode)")))
                return
            }
            
            let response = try! JSONDecoder().decode(Response.self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                self?.state = .fetched(.success(response))
            }
        }.resume()
    }
    
    init() {
        update()
    }
}

class RecipeDetailFetcher: ObservableObject {
    
    private static let apiUrlString = FETCH_RECIPE_DETAIL
    let objectWillChange = ObservableObjectPublisher()
    
    var state: LoadableState<RecipeDetails> = .loading {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    func update(path: String) {
        state = .loading
        guard let apiUrl = URL(string: RecipeDetailFetcher.apiUrlString + "?i=" + path) else {
            state = .fetched(.failure(.error("Malformed API URL.")))
            return
        }

        URLSession.shared.dataTask(with: apiUrl) { [weak self] (data, resp, error) in
            if let error = error {
                self?.state = .fetched(.failure(.error(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                self?.state = .fetched(.failure(.error("Malformed response data")))
                return
            }
            
            let httpResponse = resp as! HTTPURLResponse
            if (httpResponse.statusCode != 200) {
                self?.state = .fetched(.failure(.error("Bad HTTP Response: \(httpResponse.statusCode)")))
                return
            }
            
            let response = try! JSONDecoder().decode(RecipeDetails.self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                self?.state = .fetched(.success(response))
            }
        }.resume()
    }
    
    init(path: String) {
        update(path: path)
    }
}
