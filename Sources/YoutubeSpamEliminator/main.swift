//
//  main.swift
//  YoutubeSpamEliminator
//
//  Created by EnchantCode on 2021/04/05.
//  Copyright © 2021 EnchantCode. All rights reserved.
//

import Foundation

let arguments = CommandLine.arguments

DispatchQueue.global().async {
    let result = YoutubeSpamEliminator().main(arguments: arguments)
    exit(result)
}

dispatchMain()
