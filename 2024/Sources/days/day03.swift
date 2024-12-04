import Foundation

class Day03: Day {
    required init() {}

    func run(_ input: String) {
        let inputURL = URL(
            fileURLWithPath: input)

        var inputStr = ""

        do {
            inputStr = try String(contentsOf: inputURL, encoding: .utf8)
        } catch {
            print("Failed to read input file: \(error)")
        }

        if #available(macOS 13.0, *) {
            let matches = inputStr.ranges(of: /mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/)

            var flag = true
            var sum = 0
            var sum2 = 0

            for match in matches {
                let matchStr = String(inputStr[match])
                if matchStr == "do()" {
                    flag = true
                } else if matchStr == "don't()" {
                    flag = false
                } else {
                    let numbers = matchStr.matches(of: /\d{1,3}/)
                        .map { Int($0.0)! }
                    let mul = numbers[0] * numbers[1]
                    sum += mul
                    if flag {
                        sum2 += mul
                    }
                }
            }

            print("AOC 2024 Day 03")
            print("Part 1 Answer: ", sum)
            print("Part 2 Answer: ", sum2)
        }
    }
}
