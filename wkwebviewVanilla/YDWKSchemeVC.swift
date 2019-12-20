import UIKit
import WebKit

final class YDWKschemeVC: YDWKVanillaVC {

    override func loadView() {
        
        resource = URL(string: Scheme.custom + Endpoint.hostname + Endpoint.path)!
        
        let configuration = WKWebViewConfiguration()
        let customSchemeHandler = YDWKURLSchemeHandler()

        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        configuration.dataDetectorTypes = [.all]
        configuration.setURLSchemeHandler(customSchemeHandler, forURLScheme: Scheme.custom)
              
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.customUserAgent = "Custom Scheme WKWebKit UserAgent"
        view = webView
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}
