import Foundation

class Day07: Day {
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

        struct Equation {
            var result: Int
            var numbers: [Int]
        }

        let equations: [Equation] = lines.compactMap { line in
            let components = line.components(separatedBy: ": ")
            let result = Int(components[0])!
            let numbers = components[1].components(separatedBy: " ").compactMap { number in
                Int(number)
            }
            return Equation(result: result, numbers: numbers)
        }

        func buildOperators(_ length: Int, _ operators: [Int] = [0, 1]) -> [[Int]] {
            var result = [[Int]]()

            func recurse(current: [Int], remainingLength: Int) {
                if remainingLength == 0 {
                    result.append(current)
                    return
                }

                operators.forEach { op in
                    recurse(current: current + [op], remainingLength: remainingLength - 1)
                }
            }

            recurse(current: [], remainingLength: length)
            return result
        }

        func isSolvable(_ equation: Equation) -> (Bool, Bool) {
            var solvable = false
            var solvable2 = false
            let combinations = buildOperators(equation.numbers.count - 1)
            let combinations2 = buildOperators(equation.numbers.count - 1, [0, 1, 2])

            for combination in combinations {
                var result =  equation.numbers[0]
                for (j, operation) in combination.enumerated() {
                    if operation == 0 {
                        result = result + equation.numbers[j + 1]
                    } else if operation == 1 {
                        result = result * equation.numbers[j + 1]
                    }
                }
                if result == equation.result {
                    solvable = true
                    break
                }
            }

            for combination in combinations2 {
                var result2 =  equation.numbers[0]
                for (j, operation) in combination.enumerated() {
                    if operation == 0 {
                        result2 = result2 + equation.numbers[j + 1]
                    } else if operation == 1 {
                        result2 = result2 * equation.numbers[j + 1]
                    } else {
                        result2 = Int("\(result2)\(equation.numbers[j + 1])")!
                    }
                }
                if result2 == equation.result {
                    solvable2 = true
                    break
                }
            }
            return (solvable, solvable2)
        }

        var sum = 0
        var sum2 = 0
        equations.forEach { equation in
            let solvable = isSolvable(equation)
            if solvable.0 {
                sum += equation.result
            }
            if solvable.1 {
                sum2 += equation.result
            }
        }

        print("AOC 2024 Day 07")
        print("Part 1 Answer: ", sum)
        print("Part 2 Answer: ", sum2)
    }
}
