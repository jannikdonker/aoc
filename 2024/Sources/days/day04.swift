import Foundation

class Day04: Day {
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

        var totalXMAS = 0
        var totalMAS = 0

        for (i, line) in lines.enumerated() {
            for (j, char) in line.enumerated() {
                // hor +
                if char == "X" && j < line.count - 3 {
                    let startIndex = line.index(line.startIndex, offsetBy: j + 1)
                    let endIndex = line.index(line.startIndex, offsetBy: j + 3)
                    let substring = line[startIndex...endIndex]
                    if substring == "MAS" {
                        totalXMAS += 1
                    }
                }
                // hor -
                if char == "X" && j > 2 {
                    let endIndex = line.index(line.startIndex, offsetBy: j - 1)
                    let startIndex = line.index(line.startIndex, offsetBy: j - 3)
                    let substring = line[startIndex...endIndex]
                    if substring == "SAM" {
                        totalXMAS += 1
                    }
                }
                // ver +
                if char == "X" && i < lines.count - 4 {
                    let substring =
                        String(lines[i + 1][line.index(line.startIndex, offsetBy: j)])
                        + String(lines[i + 2][line.index(line.startIndex, offsetBy: j)])
                        + String(lines[i + 3][line.index(line.startIndex, offsetBy: j)])

                    if substring == "MAS" {
                        totalXMAS += 1
                    }
                }
                // ver -
                if char == "X" && i > 2 {
                    let substring =
                        String(lines[i - 1][line.index(line.startIndex, offsetBy: j)])
                        + String(lines[i - 2][line.index(line.startIndex, offsetBy: j)])
                        + String(lines[i - 3][line.index(line.startIndex, offsetBy: j)])

                    if substring == "MAS" {
                        totalXMAS += 1
                    }
                }
                // dia tl
                if char == "X" && i > 2 && j > 2 {
                    let substring =
                        String(lines[i - 1][line.index(line.startIndex, offsetBy: j - 1)])
                        + String(lines[i - 2][line.index(line.startIndex, offsetBy: j - 2)])
                        + String(lines[i - 3][line.index(line.startIndex, offsetBy: j - 3)])

                    if substring == "MAS" {
                        totalXMAS += 1
                    }
                }
                // dia tr
                if char == "X" && i > 2 && j < line.count - 3 {
                    let substring =
                        String(lines[i - 1][line.index(line.startIndex, offsetBy: j + 1)])
                        + String(lines[i - 2][line.index(line.startIndex, offsetBy: j + 2)])
                        + String(lines[i - 3][line.index(line.startIndex, offsetBy: j + 3)])

                    if substring == "MAS" {
                        totalXMAS += 1
                    }
                }
                // dia bl
                if char == "X" && i < lines.count - 4 && j > 2 {
                    let substring =
                        String(lines[i + 1][line.index(line.startIndex, offsetBy: j - 1)])
                        + String(lines[i + 2][line.index(line.startIndex, offsetBy: j - 2)])
                        + String(lines[i + 3][line.index(line.startIndex, offsetBy: j - 3)])

                    if substring == "MAS" {
                        totalXMAS += 1
                    }
                }
                // dia br
                if char == "X" && i < lines.count - 4 && j < line.count - 3 {
                    let substring =
                        String(lines[i + 1][line.index(line.startIndex, offsetBy: j + 1)])
                        + String(lines[i + 2][line.index(line.startIndex, offsetBy: j + 2)])
                        + String(lines[i + 3][line.index(line.startIndex, offsetBy: j + 3)])

                    if substring == "MAS" {
                        totalXMAS += 1
                    }
                }

                if char == "A" && i < lines.count - 2 && i > 0 && j < line.count - 1 && j > 0 {
                    let dia1: String =
                        String(lines[i + 1][line.index(line.startIndex, offsetBy: j - 1)])
                        + String(lines[i][line.index(line.startIndex, offsetBy: j)])
                        + String(lines[i - 1][line.index(line.startIndex, offsetBy: j + 1)])
                    let dia2: String =
                        String(lines[i + 1][line.index(line.startIndex, offsetBy: j + 1)])
                        + String(lines[i][line.index(line.startIndex, offsetBy: j)])
                        + String(lines[i - 1][line.index(line.startIndex, offsetBy: j - 1)])

                    if (dia1 == "MAS" || dia1 == "SAM") && (dia2 == "MAS" || dia2 == "SAM") {
                        totalMAS += 1
                    }
                }

            }
        }

        print("AOC 2024 Day 04")
        print("Part 1 Answer: ", totalXMAS)
        print("Part 2 Answer: ", totalMAS)
    }
}
