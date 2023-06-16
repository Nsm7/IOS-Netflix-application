//
//  APICaller.swift
//  netflixclone
//
//

import Foundation

struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseUrl = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyAlLC-yDLsyCYMFhmKDhXe_pfAzlTmCEoE"
    static let YoutubeBaseUrl = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error{
    case failedTOGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedTOGetData))
            }
            
        }
        
        task.resume()
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            
            catch{
                completion(.failure(APIError.failedTOGetData))
            }

        }
        task.resume()
        
    }
    
    func getUpcommingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedTOGetData))
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedTOGetData))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {data , _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedTOGetData))
            }
        }
        task.resume()
    }
    
    
    func getDiscoverMovies(completion: @escaping(Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {data , _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedTOGetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping(Result<[Title], Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
     
        guard let url = URL(string: "\(Constants.baseUrl)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {data , _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedTOGetData))
            }
        }
        task.resume()
    }
    
    
    func getMovie(with query: String, completion: @escaping(Result<VideoElement, Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.YoutubeBaseUrl)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {data , _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)

                completion(.success(results.items[0]))
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
        
    }
    
}
