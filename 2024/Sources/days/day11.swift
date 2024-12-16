import Foundation

class Day11: Day {
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

        let stones = inputStr.components(separatedBy: " ").compactMap { str in
            Int(str)
        }

        var cache: [Int: [Int]] = [:]
        var depthCache: [Int: [Int:Int]] = [:]
        
        func dfs (_ stone: Int, _ depth: Int) -> Int {
            if depth == 0 {
                return 0
            }
            if stone == 0 {
                return dfs(1, depth - 1)
            }
            if let cachedStone = depthCache[stone] {
                if let cachedValue = cachedStone[depth] {
                    return cachedValue
                }
            }

            var result = 0
            
            if let cachedValue = cache[stone] {
                result = dfs(cachedValue[0], depth - 1) + dfs(cachedValue[1], depth - 1) + 1
            } else {
                let stoneStr = String(stone)
                let digits = stoneStr.count
                if digits % 2 == 0 {
                    let stone1 = Int(String(stoneStr.prefix(digits / 2)))!
                    let stone2 = Int(String(stoneStr.suffix(digits / 2)))!
                    cache[stone] = [stone2, stone1]
                    result = dfs(stone1, depth - 1) + dfs(stone2, depth - 1) + 1
                } else {
                    result = dfs(stone * 2024, depth - 1)
                }
            }
            if depthCache[stone] != nil {
                depthCache[stone]![depth] = result
            } else {
                depthCache[stone] = [depth: result]
            }
            return result
        }

        var sum = stones.count
        stones.forEach { stone in
            sum += dfs(stone, 25)
        }

        var sum2 = stones.count
        stones.forEach { stone in
            sum2 += dfs(stone, 75)
        }

        let endTime = Date().timeIntervalSince1970
        let elapsedTime = endTime - startTime

        print("Time elapsed: \(String(format: "%.3f", elapsedTime)) seconds")
        print("AOC 2024 Day 09")
        print("Part 1 Answer: ", sum)
        print("Part 2 Answer: ", sum2)
    }
}
