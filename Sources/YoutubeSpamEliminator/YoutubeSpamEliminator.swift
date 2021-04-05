//
//  YoutubeSpamEliminator.swift
//  
//
//  Created by EnchantCode on 2021/04/05.
//

import YoutubeKit
import Foundation

final class YoutubeSpamEliminator {
    
    let fileManager = FileManager.default
    let youtube = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)
    
    final func main(arguments: [String]) -> Int32 {
        
        // コンフィグ読み込み
        let configDir = (0..<arguments.count).contains(1) ? arguments[1] : "."
        let configName = "Targets.json"
        let configPath = "\(configDir)/\(configName)"
        guard let configData = fileManager.contents(atPath: configPath),
              let targets = Targets.deserialize(object: String(data: configData, encoding: .utf8)!) else {return EXIT_FAILURE}
        
        // 各ターゲットについて
        let channels = targets.channels

        
        return EXIT_SUCCESS
    }
    
}
