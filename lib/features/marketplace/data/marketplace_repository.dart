import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/expert_model.dart';
import '../domain/expert_pack_model.dart';

class MarketplaceRepository {
  static const bool _useMockData = true; // true = données de démo, false = Firestore

  // ── Mock experts ──────────────────────────────────────────────────────────

  static final List<Expert> _mockExperts = [
    const Expert(
      id: 'expert_sophie',
      name: 'Sophie Martin',
      bio:
          'Coach certifiée en mindfulness avec 8 ans d\'expérience. Ancienne consultante reconvertie, Sophie aide des centaines de personnes à retrouver calme et clarté chaque matin.',
      specialty: 'Calme & Focus',
      photoUrl: '',
      rating: 4.9,
      packCount: 2,
    ),
    const Expert(
      id: 'expert_thomas',
      name: 'Thomas Leroy',
      bio:
          'Coach sportif diplômé et spécialiste de la performance matinale. Thomas a accompagné des athlètes professionnels et entrepreneurs pour maximiser leur énergie dès le réveil.',
      specialty: 'Énergie & Forme',
      photoUrl: '',
      rating: 4.8,
      packCount: 2,
    ),
    const Expert(
      id: 'expert_emma',
      name: 'Emma Blanc',
      bio:
          'Nutritionniste et coach de bien-être. Emma combine science de la nutrition et psychologie positive pour des matinées productives et énergisantes.',
      specialty: 'Bien-être & Productivité',
      photoUrl: '',
      rating: 4.7,
      packCount: 2,
    ),
  ];

  // ── Mock packs ────────────────────────────────────────────────────────────

