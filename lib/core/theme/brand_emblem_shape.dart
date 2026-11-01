/// Vakıf Atlas amblemi geometrisi (uygulama simgesindeki logo): sivri
/// kemerli kapı, içinde baklava dilimi ve altında altın eşik (şerit).
///
/// Birim karede (0–1, y aşağı) tanımlıdır; uygulama simgesinin 1024 px
/// kaynağından (`assets/icon/app_icon_foreground.png`) ölçülmüştür, kemer
/// eğrileri piksel konturuna ortalama 0,5 px'ten az sapmayla oturan kübik
/// Bézier'lerdir. Flutter (`BrandEmblemPainter`), native açılış görselleri
/// ve PDF (`RoutePdfRenderer`) aynı komutları çizer — logo değişirse yalnızca
/// burası güncellenir.
///
/// Saf Dart'tır (çizim katmanından bağımsız).
library;

sealed class EmblemPathCommand {
  const EmblemPathCommand();
}

final class EmblemMoveTo extends EmblemPathCommand {
  const EmblemMoveTo(this.x, this.y);

  final double x;
  final double y;
}

final class EmblemLineTo extends EmblemPathCommand {
  const EmblemLineTo(this.x, this.y);

  final double x;
  final double y;
}

final class EmblemCubicTo extends EmblemPathCommand {
  const EmblemCubicTo(this.x1, this.y1, this.x2, this.y2, this.x, this.y);

  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double x;
  final double y;
}

final class EmblemClose extends EmblemPathCommand {
  const EmblemClose();
}

abstract final class BrandEmblemShape {
  // Kemer: dış ve iç kenar, bacak kesimleri şeritle paralel (eğim 1:2).
  static const double _outerLeft = 0.23828;
  static const double _outerRight = 1 - _outerLeft;
  static const double _innerLeft = 0.34766;
  static const double _innerRight = 1 - _innerLeft;
  static const double _springLine = 0.46875;
  static const double _apex = 0.14844;
  static const double _innerApex = 0.27734;
  static const double _outerControl1Y = 0.35645;
  static const double _outerControl2X = 0.36602;
  static const double _outerControl2Y = 0.22883;
  static const double _innerControl1Y = 0.40527;
  static const double _innerControl2X = 0.41207;
  static const double _innerControl2Y = 0.3301;
  static const double _legOuterBottom = 0.56934;
  static const double _legInnerBottom = 0.62402;

  // Baklava dilimi (üst yarısı daha uzun).
  static const double _diamondTop = 0.39551;
  static const double _diamondMiddle = 0.50684;
  static const double _diamondBottom = 0.59766;
  static const double _diamondHalfWidth = 0.05469;

  // Altın eşik (şerit).
  static const double _chevronTop = 0.625;
  static const double _chevronInner = 0.75586;
  static const double _chevronBottom = 0.72168;
  static const double _chevronTip = 0.85254;

  /// Kemer ve baklava dilimi (simgede fildişi, temada birincil renk).
  static const List<List<EmblemPathCommand>> frame = [
    [
      EmblemMoveTo(_outerLeft, _legOuterBottom),
      EmblemLineTo(_outerLeft, _springLine),
      EmblemCubicTo(
        _outerLeft,
        _outerControl1Y,
        _outerControl2X,
        _outerControl2Y,
        0.5,
        _apex,
      ),
      EmblemCubicTo(
        1 - _outerControl2X,
        _outerControl2Y,
        _outerRight,
        _outerControl1Y,
        _outerRight,
        _springLine,
      ),
      EmblemLineTo(_outerRight, _legOuterBottom),
      EmblemLineTo(_innerRight, _legInnerBottom),
      EmblemLineTo(_innerRight, _springLine),
      EmblemCubicTo(
        _innerRight,
        _innerControl1Y,
        1 - _innerControl2X,
        _innerControl2Y,
        0.5,
        _innerApex,
      ),
      EmblemCubicTo(
        _innerControl2X,
        _innerControl2Y,
        _innerLeft,
        _innerControl1Y,
        _innerLeft,
        _springLine,
      ),
      EmblemLineTo(_innerLeft, _legInnerBottom),
      EmblemClose(),
    ],
    [
      EmblemMoveTo(0.5, _diamondTop),
      EmblemLineTo(0.5 + _diamondHalfWidth, _diamondMiddle),
      EmblemLineTo(0.5, _diamondBottom),
      EmblemLineTo(0.5 - _diamondHalfWidth, _diamondMiddle),
      EmblemClose(),
    ],
  ];

  /// Altın eşik (marka vurgusu).
  static const List<List<EmblemPathCommand>> accent = [
    [
      EmblemMoveTo(_outerLeft, _chevronTop),
      EmblemLineTo(0.5, _chevronInner),
      EmblemLineTo(_outerRight, _chevronTop),
      EmblemLineTo(_outerRight, _chevronBottom),
      EmblemLineTo(0.5, _chevronTip),
      EmblemLineTo(_outerLeft, _chevronBottom),
      EmblemClose(),
    ],
  ];
}
