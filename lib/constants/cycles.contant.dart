enum CycleType { all, active, completed, draft, upcoming }

CycleType stringToCycleType(String name) {
  name = name.toLowerCase();
  switch (name) {
    case 'all':
      return CycleType.all;
    case 'active':
      return CycleType.active;
    case 'current':
      return CycleType.active;
    case 'upcoming':
      return CycleType.upcoming;
    case 'completed':
      return CycleType.completed;
    case 'draft':
      return CycleType.draft;
    default:
      return CycleType.all;
  }
}
