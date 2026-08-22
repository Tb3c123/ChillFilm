import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewFallbackPlayer extends StatefulWidget {
  final String embedUrl;

  const WebviewFallbackPlayer({super.key, required this.embedUrl});

  @override
  State<WebviewFallbackPlayer> createState() => _WebviewFallbackPlayerState();
}

class _WebviewFallbackPlayerState extends State<WebviewFallbackPlayer> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  static const Map<String, String> _streamHeaders = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'Referer': 'https://phim.nguonc.com/',
    'Origin': 'https://phim.nguonc.com',
  };

  static const String _antiAdAndOverlayScript = '''
    (function() {
      // 1. Triệt tiêu các hàm bật Pop-up & Alert
      window.open = function() { return null; };
      window.alert = function() {};
      window.confirm = function() { return false; };
      
      // 2. Inject CSS triệt tiêu lớp phủ Click-jack & Ads
      var style = document.createElement('style');
      style.innerHTML = `
        [class*="ad-"], [id*="ad-"], [class*="ads-"], [id*="ads-"],
        div[style*="z-index: 2147483647"], div[style*="z-index: 9999999"],
        .jw-ad, .vjs-ad-playing, [class*="popup"], [id*="popup"],
        div[style*="position: fixed"][style*="top: 0"] {
          display: none !important;
          visibility: hidden !important;
          opacity: 0 !important;
          pointer-events: none !important;
        }
        video {
          pointer-events: auto !important;
          z-index: 99999 !important;
        }
      `;
      document.head.appendChild(style);

      // 3. Xóa các thẻ Popup/Clickjack động
      setInterval(function() {
        var overlays = document.querySelectorAll(
          'iframe[src*="ads"], iframe[src*="bet"], div[id*="popup"], div[class*="popup"], div[style*="z-index: 2147483647"]'
        );
        overlays.forEach(function(el) { el.remove(); });
      }, 1000);
    })();
  ''';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36')
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() { _isLoading = true; _hasError = false; });
          },
          onPageFinished: (String url) {
            _controller.runJavaScript(_antiAdAndOverlayScript);
            if (mounted) setState(() { _isLoading = false; });
          },
          onWebResourceError: (WebResourceError error) {
            // Error handling
          },
        ),
      );

    if (widget.embedUrl.isNotEmpty) {
      _controller.loadRequest(
        Uri.parse(widget.embedUrl),
        headers: _streamHeaders,
      );
    } else {
      _hasError = true;
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          if (widget.embedUrl.isNotEmpty && !_hasError)
            Positioned.fill(
              child: WebViewWidget(controller: _controller),
            ),

          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF00E5FF)),
                      SizedBox(height: 16),
                      Text(
                        'Đang nạp trình phát Embed Web...',
                        style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFFE50914), size: 48),
                  const SizedBox(height: 12),
                  const Text('Không thể nạp link nhúng embed video', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.embedUrl.isNotEmpty) {
                        _controller.loadRequest(
                          Uri.parse(widget.embedUrl),
                          headers: _streamHeaders,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF)),
                    child: const Text('Thử Nạp Lại', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
