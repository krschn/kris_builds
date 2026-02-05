import 'package:flutter_test/flutter_test.dart';
import 'package:treat_decider/src/domain/entities/location.dart';

void main() {
  group('Location', () {
    test('should create a valid Location', () {
      const location = Location(id: '1', name: 'Pizza Place');

      expect(location.id, '1');
      expect(location.name, 'Pizza Place');
    });

    test('should support value equality', () {
      const location1 = Location(id: '1', name: 'Pizza Place');
      const location2 = Location(id: '1', name: 'Pizza Place');

      expect(location1, equals(location2));
    });

    test('should be different when id differs', () {
      const location1 = Location(id: '1', name: 'Pizza Place');
      const location2 = Location(id: '2', name: 'Pizza Place');

      expect(location1, isNot(equals(location2)));
    });

    test('should be different when name differs', () {
      const location1 = Location(id: '1', name: 'Pizza Place');
      const location2 = Location(id: '1', name: 'Burger Joint');

      expect(location1, isNot(equals(location2)));
    });
  });
}
