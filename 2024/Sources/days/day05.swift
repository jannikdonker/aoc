import Foundation

class Day05: Day {
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

        let lines = inputStr.components(separatedBy: .newlines)

        var rules: [[Int]] = []

        var middlePageSum = 0
        var middlePageSum2 = 0

        for line in lines {
            if line == "" {
                break
            }

            let numbersStr: [String] = line.components(separatedBy: "|")
            var numbers: [Int] = []

            numbersStr.forEach { str in
                if let number = Int(str) {
                    numbers.append(number)
                }
            }

            rules.append(numbers)
        }

        for line in lines {
            if line.contains("|") || line == "" {
                continue
            }

            let numbersStr: [String] = line.components(separatedBy: ",")
            var numbers: [Int] = []

            numbersStr.forEach { str in
                if let number = Int(str) {
                    numbers.append(number)
                }
            }

            if isOrdered(update: numbers) {
                middlePageSum += numbers[numbers.count / 2]
            } else {
                while !isOrdered(update: numbers) {
                    numbers = reorder(update: numbers)
                }
                middlePageSum2 += numbers[numbers.count / 2]
            }

        }

        func isOrdered (update: [Int]) -> Bool {
            rules.allSatisfy(
                { (rule) in
                    let x = rule[0]
                    let y = rule[1]
                    let i = update.firstIndex(of: x)
                    let j = update.firstIndex(of: y)
                    return i == nil || j == nil || i! < j!
                })
        }

        func reorder (update: [Int]) -> [Int] {
            var numbers: [Int] = update
            rules.forEach { rule in
                    let x = rule[0]
                    let y = rule[1]
                    let i = numbers.firstIndex(of: x)
                    let j = numbers.firstIndex(of: y)

                    if i != nil && j != nil && i! > j! {
                        numbers.remove(at: i!)
                        numbers.insert(x, at: j!)
                    }
                }
            return numbers
        }

        print("AOC 2024 Day 05")
        print("Part 1 Answer: ", middlePageSum)
        print("Part 2 Answer: ", middlePageSum2)
    }
}
