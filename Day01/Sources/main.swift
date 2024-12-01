import Foundation

let inputURL = URL(fileURLWithPath: FileManager().currentDirectoryPath + "/Sources/input.txt")

let inputStr = try String(contentsOf: inputURL, encoding: .utf8)

let lines = inputStr.components(separatedBy: .newlines)

var list1: [Int] = []
var list2: [Int] = []

for line in lines {

    if line == "" {
        continue
    }

    let components: [String] = line.components(separatedBy: "   ")

    if components.count == 2 {
        list1.append(Int(components[0])!)
        list2.append(Int(components[1])!)
    }
}

list1.sort()
list2.sort()

var totalDiff = 0
var simScore = 0

for (index, number) in list1.enumerated() {
    if number >= list2[index] {
        totalDiff = totalDiff + number - list2[index]
    } else {
        totalDiff = totalDiff + list2[index] - number
    }

    let firstIndex = list2.firstIndex(of: number)

    if firstIndex == nil {
        continue
    }

    var multiplier = 0
    var lastIndex: Int = firstIndex!

    while lastIndex < list2.count && list2[lastIndex] == number {
        multiplier = multiplier + 1
        lastIndex = lastIndex + 1
    }

    simScore = simScore + number * multiplier
}

print("Part 1 Answer: ", totalDiff)
print("Part 2 Answer: ", simScore)
