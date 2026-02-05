import 'package:flutter_test/flutter_test.dart';
import 'package:treat_decider/src/domain/entities/team_member.dart';

void main() {
  group('TeamMember', () {
    test('should create a valid TeamMember', () {
      const member = TeamMember(id: '1', name: 'John');

      expect(member.id, '1');
      expect(member.name, 'John');
    });

    test('should support value equality', () {
      const member1 = TeamMember(id: '1', name: 'John');
      const member2 = TeamMember(id: '1', name: 'John');

      expect(member1, equals(member2));
    });

    test('should be different when id differs', () {
      const member1 = TeamMember(id: '1', name: 'John');
      const member2 = TeamMember(id: '2', name: 'John');

      expect(member1, isNot(equals(member2)));
    });

    test('should be different when name differs', () {
      const member1 = TeamMember(id: '1', name: 'John');
      const member2 = TeamMember(id: '1', name: 'Jane');

      expect(member1, isNot(equals(member2)));
    });
  });
}
