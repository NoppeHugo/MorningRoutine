import '../domain/block_model.dart';
 
/// Provides the predefined block templates for the MVP.
class BlockTemplate {
  const BlockTemplate({
    required this.id,
    required this.name,
    required this.emoji,
    required this.defaultDurationMinutes,
  });
 
  final String id;
  final String name;
  final String emoji;
  final int defaultDurationMinutes;
}
 
abstract class BlocksRepository {
  static const List<BlockTemplate> templates = [
    BlockTemplate(id: 'water', name: 'Verre d\'eau', emoji: '💧', defaultDurationMinutes: 2),
    BlockTemplate(id: 'meditation', name: 'Méditation', emoji: '🧘', defaultDurationMinutes: 10),
    BlockTemplate(id: 'journaling', name: 'Journaling', emoji: '📝', defaultDurationMinutes: 5),
    BlockTemplate(id: 'gratitude', name: 'Gratitude', emoji: '🙏', defaultDurationMinutes: 3),
    BlockTemplate(id: 'stretching', name: 'Étirements', emoji: '🤸', defaultDurationMinutes: 10),
    BlockTemplate(id: 'exercise', name: 'Sport', emoji: '💪', defaultDurationMinutes: 20),
    BlockTemplate(id: 'cold_shower', name: 'Douche froide', emoji: '🧊', defaultDurationMinutes: 3),
    BlockTemplate(id: 'skincare', name: 'Skincare', emoji: '✨', defaultDurationMinutes: 5),
    BlockTemplate(id: 'breakfast', name: 'Petit-déjeuner', emoji: '🍳', defaultDurationMinutes: 15),
    BlockTemplate(id: 'reading', name: 'Lecture', emoji: '📚', defaultDurationMinutes: 15),
    BlockTemplate(id: 'affirmations', name: 'Affirmations', emoji: '💬', defaultDurationMinutes: 3),
    BlockTemplate(id: 'breathing', name: 'Respiration', emoji: '🌬️', defaultDurationMinutes: 5),
    BlockTemplate(id: 'visualization', name: 'Visualisation', emoji: '🎯', defaultDurationMinutes: 5),
    BlockTemplate(id: 'walk', name: 'Marche', emoji: '🚶', defaultDurationMinutes: 15),
    BlockTemplate(id: 'planning', name: 'Planning', emoji: '📋', defaultDurationMinutes: 5),
  ];
}
