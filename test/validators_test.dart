import 'package:flutter_test/flutter_test.dart';
import 'package:dorama_nest/core/validators.dart';
import 'package:dorama_nest/data/services/catalog_data.dart';

void main() {
  group('Form validation', () {
    test('empty email is rejected',
        () => expect(NestValidators.email(''), isNotNull));
    test('malformed email is rejected',
        () => expect(NestValidators.email('mia.example.com'), isNotNull));
    test('valid email passes',
        () => expect(NestValidators.email('mia@example.com'), isNull));
    test('empty password is rejected',
        () => expect(NestValidators.password(''), isNotNull));
    test('short password is rejected',
        () => expect(NestValidators.password('12345'), isNotNull));
    test('valid password passes',
        () => expect(NestValidators.password('secret123'), isNull));
    test(
        'blank review is rejected',
        () => expect(
            NestValidators.requiredText('  ', name: 'Отзыв'), isNotNull));
  });

  test('catalog has real entries with unique ids', () {
    final ids = CatalogData.dramas.map((e) => e.id).toList();
    expect(ids.length, greaterThanOrEqualTo(7));
    expect(ids.toSet().length, ids.length);
    expect(CatalogData.byId('hidden-love').title, 'Hidden Love');
  });
}
