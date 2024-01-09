class UserStatsModel {
  UserStatsModel({
    this.stateDistribution,
    this.priorityDistribution,
    this.createdIssues,
    this.assignedIssues,
    this.completedIssues,
    this.pendingIssues,
    this.subscribedIssues,
    this.presentCycles,
    this.upcomingCycles,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      stateDistribution:
          List<Map<String, dynamic>>.from(json['state_distribution']),
      priorityDistribution:
          List<Map<String, dynamic>>.from(json['priority_distribution']),
      createdIssues: json['created_issues'],
      assignedIssues: json['assigned_issues'],
      completedIssues: json['completed_issues'],
      pendingIssues: json['pending_issues'],
      subscribedIssues: json['subscribed_issues'],
      presentCycles: List<Map<String, dynamic>>.from(json['present_cycles']),
      upcomingCycles: List<Map<String, dynamic>>.from(json['upcoming_cycles']),
    );
  }
  List<Map<String, dynamic>>? stateDistribution;
  List<Map<String, dynamic>>? priorityDistribution;
  int? createdIssues;
  int? assignedIssues;
  int? completedIssues;
  int? pendingIssues;
  int? subscribedIssues;
  List<Map<String, dynamic>>? presentCycles;
  List<Map<String, dynamic>>? upcomingCycles;

  Map<String, dynamic> toJson() {
    return {
      'state_distribution': stateDistribution,
      'priority_distribution': priorityDistribution,
      'created_issues': createdIssues,
      'assigned_issues': assignedIssues,
      'completed_issues': completedIssues,
      'pending_issues': pendingIssues,
      'subscribed_issues': subscribedIssues,
      'present_cycles': presentCycles,
      'upcoming_cycles': upcomingCycles,
    };
  }

  UserStatsModel emptyData() {
    return UserStatsModel(
        stateDistribution: [],
        priorityDistribution: [],
        createdIssues: 0,
        assignedIssues: 0,
        completedIssues: 0,
        pendingIssues: 0,
        subscribedIssues: 0,
        presentCycles: [],
        upcomingCycles: []);
  }
}
