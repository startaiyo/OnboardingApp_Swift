//
//  ImageAppService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/22.
//

protocol ImageAppService {
    func getImages(_ input: ImageInput,
                   cacheCompletionHandler: @escaping ([ImageModel]) -> Void,
                   completionHandler: @escaping (Result<[ImageModel], ErrorsModel>) -> Void)
    func saveImage(_ image: ImageModel)
    func getAllImages(completionHandler: @escaping (Result<[ImageModel], ErrorsModel>) -> Void)
}
