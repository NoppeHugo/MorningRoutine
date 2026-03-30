import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/shared_routines_repository.dart';
import '../domain/creator_profile.dart';
import '../domain/shared_routine_template.dart';

@immutable
class SharedRoutinesState {
	const SharedRoutinesState({
		this.allTemplates = const [],
		this.filteredTemplates = const [],
		this.creators = const {},
		this.query = '',
		this.selectedTheme,
		this.selectedLevel,
		this.maxDurationMinutes,
		this.onlyFree = false,
		this.isLoading = true,
	});

	final List<SharedRoutineTemplate> allTemplates;
	final List<SharedRoutineTemplate> filteredTemplates;
	final Map<String, CreatorProfile> creators;
	final String query;
	final RoutineTemplateTheme? selectedTheme;
	final RoutineTemplateLevel? selectedLevel;
	final int? maxDurationMinutes;
	final bool onlyFree;
	final bool isLoading;

	SharedRoutinesState copyWith({
		List<SharedRoutineTemplate>? allTemplates,
		List<SharedRoutineTemplate>? filteredTemplates,
		Map<String, CreatorProfile>? creators,
		String? query,
		Object? selectedTheme = _sentinel,
		Object? selectedLevel = _sentinel,
		Object? maxDurationMinutes = _sentinel,
		bool? onlyFree,
		bool? isLoading,
	}) {
		return SharedRoutinesState(
			allTemplates: allTemplates ?? this.allTemplates,
			filteredTemplates: filteredTemplates ?? this.filteredTemplates,
			creators: creators ?? this.creators,
			query: query ?? this.query,
			selectedTheme: selectedTheme == _sentinel
					? this.selectedTheme
					: selectedTheme as RoutineTemplateTheme?,
			selectedLevel: selectedLevel == _sentinel
					? this.selectedLevel
					: selectedLevel as RoutineTemplateLevel?,
			maxDurationMinutes: maxDurationMinutes == _sentinel
					? this.maxDurationMinutes
					: maxDurationMinutes as int?,
			onlyFree: onlyFree ?? this.onlyFree,
			isLoading: isLoading ?? this.isLoading,
		);
	}

	static const _sentinel = Object();
}

class SharedRoutinesController extends StateNotifier<SharedRoutinesState> {
	SharedRoutinesController(this._repository)
			: super(const SharedRoutinesState()) {
		load();
	}

	final SharedRoutinesRepository _repository;

	Future<void> load() async {
		final templates = _repository.getTemplates();
		final creators = {
			for (final creator in _repository.getCreators()) creator.id: creator,
		};

		state = state.copyWith(
			allTemplates: templates,
			filteredTemplates: templates,
			creators: creators,
			isLoading: false,
		);

		// Async: save to cache for offline access on next app open
		// This doesn't block the UI (no await), just happens in background
		_repository.syncToLocalCache();
	}

	void setQuery(String query) {
		state = state.copyWith(query: query);
		_applyFilters();
	}

	void setTheme(RoutineTemplateTheme? theme) {
		state = state.copyWith(selectedTheme: theme);
		_applyFilters();
	}

	void setLevel(RoutineTemplateLevel? level) {
		state = state.copyWith(selectedLevel: level);
		_applyFilters();
	}

	void setMaxDuration(int? minutes) {
		state = state.copyWith(maxDurationMinutes: minutes);
		_applyFilters();
	}

	void toggleOnlyFree() {
		state = state.copyWith(onlyFree: !state.onlyFree);
		_applyFilters();
	}

	void clearFilters() {
		state = state.copyWith(
			query: '',
			selectedTheme: null,
			selectedLevel: null,
			maxDurationMinutes: null,
			onlyFree: false,
		);
		_applyFilters();
	}

	SharedRoutineTemplate? findTemplateById(String templateId) {
		return _repository.findTemplateById(templateId);
	}

	CreatorProfile? findCreatorById(String creatorId) {
		return _repository.findCreatorById(creatorId);
	}

	void _applyFilters() {
		final filtered = _repository.searchTemplates(
			query: state.query,
			theme: state.selectedTheme,
			level: state.selectedLevel,
			maxDurationMinutes: state.maxDurationMinutes,
			onlyFree: state.onlyFree,
		);

		state = state.copyWith(filteredTemplates: filtered);
	}
}

final sharedRoutinesControllerProvider = StateNotifierProvider<
		SharedRoutinesController,
		SharedRoutinesState>((ref) {
	final repository = ref.watch(sharedRoutinesRepositoryProvider);
	return SharedRoutinesController(repository);
});
