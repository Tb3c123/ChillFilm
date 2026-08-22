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

  static const String _antiAdScript = '''
    (function() {
      // Vô hiệu hóa tính năng nảy cửa sổ / tab mới
      window.open = function() { return null; };
      window.alert = function() {};
      window.confirm = function() { return false; };
      
      // Xóa các khung hình quảng cáo đè đè trên Player
      setInterval(function() {
        var ads = document.querySelectorAll('iframe[src*="ads"], iframe[src*="bet"], div[id*="popup"], div[class*="popup"], div[style*="z-index: 99999"]');
        ads.forEach(function(el) { el.remove(); });
      }, 1000);
    })();
  ''';

  @override
  void initState() {
    super.initState();
    final initialUri = Uri.tryParse(widget.embedUrl);
    final initialHost = initialUri?.host ?? '';

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
            // Tiêm kịch bản chống nhảy Pop-up và xóa thẻ Ads khi nạp xong trang
            _controller.runJavaScript(_antiAdScript);
            if (mounted) setState(() { _isLoading = false; });
          },
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.tryParse(request.url);
            final host = uri?.host ?? '';

            // Chỉ cho phép điều hướng trong domain Embed gốc hoặc domain phim hợp lệ
            if (host.isEmpty ||
                host == initialHost ||
                host.contains('nguonc.com') ||
                host.contains('phimapi.com') ||
                host.contains('streamc.xyz') ||
                host.contains('opstream16.com')) {
              return NavigationDecision.navigate;
            }

            // Chặn 100% việc tự ý nhảy tab sang các domain quảng cáo bên ngoài
            return NavigationDecision.prevent;
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
                        'Đang nạp trình phát video Embed (Chế độ An Toàn Chống Ads)...',
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