  static final List<ExpertPack> _mockPacks = [
    ExpertPack(
      id: 'pack_morning_power',
      expertId: 'expert_thomas',
      title: 'Morning Power',
      description:
          'Lance ta journée avec une explosion d\'énergie. Cette routine de 30 minutes combine activation physique, hydratation et visualisation pour une matinée au top.',
      category: 'energy',
      isFeatured: true,
      isFree: false,
      storeKitProductId: 'com.morningroutine.pack.morningpower',
      price: 2.99,
      rating: 4.8,
      reviewCount: 124,
      previewBlockCount: 1,
      blocks: [
        PackBlock(
          id: 'b1',
          name: 'Verre d\'eau + citron',
          emoji: '💧',
          durationMinutes: 2,
          tip: 'Boire un grand verre d\'eau avec du citron active le métabolisme et l\'immunité.',
        ),
        PackBlock(
          id: 'b2',
          name: 'Étirements dynamiques',
          emoji: '🤸',
          durationMinutes: 8,
          tip: 'Les étirements dynamiques préparent les articulations mieux que les étirements statiques.',
        ),
        PackBlock(
          id: 'b3',
          name: 'Douche froide 30s',
          emoji: '🚿',
          durationMinutes: 5,
          tip: 'La douche froide libère des endorphines et stimule la dopamine durablement.',
        ),
        PackBlock(
          id: 'b4',
          name: 'Visualisation des objectifs',
          emoji: '🎯',
          durationMinutes: 5,
          tip: 'Visualise ta journée idéale en détail : lieu, actions, émotions.',
        ),
        PackBlock(
          id: 'b5',
          name: 'Petit-déjeuner protéiné',
          emoji: '🥚',
          durationMinutes: 10,
          tip: 'Un petit-déj riche en protéines stabilise la glycémie jusqu\'au déjeuner.',
        ),
      ],
    ),
    ExpertPack(
      id: 'pack_zen_start',
      expertId: 'expert_sophie',
      title: 'Zen Start',
      description:
          'Une routine douce pour commencer la journée en pleine conscience. Parfaite si tu cherches calme et sérénité avant d\'affronter le monde.',
      category: 'calm',
      isFeatured: false,
      isFree: true,
      storeKitProductId: null,
      price: 0.0,
      rating: 4.7,
      reviewCount: 89,
      previewBlockCount: 1,
      blocks: [
        PackBlock(
          id: 'b1',
          name: 'Respiration 4-7-8',
          emoji: '🌬️',
          durationMinutes: 5,
          tip: 'Inspire 4s, retiens 7s, expire 8s. Active le système nerveux parasympathique.',
        ),
        PackBlock(
          id: 'b2',
          name: 'Méditation guidée',
          emoji: '🧘',
          durationMinutes: 10,
          tip: 'Concentre-toi sur les sensations physiques, non sur les pensées.',
        ),
        PackBlock(
          id: 'b3',
          name: 'Journal de gratitude',
          emoji: '📓',
          durationMinutes: 5,
          tip: 'Note 3 choses précises pour lesquelles tu es reconnaissant·e ce matin.',
        ),
      ],
    ),
    ExpertPack(
      id: 'pack_focus_flow',
      expertId: 'expert_emma',
      title: 'Focus Flow',
      description:
          'Prépare ton cerveau pour une journée de travail profond. Cette routine active les zones cérébrales liées à la concentration et à la créativité.',
      category: 'focus',
      isFeatured: false,
      isFree: false,
      storeKitProductId: 'com.morningroutine.pack.focusflow',
      price: 1.99,
      rating: 4.6,
      reviewCount: 67,
      previewBlockCount: 1,
      blocks: [
        PackBlock(
          id: 'b1',
          name: 'Café + lecture 10 min',
          emoji: '☕',
          durationMinutes: 10,
          tip: 'Évite les réseaux sociaux. Lis quelque chose d\'inspirant ou éducatif.',
        ),
        PackBlock(
          id: 'b2',
          name: 'Top 3 priorités du jour',
          emoji: '📋',
          durationMinutes: 5,
          tip: 'Identifie la tâche la plus impactante. C\'est elle que tu feras en premier.',
        ),
        PackBlock(
          id: 'b3',
          name: 'Session de travail profond',
          emoji: '🔬',
          durationMinutes: 25,
          tip: 'Mode avion activé. Aucune interruption pendant cette session Pomodoro.',
        ),
      ],
    ),
    ExpertPack(
      id: 'pack_athletic_am',
      expertId: 'expert_thomas',
      title: 'Athletic AM',
      description:
          'La routine des athlètes pour une forme physique optimale. Conçue pour maximiser les performances sportives et la récupération musculaire.',
      category: 'fitness',
      isFeatured: false,
      isFree: false,
      storeKitProductId: 'com.morningroutine.pack.athleticam',
      price: 3.99,
      rating: 4.9,
      reviewCount: 203,
      previewBlockCount: 1,
      blocks: [
        PackBlock(
          id: 'b1',
          name: 'Mobilité articulaire',
          emoji: '🔄',
          durationMinutes: 5,
          tip: 'Commencer par les chevilles, genoux, hanches, épaules, nuque.',
        ),
        PackBlock(
          id: 'b2',
          name: 'Circuit HIIT',
          emoji: '🏃',
          durationMinutes: 20,
          tip: '30s d\'effort max / 15s récup × 8. Tu dois être incapable de parler.',
        ),
        PackBlock(
          id: 'b3',
          name: 'Gainage & core',
          emoji: '💪',
          durationMinutes: 10,
          tip: 'Planche, side plank, bird-dog. La ceinture abdominale protège tout.',
        ),
        PackBlock(
          id: 'b4',
          name: 'Récupération & nutrition',
          emoji: '🥤',
          durationMinutes: 10,
          tip: 'Shake protéiné dans les 30 min post-entraînement pour maximiser la synthèse musculaire.',
        ),
      ],
    ),
    ExpertPack(
      id: 'pack_productive_mind',
      expertId: 'expert_emma',
      title: 'Productive Mind',
      description:
          'La routine scientifiquement optimisée pour la productivité. Combine neurosciences et habitudes des top performers mondiaux.',
      category: 'productivity',
      isFeatured: false,
      isFree: false,
      storeKitProductId: 'com.morningroutine.pack.productivemind',
      price: 2.99,
      rating: 4.7,
      reviewCount: 156,
      previewBlockCount: 1,
      blocks: [
        PackBlock(
          id: 'b1',
          name: 'Pas d\'écran 30 min',
          emoji: '📵',
          durationMinutes: 2,
          tip: 'Les notifications le matin mettent le cerveau en mode réactif. Garde-le proactif.',
        ),
        PackBlock(
          id: 'b2',
          name: 'Morning pages',
          emoji: '✍️',
          durationMinutes: 15,
          tip: 'Écris 3 pages de flux de conscience. Vide le mental pour mieux se concentrer.',
        ),
        PackBlock(
          id: 'b3',
          name: 'Weekly review express',
          emoji: '📊',
          durationMinutes: 8,
          tip: 'Revois tes objectifs de la semaine. 2 min de review = 20 min économisés.',
        ),
        PackBlock(
          id: 'b4',
          name: 'MIT (Most Important Task)',
          emoji: '🏆',
          durationMinutes: 5,
          tip: 'Une seule tâche. Si tu ne fais que ça aujourd\'hui, tu as réussi ta journée.',
        ),
      ],
    ),
    ExpertPack(
      id: 'pack_deep_calm',
      expertId: 'expert_sophie',
      title: 'Deep Calm',
      description:
          'Pour les matinées difficiles et les périodes de stress intense. Cette routine ramène le calme profond et la clarté mentale en moins de 20 minutes.',
      category: 'calm',
      isFeatured: false,
      isFree: false,
      storeKitProductId: 'com.morningroutine.pack.deepcalm',
      price: 1.99,
      rating: 4.8,
      reviewCount: 98,
      previewBlockCount: 1,
      blocks: [
        PackBlock(
          id: 'b1',
          name: 'Body scan allongé',
          emoji: '🛏️',
          durationMinutes: 8,
          tip: 'Parcours ton corps des pieds à la tête. Relâche chaque tension sans jugement.',
        ),
        PackBlock(
          id: 'b2',
          name: 'Cohérence cardiaque',
          emoji: '💓',
          durationMinutes: 5,
          tip: '5 respirations par minute : inspire 6s, expire 6s. Réduit le cortisol de 23%.',
        ),
        PackBlock(
          id: 'b3',
          name: 'Intention du jour',
          emoji: '🌱',
          durationMinutes: 3,
          tip: 'Pose une intention émotionnelle : "Aujourd\'hui je choisis la sérénité".',
        ),
        PackBlock(
          id: 'b4',
          name: 'Thé chaud & silence',
          emoji: '🍵',
          durationMinutes: 5,
          tip: 'Boire lentement, sans distractions. Ce moment t\'appartient.',
        ),
      ],
    ),
  ];

