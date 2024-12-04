// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

protocol Day {
    init()
    func run(_ input: String)
}

enum ValidationError: Error {
    case invalidArgument(reason: String)
}

@main
struct aoc2024: ParsableCommand {
    @Argument(help: "The AOC day to run") var day: Int

    func validateDay(_ day: Int) throws {
        if day < 1 || day > 25 {
            throw ValidationError.invalidArgument(reason: "Day must be between 1 and 25.")
        }
    }

    mutating func run() throws {
        do {
            try validateDay(day)

            let currentDirectory = FileManager.default.currentDirectoryPath
            let inputPath = "\(currentDirectory)/Input/day\(String(format: "%02d", day)).txt"

            let className = "aoc2024.Day\(String(format: "%02d", day))"
            if let dayClass = NSClassFromString(className) as? Day.Type {
                let dayInstance = dayClass.init()
                dayInstance.run(inputPath)
            } else {
                print("Day \(day) not implemented yet.")
            }
        } catch ValidationError.invalidArgument(let reason) {
            print("Validation Error: \(reason)")
        } catch {
            print("An unexpected error occurred: \(error)")
        }
    }

}
