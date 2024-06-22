//
//  ImageStorageService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/01.
//

protocol ImageStorageService {
    func saveImages(_ images: [ImageDTO])
    func getImages(completionHandler: @escaping ([ImageDTO]) -> Void)
    func deleteAllImages(completionHandler: @escaping (Result<Void, ErrorsDTO>) -> Void)
}
