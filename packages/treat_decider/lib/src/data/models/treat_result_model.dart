import '../../domain/entities/location.dart';
import '../../domain/entities/team_member.dart';
import '../../domain/entities/treat_result.dart';

class TreatResultModel extends TreatResult {
  const TreatResultModel({
    required super.id,
    required super.date,
    required super.winner,
    required super.location,
    required super.teamMembers,
    required super.createdAt,
  });

  factory TreatResultModel.fromEntity(TreatResult entity) {
    return TreatResultModel(
      id: entity.id,
      date: entity.date,
      winner: entity.winner,
      location: entity.location,
      teamMembers: entity.teamMembers,
      createdAt: entity.createdAt,
    );
  }

  factory TreatResultModel.fromJson(Map<String, dynamic> json) {
    final winnerJson = json['winner'] as Map<String, dynamic>;
    final locationJson = json['location'] as Map<String, dynamic>;
    final teamMembersJson = json['teamMembers'] as List<dynamic>;

    return TreatResultModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      winner: TeamMember(
        id: winnerJson['id'] as String,
        name: winnerJson['name'] as String,
      ),
      location: Location(
        id: locationJson['id'] as String,
        name: locationJson['name'] as String,
      ),
      teamMembers: teamMembersJson.map((m) {
        final memberJson = m as Map<String, dynamic>;
        return TeamMember(
          id: memberJson['id'] as String,
          name: memberJson['name'] as String,
        );
      }).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'winner': {'id': winner.id, 'name': winner.name},
      'location': {'id': location.id, 'name': location.name},
      'teamMembers': teamMembers
          .map((m) => {'id': m.id, 'name': m.name})
          .toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
