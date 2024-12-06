import Foundation

class Day06: Day {
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

        func nextPositionInBounds(_ position: [Int], _ direction: [Int]) -> Bool {
            if position[0] + direction[0] > map[0].count - 1 || position[0] + direction[0] < 0
                || position[1] + direction[1] > map.count - 1 || position[1] + direction[1] < 0
            {
                return false
            }
            return true
        }

        func isLoop(_ position: [Int], _ direction: [Int]) -> Bool {
            var pDirection = direction
            var pPosition = position
            var pMap = map
            if nextPositionInBounds(pPosition, pDirection) {
                let nextPosition = [pPosition[0] + pDirection[0], pPosition[1] + pDirection[1]]
                pMap[nextPosition[1]][nextPosition[0]] = "#"
            }
            var pVisited: [[String : [Int]]] = [["position": pPosition, "direction": pDirection]]
            var isLoop = false
            while nextPositionInBounds(pPosition, pDirection) && !isLoop {
                let nextPosition = [pPosition[0] + pDirection[0], pPosition[1] + pDirection[1]]

                if pMap[nextPosition[1]][nextPosition[0]] == "#" {
                    pDirection = [
                        pDirection[0] * 0 - pDirection[1] * 1,
                        pDirection[0] * 1 - pDirection[1] * 0,
                    ]
                    continue
                }

                pPosition = nextPosition
                if #available(macOS 13.0, *) {
                    if pVisited.contains([["position": pPosition, "direction": pDirection]]) {
                        isLoop = true
                        break
                    }
                }
                pVisited.append(["position": pPosition, "direction": pDirection])

            }
            return isLoop
        }

        var map: [[String.Element]] = []
        var direction: [Int] = [0, 0]
        var position: [Int] = [0, 0]
        var startPosition = [0, 0]
        var visited: [[String : [Int]]] = []
        var loopPositions: [[Int]] = []
        var loopPositionsChecked: [[Int]] = []

        let lines = inputStr.components(separatedBy: .newlines)

        for (i, line) in lines.enumerated() {
            var currentLine: [String.Element] = []
            for (j, char) in line.enumerated() {
                if char == "^" || char == "v" || char == "<" || char == ">" {
                    position = [j, i]
                    startPosition = [j, i]
                    switch char {
                    case "^":
                        direction = [0, -1]
                    case "v":
                        direction = [0, 1]
                    case "<":
                        direction = [-1, 0]
                    case ">":
                        direction = [1, 0]
                    default:
                        direction = [0, -1]
                    }
                    visited.append(["position": position, "direction": direction])
                    currentLine.append(".")
                } else {
                    currentLine.append(char)
                }
            }
            map.append(currentLine)
        }

        while nextPositionInBounds(position, direction) {
            let nextPosition = [position[0] + direction[0], position[1] + direction[1]]

            if map[nextPosition[1]][nextPosition[0]] == "#" {
                direction = [
                    direction[0] * 0 - direction[1] * 1, direction[0] * 1 - direction[1] * 0,
                ]
                continue
            }

            print("Checking isLoop for position and direction: ", position, direction)
            if nextPosition != startPosition && !loopPositions.contains(nextPosition) && !loopPositionsChecked.contains(nextPosition) {
                loopPositionsChecked.append(nextPosition)
                if isLoop(position, direction){
                    loopPositions.append(nextPosition)
                }
            }

            position = nextPosition

            if visited.contains(["position": nextPosition, "direction": direction]) {
                continue
            }

            visited.append(["position": nextPosition, "direction": direction])

        }

        print("AOC 2024 Day 06")
        print("Part 1 Answer: ", visited.count)
        print("Part 2 Answer: ", loopPositions.count)
    }
}
