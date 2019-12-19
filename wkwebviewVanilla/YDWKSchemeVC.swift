import UIKit
import WebKit

protocol YDWKFinished {
    func notFinished() -> Bool
}

class YDWKschemeVC: UIViewController, WKNavigationDelegate, YDWKFinished {
    func notFinished() -> Bool {
        return webView.isLoading
    }
    
    var webView: WKWebView!
    let resource: URL = URL(string: Scheme.custom + Endpoint.hostname + Endpoint.path)!

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("[*]\twebView.isLoading = \(webView.isLoading)")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("[*]\tdid finish \(self)")
        print("[*]\twebView.isLoading = \(webView.isLoading)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = WKWebViewConfiguration()
        let customSchemeHandler = YDWKURLSchemeHandler()

        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        configuration.dataDetectorTypes = [.all]
        configuration.setURLSchemeHandler(customSchemeHandler, forURLScheme: Scheme.custom)

        webView = WKWebView(frame: .zero, configuration: configuration)
        view = webView
        webView.navigationDelegate = self

        let myRequest = URLRequest(url: resource)
        self.webView.load(myRequest)
    }
}
