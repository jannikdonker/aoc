import Foundation

class Day08: Day {
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
        let map = lines.map { $0.map { $0 } }

        var antennas: [String.Element: [[Int]]] = [:]

        for (i, line) in map.enumerated() {
            for (j, char) in line.enumerated() {
                if char == "." {
                    continue
                }
                if antennas.keys.contains(char) {
                    antennas[char]?.append([j, i])
                } else {
                    antennas[char] = [[j, i]]
                }
            }
        }

        func diff(_ p1: [Int], _ p2: [Int]) -> [Int] {
            return [abs(p1[0] - p2[0]), abs(p1[1] - p2[1])]
        }

        func direction(_ p1: [Int], _ p2: [Int]) -> [[Int]] {
            var direction = [0, 0]

            if p1[0] < p2[0] {
                direction[0] = -1
            } else if p1[0] > p2[0] {
                direction[0] = 1
            }

            if p1[1] < p2[1] {
                direction[1] = -1
            } else if p1[1] > p2[1] {
                direction[1] = 1
            }

            return [direction, [direction[0] - direction[0] * 2, direction[1] - direction[1] * 2]]
        }

        func getAntinodes(_ p1: [Int], _ p2: [Int], _ all: Bool = false) -> [[Int]] {
            var antinodes: [[Int]] = []

            let diff = diff(p1, p2)
            let directions = direction(p1, p2)

            if !all {
                let a1 = [p1[0] + diff[0] * directions[0][0], p1[1] + diff[1] * directions[0][1]]
                let a2 = [p2[0] + diff[0] * directions[1][0], p2[1] + diff[1] * directions[1][1]]

                if a1[0] < lines[0].count && a1[1] < lines.count && a1[0] >= 0 && a1[1] >= 0 {
                    antinodes.append(a1)
                }

                if a2[0] < lines[0].count && a2[1] < lines.count && a2[0] >= 0 && a2[1] >= 0 {
                    antinodes.append(a2)
                }
            } else {
                antinodes.append(p1)
                antinodes.append(p2)
                var nextA: [Int] = [p1[0] + diff[0] * directions[0][0], p1[1] + diff[1] * directions[0][1]]
                while nextA[0] < lines[0].count && nextA[0] >= 0 && nextA[1] < lines.count && nextA[1] >= 0 {
                    antinodes.append(nextA)
                    nextA = [nextA[0] + diff[0] * directions[0][0], nextA[1] + diff[1] * directions[0][1]]
                }
                nextA = [p2[0] + diff[0] * directions[1][0], p2[1] + diff[1] * directions[1][1]]
                while nextA[0] < lines[0].count && nextA[0] >= 0 && nextA[1] < lines.count && nextA[1] >= 0 {
                    antinodes.append(nextA)
                    nextA = [nextA[0] + diff[0] * directions[1][0], nextA[1] + diff[1] * directions[1][1]]
                }
            }

            return antinodes
        }

        var uniqueAntinodes: Set<[Int]> = []
        var uniqueAntinodes2: Set<[Int]> = []

        for antenna in antennas {
            for (j, location1) in antenna.value.enumerated() {
                for (k, location2) in antenna.value.enumerated() {
                    if j >= k {
                        continue
                    }

                    let antinodes = getAntinodes(location1, location2)
                    let antinodes2 = getAntinodes(location1, location2, true)

                    if antinodes.count > 0 {
                        antinodes.forEach { antinode in
                            uniqueAntinodes.insert(antinode)
                        }
                    }

                    if antinodes2.count > 0 {
                        antinodes2.forEach { antinode in
                            uniqueAntinodes2.insert(antinode)
                        }
                    }
                }
            }
        }

        var modifiedMap = map

        for a in uniqueAntinodes2 {
            if modifiedMap[a[1]][a[0]] == "." {
                modifiedMap[a[1]][a[0]] = "#"
            }
        }

        modifiedMap.forEach { l in
            var str = ""
            l.forEach { char in
                str += String(char)
            }
            print(str)
        }

        print("AOC 2024 Day 08")
        print("Part 1 Answer: ", uniqueAntinodes.count)
        print("Part 2 Answer: ", uniqueAntinodes2.count)
    }
}
