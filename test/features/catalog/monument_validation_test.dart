import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/monument_validation.dart';

void main() {
  const valid = MonumentDraft(
    id: 'rustem-pasa-hamami',
    cityCode: 34,
    district: 'Fatih',
    address: 'Tahtakale',
    latitude: 41.0167,
    longitude: 28.9707,
    tr: MonumentText(name: 'Rüstem Paşa Hamamı', shortDescription: 'Kısa'),
  );

  test('geçerli taslakta hata yok (İngilizce metin isteğe bağlı)', () {
    expect(valid.city, 'İstanbul');
    expect(MonumentValidation.validate(valid, creating: true), isEmpty);
  });

  test('kimlik, il, Türkiye dışı konum ve yeni görselin künyesi yakalanır', () {
    const draft = MonumentDraft(
      id: 'Bad Id',
      latitude: 51.5,
      longitude: 0,
      tr: MonumentText(name: 'Ad'),
      images: [
        MonumentImage(sha256: 'a', previewBytes: [1], altTr: 'Kubbe'),
      ],
    );
    expect(MonumentValidation.validate(draft, creating: true), {
      MonumentField.id,
      MonumentField.city,
      MonumentField.location,
      MonumentField.images,
    });
    // Kayıtlı eserin kimliği değişmez; doğrulanmaz.
    expect(
      MonumentValidation.validate(draft, creating: false),
      isNot(contains(MonumentField.id)),
    );
  });

  test('içe aktarılan görselde künye zorunlu değil, Türkçe betim zorunlu', () {
    final draft = valid.copyWith(
      images: const [MonumentImage(sha256: 'a', url: 'https://x/1.jpg')],
    );
    expect(MonumentValidation.validate(draft, creating: false), {
      MonumentField.images,
    });
    expect(
      MonumentValidation.validate(
        valid.copyWith(
          images: const [
            MonumentImage(sha256: 'a', url: 'https://x/1.jpg', altTr: 'Kubbe'),
          ],
        ),
        creating: false,
      ),
      isEmpty,
    );
  });

  test('külliyede ilçe zorunlu', () {
    final complex = valid.copyWith(
      category: MonumentCategory.complex,
      district: '',
    );
    expect(MonumentValidation.validate(complex, creating: true), {
      MonumentField.district,
    });
    expect(
      MonumentValidation.validate(valid.copyWith(district: ''), creating: true),
      isEmpty,
    );
  });

  test('Türkçe addan kimlik önerisi', () {
    expect(
      MonumentValidation.suggestId('Rüstem Paşa Hamamı'),
      'rustem-pasa-hamami',
    );
    expect(
      MonumentValidation.suggestId('  Çifte Minareli Medrese! '),
      'cifte-minareli-medrese',
    );
    expect(
      MonumentValidation.isValidId(MonumentValidation.suggestId('Gök Medrese')),
      isTrue,
    );
  });
}
