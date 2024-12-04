import Foundation

class Day02: Day {
    required init() {}

    func isSafe(components: [String]) -> (Bool, Int) {
        var increasing = true
        var safe = true
        var failIndex: Int = -1

        for (i, component) in components.enumerated() {
            if i == components.count - 1 {
                break
            }

            let num = Int(component)!
            let nextNum = Int(components[i + 1])!

            if abs(num - nextNum) > 3 || abs(num - nextNum) == 0 {
                safe = false
                failIndex = i
                break
            }

            if i == 0 {
                increasing = num < nextNum
            } else {
                if (increasing && num > nextNum) || (!increasing && num < nextNum) {
                    safe = false
                    failIndex = i
                    break
                }
            }
        }

        return (safe, failIndex)
    }

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

        var safeReports = 0
        var safeReports2 = 0

        for line in lines {
            if line == "" { 
                continue
            }

            let components: [String] = line.components(separatedBy: " ")

            let (safe, failIndex) = isSafe(components: components)

            if safe {
                safeReports += 1
                safeReports2 += 1
            } else {

                var tempComponents = components
                tempComponents.remove(at: failIndex)
                var (safe2, _) = isSafe(components: tempComponents)

                if !safe2 && failIndex > 0 {
                    tempComponents = components
                    tempComponents.remove(at: failIndex - 1)
                    (safe2, _) = isSafe(components: tempComponents)
                }

                if !safe2 && failIndex < components.count - 1 {
                    tempComponents = components
                    tempComponents.remove(at: failIndex + 1)
                    (safe2, _) = isSafe(components: tempComponents)
                }

                if safe2 {
                    safeReports2 += 1
                }
            }

        }

        print("AOC 2024 Day 02")
        print("Part 1 Answer: ", safeReports)
        print("Part 2 Answer: ", safeReports2)
        
    }
}
