import Foundation

class Day10: Day {
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
        let map: [[Int]] = lines.map { string in
            string.compactMap { char in
                Int(String(char))
            }
        }
        let size = map.count
        let directions: [[Int]] = [[0, 1], [0, -1], [1, 0], [-1, 0]]

        func getTrails(_ start: [Int]) -> (Int, Int) {

            var resultAll = 0
            var resultUnique = 0
            let val = map[start[0]][start[1]]

            // print(start, val)

            if val == 9 && !uniqueEndpoints.contains(start) {
                uniqueEndpoints.insert(start)
                return (1, 1)
            } else if val == 9 {
                return (1, 0)
            }

            for dir in directions {
                let offset = [start[0] + dir[0], start[1] + dir[1]]
                if offset[0] >= 0 && offset[1] >= 0 && offset[0] < size && offset[1] < size {
                    let offVal = map[offset[0]][offset[1]]

                    if offVal == val + 1 {
                        let temp = getTrails(offset)
                        resultAll += temp.0
                        resultUnique += temp.1
                    }
                } else {
                    continue
                }
            }

            return (resultAll, resultUnique)
        }

        var uniqueEndpoints: Set<[Int]> = []
        var sum = (0, 0)
        for (i, line) in map.enumerated() {
            for (j, col) in line.enumerated() {
                if col == 0 {
                    uniqueEndpoints = []
                    let temp = getTrails([i, j])
                    sum.0 += temp.0
                    sum.1 += temp.1
                }
            }
        }

        print("AOC 2024 Day 09")
        print("Part 1 Answer: ", sum.1)
        print("Part 2 Answer: ", sum.0)
    }
}
