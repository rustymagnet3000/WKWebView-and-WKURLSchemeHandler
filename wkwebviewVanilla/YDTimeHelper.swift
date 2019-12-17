import Foundation

final class YDTimeHelper {
    static func ReadableTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "H:mm:ss"
        let easyDate = formatter.string(from: date)
        let easyEpoch = Int(date.timeIntervalSince1970 * 1000)
        return "[*]\t" + easyDate + "\t| " + String(easyEpoch)
    }
}
