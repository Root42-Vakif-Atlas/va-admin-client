import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// X.509 sertifikasının açık anahtar bilgisinin (SubjectPublicKeyInfo)
/// Base64 kodlu SHA-256 özetini hesaplar.
///
/// Sertifikanın tamamı yerine açık anahtar sabitlenir; böylece aynı anahtarla
/// yenilenen sertifikalar uygulama güncellemesi gerektirmez. Değer şu komutla
/// üretilen değerle aynıdır:
///
/// ```sh
/// openssl x509 -in cert.pem -pubkey -noout \
///   | openssl pkey -pubin -outform der \
///   | openssl dgst -sha256 -binary | base64
/// ```
abstract final class SpkiHash {
  static const int _sequenceTag = 0x30;
  static const int _versionTag = 0xA0;

  /// DER kodlu [certificate] için özet; ayrıştırılamazsa `null`.
  static String? fromCertificateDer(Uint8List certificate) {
    final spki = extractSubjectPublicKeyInfo(certificate);
    if (spki == null) {
      return null;
    }
    return base64.encode(sha256.convert(spki).bytes);
  }

  /// `Certificate → TBSCertificate → subjectPublicKeyInfo` alanını çıkarır.
  ///
  /// ```text
  /// TBSCertificate ::= SEQUENCE {
  ///   version [0] EXPLICIT OPTIONAL, serialNumber, signature,
  ///   issuer, validity, subject, subjectPublicKeyInfo, ... }
  /// ```
  static Uint8List? extractSubjectPublicKeyInfo(Uint8List der) {
    final certificate = _readElement(der, 0);
    if (certificate == null || certificate.tag != _sequenceTag) {
      return null;
    }
    final tbs = _readElement(der, certificate.contentStart);
    if (tbs == null || tbs.tag != _sequenceTag) {
      return null;
    }

    var cursor = tbs.contentStart;
    final first = _readElement(der, cursor);
    if (first == null) {
      return null;
    }
    if (first.tag == _versionTag) {
      cursor = first.end;
    }

    // serialNumber, signature, issuer, validity, subject
    for (var skipped = 0; skipped < 5; skipped++) {
      final element = _readElement(der, cursor);
      if (element == null) {
        return null;
      }
      cursor = element.end;
    }

    final spki = _readElement(der, cursor);
    if (spki == null || spki.tag != _sequenceTag || spki.end > tbs.end) {
      return null;
    }
    return Uint8List.sublistView(der, spki.start, spki.end);
  }

  static _DerElement? _readElement(Uint8List bytes, int offset) {
    if (offset + 2 > bytes.length) {
      return null;
    }
    final tag = bytes[offset];
    final firstLengthByte = bytes[offset + 1];
    var headerLength = 2;
    int contentLength;

    if (firstLengthByte < 0x80) {
      contentLength = firstLengthByte;
    } else {
      final lengthBytes = firstLengthByte & 0x7F;
      if (lengthBytes == 0 ||
          lengthBytes > 4 ||
          offset + 2 + lengthBytes > bytes.length) {
        return null;
      }
      contentLength = 0;
      for (var i = 0; i < lengthBytes; i++) {
        contentLength = (contentLength << 8) | bytes[offset + 2 + i];
      }
      headerLength += lengthBytes;
    }

    final end = offset + headerLength + contentLength;
    if (end > bytes.length) {
      return null;
    }
    return _DerElement(
      tag: tag,
      start: offset,
      contentStart: offset + headerLength,
      end: end,
    );
  }
}

final class _DerElement {
  const _DerElement({
    required this.tag,
    required this.start,
    required this.contentStart,
    required this.end,
  });

  final int tag;
  final int start;
  final int contentStart;
  final int end;
}
