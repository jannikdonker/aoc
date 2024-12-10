import Foundation

class Day09: Day {
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

        func decompress(_ input: String) -> [[String]] {
            var output: [[String]] = []

            var isFile = true
            var fileID = 0
            var currentBlock: [String] = []
            for char in input {
                if isFile {
                    var counter = Int(String(char))!
                    while counter > 0 {
                        currentBlock.append(String(fileID))
                        counter -= 1
                    }
                    fileID += 1
                } else {
                    var counter = Int(String(char))!
                    while counter > 0 {
                        currentBlock.append(".")
                        counter -= 1
                    }
                }
                output.append(currentBlock)
                currentBlock = []
                isFile.toggle()
            }
            output = output.filter { !$0.isEmpty }
            return output
        }

        func sortDecompressed(_ input: [String]) -> [String] {
            var output: [String] = input

            var counter = output.count - 1
            var freeSpace = output.firstIndex(of: ".")!
            while counter > freeSpace {
                let char = output[counter]
                if char == "." {
                    counter -= 1
                    continue
                }
                output.swapAt(counter, freeSpace)
                freeSpace = output.firstIndex(of: ".")!
                counter -= 1
            }

            return output
        }

        func defragment (_ input: [[String]]) -> [[String]] {
            var output: [[String]] = input

            var counter = output.count - 1
            while counter >= 0 {
                let currentBlock = output[counter]
                if !currentBlock.isEmpty && currentBlock[0] == "." {
                    counter -= 1
                    continue
                }
                for (i, freespace) in output.enumerated() {
                    if !freespace.isEmpty && freespace[0] != "." {
                        continue
                    }
                    if i > counter {
                        break
                    }
                    if freespace.count == currentBlock.count {
                        output.swapAt(counter, i)
                        break
                    } else if freespace.count > currentBlock.count {
                        let newFreespace1 = Array(freespace.prefix(currentBlock.count))
                        let newFreespace2 = Array(freespace.suffix(from: currentBlock.count))
                        output.remove(at: i)
                        output.insert(newFreespace2, at: i)
                        output.insert(newFreespace1, at: i)
                        output.swapAt(counter + 1, i)
                        counter += 1
                        break
                    }
                }
                counter -= 1
            }
            return output
        }

        let decompressed = decompress(inputStr)
        let sorted = sortDecompressed(decompressed.flatMap { $0 })
        let defragmented = defragment(decompressed).flatMap { $0 }

        // print(decompressed.flatMap { $0 }.joined())
        // print(defragmented.flatMap { $0 }.joined())

        var sum = 0
        for (i, char) in sorted.enumerated() {
            if char == "." {
                break
            }
            sum += i * Int(char)!
        }

        var sum2 = 0
        for (i, char) in defragmented.enumerated() {
            if char == "." {
                continue
            }
            sum2 += i * Int(char)!
        }

        print("AOC 2024 Day 09")
        print("Part 1 Answer: ", sum)
        print("Part 2 Answer: ", sum2)
    }
}
