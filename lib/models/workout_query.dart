class WorkoutQuery {
  final String search;
  final int? trainerId;
  final int? minIntensity;
  final int? maxDuration;
  final String sortField;
  final bool sortAscending;
  final int page;
  final int size;
  final bool includeDeleted;

  const WorkoutQuery({
    this.search = '',
    this.trainerId,
    this.minIntensity,
    this.maxDuration,
    this.sortField = 'title',
    this.sortAscending = true,
    this.page = 1,
    this.size = 10,
    this.includeDeleted = false,
  });

  static const _unset = Object();

  WorkoutQuery copyWith({
    String? search,
    Object? trainerId = _unset,
    Object? minIntensity = _unset,
    Object? maxDuration = _unset,
    String? sortField,
    bool? sortAscending,
    int? page,
    int? size,
    bool? includeDeleted,
  }) {
    return WorkoutQuery(
      search: search ?? this.search,
      trainerId: trainerId == _unset ? this.trainerId : trainerId as int?,
      minIntensity: minIntensity == _unset
          ? this.minIntensity
          : minIntensity as int?,
      maxDuration: maxDuration == _unset
          ? this.maxDuration
          : maxDuration as int?,
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
      page: page ?? 1,
      size: size ?? this.size,
      includeDeleted: includeDeleted ?? this.includeDeleted,
    );
  }
}
