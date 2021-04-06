//
//  YoutubeSpamEliminator.swift
//
//
//  Created by EnchantCode on 2021/04/05.
//

import YoutubeKit
import Foundation

final class YoutubeSpamEliminator {
    
    let sema = DispatchSemaphore(value: 0)
    let fileManager = FileManager.default
    let youtube = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)
    
    final func main(arguments: [String]) -> Int32 {
        
        // コンフィグ読み込み
        let configDir = (0..<arguments.count).contains(1) ? arguments[1] : "."
        let configName = "Targets.json"
        let configPath = "\(configDir)/\(configName)"
        guard let configData = fileManager.contents(atPath: configPath),
              let targets = Targets.deserialize(object: String(data: configData, encoding: .utf8)!) else {return EXIT_FAILURE}
        
        let channels = targets.channels
        
        // 各チャンネルについて
        channels.forEach { (channel) in
            
            // 投稿日時順に10本検索し
            let targetID = channel.id
            var movies: [SearchResource] = []
            youtube.search(maxResults: 10, channelId: targetID, option: ["type": "video", "order": "date"]) { (result) in
                movies = result.items
                self.sema.signal()
            } failure: { (error) in
                print(error)
                self.sema.signal()
            }
            sema.wait()
            
            // それぞれのコメントスレッドを上から50件取得
            movies.forEach { (movie) in
                guard let targetID = movie.getID() else {return}
                print(movie.snippet.title)
                
                //
                let commentThreadSema = DispatchSemaphore(value: 0)
                var threads: [CommentThreadResource] = []
                self.youtube.getCommentThread(videoId: targetID, maxResults: 100, order: .relevance, textFormat: .plainText) { (result) in
                    threads = result.items
                    commentThreadSema.signal()
                } failure: { (error) in
                    print(error)
                    commentThreadSema.signal()
                }
                commentThreadSema.wait()
                
                // 整形して表示
                threads.forEach { (thread) in
                    let textOriginal = thread.snippet!.topLevelComment!.snippet!.textOriginal!
                    let textContent: String = textOriginal.replacingOccurrences(of: "\n", with: "\\n")
                    let likeCount = thread.snippet!.topLevelComment!.snippet!.likeCount!
                    
                    print("  \(textContent) (\(likeCount) likes)")
                    
                    // さらに返信も取得
                    let commentReplySema = DispatchSemaphore(value: 0)
                    var replies: [CommentResource] = []
                    self.youtube.getComment(parentID: thread.id, maxResults: 100, textFormat: .plainText) { (result) in
                        replies = result.items
                        commentReplySema.signal()
                    } failure: { (error) in
                        print(error)
                        commentReplySema.signal()
                    }
                    commentReplySema.wait()
                    
                    replies.forEach { (reply) in
                        let textOriginal = reply.snippet!.textOriginal!
                        let textContent: String = textOriginal.replacingOccurrences(of: "\n", with: "\\n")
                        let likeCount = reply.snippet!.likeCount!
                        
                        print("    \(textContent) (\(likeCount) likes)")
                    }
                }
            }
            
        }
        return EXIT_SUCCESS
    }
    
}
