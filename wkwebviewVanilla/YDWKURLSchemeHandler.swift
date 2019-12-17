import Foundation
import WebKit

final class YDWKURLSchemeHandler: NSObject, WKURLSchemeHandler {

    static let customScheme = "rm"
    fileprivate let scheme = "https"
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        do {
            
            guard let url = urlSchemeTask.request.url else {
                return
            }
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.scheme = scheme
            
            guard let finalUrl = components?.url else {
                return
            }
            print("[*]\tURL -> \(finalUrl.absoluteURL)")
            
            let data = try Data(contentsOf: finalUrl)
            
            let response = URLResponse(url: finalUrl,
                                       mimeType: finalUrl.getMimeType(),
                                       expectedContentLength: data.count,
                                       textEncodingName: nil)
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        }
            
        catch {
            urlSchemeTask.didFailWithError(error)
        }
    }
}

extension URL {
    func getMimeType() -> String {
        
        switch self.pathExtension {
            case "png":
                return "image/png"
            case "jpg":
                return "image/jpg"
            case "js":
                return "text/javascript"
            default:
                return "text/html"
        }
    }
}