  // ── Public API ────────────────────────────────────────────────────────────

  Future<List<ExpertPack>> getFeaturedPacks() async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockPacks.where((p) => p.isFeatured).toList();
    }
    // TODO: Firestore implementation
    // final snapshot = await FirebaseFirestore.instance
    //     .collection('packs')
    //     .where('isFeatured', isEqualTo: true)
    //     .get();
    // return snapshot.docs
    //     .map((d) => ExpertPack.fromFirestore(d.data(), d.id))
    //     .toList();
    return [];
  }

  Future<List<ExpertPack>> getPacksByCategory(String? category) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (category == null) return List.from(_mockPacks);
      return _mockPacks.where((p) => p.category == category).toList();
    }
    // TODO: Firestore implementation
    return [];
  }

  Future<ExpertPack> getPackById(String id) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 150));
      return _mockPacks.firstWhere((p) => p.id == id);
    }
    // TODO: Firestore implementation
    // final doc = await FirebaseFirestore.instance
    //     .collection('packs')
    //     .doc(id)
    //     .get();
    // return ExpertPack.fromFirestore(doc.data()!, doc.id);
    throw UnimplementedError('Firestore not configured');
  }

  Future<Expert> getExpertById(String id) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 150));
      return _mockExperts.firstWhere((e) => e.id == id);
    }
    // TODO: Firestore implementation
    throw UnimplementedError('Firestore not configured');
  }

  Future<List<ExpertPack>> getUserPurchases(String userId) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      return _mockPacks.where((p) => p.isUnlocked).toList();
    }
    // TODO: Firestore implementation
    // final snapshot = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .collection('purchases')
    //     .get();
    // final packIds = snapshot.docs.map((d) => d.id).toList();
    // return Future.wait(packIds.map(getPackById));
    return [];
  }
}

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>(
  (ref) => MarketplaceRepository(),
);
