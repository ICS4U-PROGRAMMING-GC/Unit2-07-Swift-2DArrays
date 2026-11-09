import Foundation

/// 2D arrays program.
///
/// @author Carel
/// @version 1.0
/// @date 2026-11-09
public final class Arrays2D {
    
    private static let MEAN: Double = 75.0
    private static let STANDARD_DEVIATION: Double = 10.0
    
    private init() {
    }
    
    public static func main() {
        let studentArray = readFile("students.txt")
        let assignmentsArray = readFile("assignments.txt")
        
        let results = generateMarks(studentArray, assignmentsArray)
        
        writeCSV(results)
    }
    
    private static func readFile(_ fileName: String) -> [String] {
        let fileManager = FileManager.default
        let currentDirectory = fileManager.currentDirectoryPath
        let fileURL = URL(fileURLWithPath: currentDirectory).appendingPathComponent(fileName)
        
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            
            var tempList = [String]()
            for line in lines {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    tempList.append(trimmed)
                }
            }
            return tempList
        } catch {
            print("File not found: \(fileName)")
            return []
        }
    }
    
    public static func generateMarks(_ studentArray: [String], _ assignmentsArray: [String]) -> [[String]] {
        let rowCount = studentArray.count + 1
        let colCount = assignmentsArray.count + 1
        
        var results = Array(repeating: Array(repeating: "", count: colCount), count: rowCount)
        
        results[0][0] = "Student"
        
        for i in 0..<assignmentsArray.count {
            results[0][i + 1] = assignmentsArray[i]
        }
        
        for i in 0..<studentArray.count {
            results[i + 1][0] = studentArray[i]
            
            for j in 0..<assignmentsArray.count {
                // Generate next Gaussian value using native Swift math
                let gaussianValue = nextGaussian()
                let mark = Int(round(gaussianValue * STANDARD_DEVIATION + MEAN))
                
                results[i + 1][j + 1] = String(mark)
            }
        }
        
        return results
    }
    
    /// Helper to generate a random number following a standard normal distribution
    private static func nextGaussian() -> Double {
        var u1 = 0.0
        while u1 == 0.0 {
            u1 = Double.random(in: 0...1)
        }
        let u2 = Double.random(in: 0...1)
        return sqrt(-2.0 * log(u1)) * sin(2.0 * Double.pi * u2)
    }
    
    private static func writeCSV(_ results: [[String]]) {
        let fileManager = FileManager.default
        let currentDirectory = fileManager.currentDirectoryPath
        let fileURL = URL(fileURLWithPath: currentDirectory).appendingPathComponent("marks.csv")
        
        var csvString = ""
        
        for i in 0..<results.count {
            for j in 0..<results[i].count {
                csvString.append(results[i][j])
                
                if j < results[i].count - 1 {
                    csvString.append(",")
                }
            }
            csvString.append("\n")
        }
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Marks saved to marks.csv")
        } catch {
            print("Error writing CSV file.")
        }
    }
}

// Call the main method
Arrays2D.main()
