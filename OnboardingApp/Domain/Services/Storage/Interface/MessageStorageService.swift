//
//  MessageStorageService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

protocol MessageStorageService {
    func saveMessages(_ messages: [MessageDTO])
    func getMessages(completionHandler: @escaping ([MessageDTO]) -> Void)
    func deleteMessages(completionHandler: @escaping (Result<Void, ErrorsDTO>) -> Void)
}
