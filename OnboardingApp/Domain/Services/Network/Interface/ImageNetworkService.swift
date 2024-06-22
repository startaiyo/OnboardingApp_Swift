//
//  ImageNetworkService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/20.
//

protocol ImageNetworkService {
    func getImages(_ input: ImageInput,
                   completionHandler: @escaping (Result<[ImageInfoDTO], ErrorsDTO>) -> Void) 
}
