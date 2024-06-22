//
//  MessageAppService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

protocol MessageAppService {
    func saveMessage(_ message: MessageModel,
                     completionHandler: @escaping () -> Void)
    func getMessages(cacheCompletionHandler: @escaping ([MessageModel]?) -> Void,
                     completionHandler: @escaping (Result<[MessageModel], ErrorsModel>) -> Void)
}
