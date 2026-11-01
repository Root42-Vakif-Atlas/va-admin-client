import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  /// Yönetim paneli ana-detay düzeni için alt sınır (kenar çubuğu + liste +
  /// ayrıntı); daha dar pencerede düzen tek sütuna iner.
  private static let minimumSize = NSSize(width: 1100, height: 720)
  private static let initialSize = NSSize(width: 1440, height: 900)

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    let visible = NSScreen.main?.visibleFrame ?? NSRect(origin: .zero, size: Self.initialSize)
    let size = NSSize(
      width: min(Self.initialSize.width, visible.width),
      height: min(Self.initialSize.height, visible.height)
    )
    self.setFrame(
      NSRect(
        x: visible.midX - size.width / 2,
        y: visible.midY - size.height / 2,
        width: size.width,
        height: size.height
      ),
      display: true
    )
    self.contentMinSize = Self.minimumSize
    self.title = "Vakıf Atlas Yönetim"

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
