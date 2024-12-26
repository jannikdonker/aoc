import Foundation

class Day25: Day {
    required init() {}

    func run(_ input: String) {
        let startTime = Date().timeIntervalSince1970
        let inputURL = URL(
            fileURLWithPath: input)
        var inputStr = ""
        do {
            inputStr = try String(contentsOf: inputURL, encoding: .utf8)
        } catch {
            print("Failed to read input file: \(error)")
        }

        let schematics = inputStr.components(separatedBy: "\n\n").compactMap { str in
            str.components(separatedBy: "\n")
        }

        func isKey(_ schematic: [String]) -> Bool {
            for char in schematic[0] {
                if char != "." {
                    return false
                }
            }
            return true
        }

        func getHeights(_ schematic: [String]) -> [Int] {
            var res = [0, 0, 0, 0, 0]
            for line in schematic {
                for (i, char) in line.enumerated() {
                    if char == "#" {
                        res[i] += 1
                    }
                }
            }
            return res
        }

        func overlaps(_ key: [Int], _ lock: [Int]) -> Bool {
            for i in 0..<5 {
                if key[i] + lock[i] > 7 {
                    return true
                }
            }
            return false
        }

        let keys = schematics.filter { schematic in
            isKey(schematic)
        }
        let locks = schematics.filter { schematic in
            !isKey(schematic)
        }

        let keyHeights: [[Int]] = keys.map { key in
            getHeights(key)
        }

        let lockHeights: [[Int]] = locks.map { lock in
            getHeights(lock)
        }

        var sum = 0

        keyHeights.forEach { key in
            lockHeights.forEach { lock in
                if !overlaps(key, lock) {
                    sum += 1
                }
            }
        }

        let endTime = Date().timeIntervalSince1970
        let elapsedTime = endTime - startTime

        print("Time elapsed: \(String(format: "%.3f", elapsedTime)) seconds")
        print("AOC 2024 Day 25")
        print("Part 1 Answer: ", sum)
        print("Part 2 Answer: ")
    }
}
