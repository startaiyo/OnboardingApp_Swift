//
//  DefaultImageNetworkService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/20.
//

import Foundation

final class DefaultImageNetworkService {
    let apiClient = ApiClient()
}

// MARK: - RestaurantNetworkService
extension DefaultImageNetworkService: ImageNetworkService {
    // MARK: Images
    func getImages(_ input: ImageInput,
                   completionHandler: @escaping (Result<[ImageInfoDTO], ErrorsDTO>) -> Void) {
        apiClient.call(request: ImageRequest(input: input)) { result in
            switch result {
                case .success(let data):
                    do {
                        let decodedData = try JSONDecoder().decode(ServerResponseDTOForImage.self,
                                                                   from: data)
                        completionHandler(.success(decodedData.results))
                    } catch {
                        print("Failed to decode to ImageDTO")
                        completionHandler(.failure(.init(type: .general)))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
