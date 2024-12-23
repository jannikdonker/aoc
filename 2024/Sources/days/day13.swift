import Foundation

class Day13: Day {
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

        let lines = inputStr.components(separatedBy: .newlines)

        struct Machine {
            let buttonA: (x: Int, y: Int)
            let buttonB: (x: Int, y: Int)
            var prize: (x: Int, y: Int)
        }

        func getMachine(_ lineIndex: Int) -> Machine {
            let line = lines[lineIndex]
            let line2 = lines[lineIndex + 1]
            let line3 = lines[lineIndex + 2]
            let patternA = "Button A: X\\+(\\d+), Y\\+(\\d+)"
            let patternB = "Button B: X\\+(\\d+), Y\\+(\\d+)"
            let patternP = "Prize: X=(\\d+), Y=(\\d+)"
            let regexA = try! NSRegularExpression(pattern: patternA)
            let regexB = try! NSRegularExpression(pattern: patternB)
            let regexP = try! NSRegularExpression(pattern: patternP)

            var (bAX, bAY, bBX, bBY, pX, pY) = (0, 0, 0, 0, 0, 0)

            if let match = regexA.firstMatch(
                in: line, range: NSRange(line.startIndex..., in: line))
            {
                if let xRange = Range(match.range(at: 1), in: line),
                    let yRange = Range(match.range(at: 2), in: line)
                {
                    bAX = Int(line[xRange])!
                    bAY = Int(line[yRange])!
                }
            }

            if let match = regexB.firstMatch(
                in: line2, range: NSRange(line2.startIndex..., in: line2))
            {
                if let xRange = Range(match.range(at: 1), in: line2),
                    let yRange = Range(match.range(at: 2), in: line2)
                {
                    bBX = Int(line2[xRange])!
                    bBY = Int(line2[yRange])!
                }
            }

            if let match = regexP.firstMatch(
                in: line3, range: NSRange(line3.startIndex..., in: line3))
            {
                if let xRange = Range(match.range(at: 1), in: line3),
                    let yRange = Range(match.range(at: 2), in: line3)
                {
                    pX = Int(line3[xRange])!
                    pY = Int(line3[yRange])!
                }
            }

            let m = Machine(
                buttonA: (x: bAX, y: bAY), buttonB: (x: bBX, y: bBY), prize: (x: pX, y: pY))
            return m
        }

        func getTokenNum(_ m: Machine) -> Int {
            let (xA, yA) = m.buttonA
            let (xB, yB) = m.buttonB
            let (xP, yP) = m.prize

            let t1 = xB * yP - yB * xP
            let t2 = xB * yA - yB * xA

            if t1 % t2 != 0 {
                return 0
            }

            let ak = t1 / t2

            let t3 = xP - xA * ak

            if t3 % xB != 0 {
                return 0
            }

            let bk = t3 / xB

            return ak * 3 + bk
        }

        var machines: [Machine] = []

        for (i, line) in lines.enumerated() {
            if line.starts(with: "Button A") {
                machines.append(getMachine(i))
            }
        }
        let machines2: [Machine] = machines.map { m -> Machine in
            var mutableMachine = m
            mutableMachine.prize.x += 10_000_000_000_000
            mutableMachine.prize.y += 10_000_000_000_000
            return mutableMachine
        }
        var sum = 0
        machines.forEach { m in
            sum += getTokenNum(m)
        }

        var sum2 = 0
        machines2.forEach { m in
            sum2 += getTokenNum(m)
        }

        let endTime = Date().timeIntervalSince1970
        let elapsedTime = endTime - startTime

        print("Time elapsed: \(String(format: "%.3f", elapsedTime)) seconds")
        print("AOC 2024 Day 13")
        print("Part 1 Answer: ", sum)
        print("Part 2 Answer: ", sum2)
    }
}
