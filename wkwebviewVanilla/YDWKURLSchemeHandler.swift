import Foundation
import WebKit

final class YDWKURLSchemeHandler: NSObject, WKURLSchemeHandler {

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        print("🕵🏼‍♂️ in webView stop")
    }

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        do {

            guard let url = webView.url else {
                return
            }
            print("🕵🏼‍♂️ original URL \(url)")
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.scheme = "https"
            
            guard let finalUrl = components?.url else {
                return
            }
            print("🕵🏼‍♂️ URL -> \(finalUrl.absoluteURL) + \tmime-type: \(finalUrl.getMimeType())")
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
            print("🕵🏼‍♂️ in catch")
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
