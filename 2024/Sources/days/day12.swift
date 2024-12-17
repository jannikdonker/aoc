import Foundation

class Day12: Day {
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

        struct Coordinate {
            let x: Int
            let y: Int
        }

        struct Plot {
            let char: String.Element
            let coord: Coordinate
            var visited: Bool
            var openSides: Int
        }

        struct Region {
            let char: String.Element
            var area: Int
            var perimeter: Int
            var plots: [Plot]
        }

        let lines = inputStr.components(separatedBy: .newlines)
        let directions: [[Int]] = [[0, -1], [1, 0], [0, 1], [-1, 0]]
        let directions2: [[Int]] = [
            [0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1],
        ]
        let n: Int = lines.count

        var map: [[Plot]] = []
        var regions: [Region] = []

        for (y, line) in lines.enumerated() {
            var currentLine: [Plot] = []
            for (x, char) in line.enumerated() {
                let plot = Plot(
                    char: char, coord: Coordinate(x: x, y: y), visited: false, openSides: 4)
                currentLine.append(plot)
            }
            map.append(currentLine)
        }

        for y in 0..<map.count {
            for x in 0..<map[y].count {
                for dir in directions {
                    let offsetX = map[y][x].coord.x + dir[0]
                    let offsetY = map[y][x].coord.y + dir[1]
                    if offsetX < 0 || offsetY < 0 || offsetX >= n || offsetY >= n {
                        continue
                    }
                    if map[offsetY][offsetX].char == map[y][x].char {
                        map[y][x].openSides -= 1
                    }
                }
            }
        }

        func getPlots(_ plot: Plot) -> [Plot] {
            if map[plot.coord.y][plot.coord.x].visited {
                return []
            }

            map[plot.coord.y][plot.coord.x].visited = true

            var neighbours: [Plot] = [plot]
            for dir in directions {
                let offsetX = plot.coord.x + dir[0]
                let offsetY = plot.coord.y + dir[1]
                if offsetX < 0 || offsetY < 0 || offsetX >= n || offsetY >= n {
                    continue
                }
                if map[offsetY][offsetX].char == plot.char && !map[offsetY][offsetX].visited {
                    neighbours.append(contentsOf: getPlots(map[offsetY][offsetX]))
                }
            }
            return neighbours
        }

        func regionContainsPlot(_ region: Region, _ offsetX: Int, _ offsetY: Int) -> Bool {
            return region.plots.contains { plot in
                return plot.coord.x == offsetX && plot.coord.y == offsetY
            }
        }

        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if map[y][x].visited {
                    continue
                }
                var region = Region(
                    char: map[y][x].char,
                    area: 0,
                    perimeter: 0,
                    plots: getPlots(map[y][x])
                )
                region.area = region.plots.count
                region.plots.forEach { plot in
                    region.perimeter += plot.openSides
                }
                regions.append(region)
            }
        }

        var sum = 0
        regions.forEach { region in
            sum += region.area * region.perimeter
        }

        var sum2 = 0
        regions.forEach { region in
            // print("Region: \(region.char)")
            var corners = 0
            region.plots.forEach { plot in
                var outCornerValidator = 0
                var lastStraightDiff = false
                var lastDiaDiff = false

                for dir in directions2 {
                    let offsetX = plot.coord.x + dir[0]
                    let offsetY = plot.coord.y + dir[1]
                    let inBounds = offsetX >= 0 && offsetY >= 0 && offsetX < n && offsetY < n
                    let dia = abs(dir[0]) + abs(dir[1]) > 1

                    // outer corners
                    if !dia {
                        if !inBounds {
                            outCornerValidator += 1
                            lastStraightDiff = true
                        } else if !regionContainsPlot(region, offsetX, offsetY) {
                            outCornerValidator += 1
                            lastStraightDiff = true
                        } else {

                            if lastStraightDiff && !lastDiaDiff {
                                // print("Corner found at: \([plot.coord.x, plot.coord.y]) (Inner)")
                                corners += 1
                            }
                            outCornerValidator = 0
                            lastStraightDiff = false
                        }

                        if outCornerValidator == 2 {
                            // print("Corner found at: \([plot.coord.x, plot.coord.y]) (Outer)")
                            corners += 1
                            outCornerValidator = 1
                            lastStraightDiff = true
                        }
                    } else {
                        if !inBounds || !regionContainsPlot(region, offsetX, offsetY){
                            lastDiaDiff = true
                        } else {
                            lastDiaDiff = false
                        }
                    }

                }
            }
            // print("Corners: \(corners)")
            sum2 += region.area * corners
        }

        let endTime = Date().timeIntervalSince1970
        let elapsedTime = endTime - startTime

        print("Time elapsed: \(String(format: "%.3f", elapsedTime)) seconds")
        print("AOC 2024 Day 12")
        print("Part 1 Answer: ", sum)
        print("Part 2 Answer: ", sum2)
    }
}
