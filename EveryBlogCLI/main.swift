//
//  main.swift
//  EveryBlogCLI
//
//  Created by 朱浩宇 on 2021/4/17.
//

import Foundation
import ArgumentParser
import Yaml

let config = """
# EveryBlog CLI
# Version: 1.0
# Made By ZHY

website:
    title: ''
    theme: ''
"""

struct EveryBlogCLI: ParsableCommand {
    @Argument(help: "Input command") var phrase: String
    @Option(name: .shortAndLong, help: "Specify a local location.") var at: String?
    var isOK:Bool = true
    
    mutating func validate() throws {
        switch phrase {
        case "new":
            if at == nil {
                self.isOK = false
                throw ValidationError("Unable to get the installation location")
            }
        case "build":
            if at == nil {
                self.isOK = false
                throw ValidationError("Unable to get the installation location")
            }
        default:
            self.isOK = false
            throw ValidationError("Unknown instruction.")
        }
    }
    
    func run() {
        guard isOK else {
            return
        }
        
        let fileManager = FileManager.default
        
        switch phrase {
        case "new":
            let url = URL(string: at!)!
            do {
                fileManager.createFile(atPath: url.appendingPathComponent("config.yml").path, contents: config.data(using: .utf8), attributes: nil)
                try fileManager.createDirectory(at: url.appendingPathComponent("post"), withIntermediateDirectories: true, attributes: nil)
                try fileManager.createDirectory(at: url.appendingPathComponent("resources"), withIntermediateDirectories: true, attributes: nil)
                try fileManager.createDirectory(at: url.appendingPathComponent("themes"), withIntermediateDirectories: true, attributes: nil)
                try fileManager.createDirectory(at: url.appendingPathComponent("pages"), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
            print("Carry out !")
        case "build":
            let url = URL(string: at!)!
            do {
                let data = try NSData(contentsOfFile: url.appendingPathComponent("config.yml").path) as Data
                guard let yamlString = String(data: data, encoding: .utf8) else {
                    print("Load Config Error")
                    return
                }
                let yaml = try Yaml.load(yamlString)
                let website = yaml["website"]
                guard let theme = website["theme"].string else {
                    print("Unable to get theme")
                    return
                }
                print("Get the theme used: \(theme)")
            } catch {
                print(error.localizedDescription)
            }
            print("Carry out !")
        default:
            return
        }
    }

}

EveryBlogCLI.main()
