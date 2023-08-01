class WorkspaceCustomAnalyticsModal {
  int total;
  Map<String, List<DimensionCount>> distribution;
  Extras extras;

  WorkspaceCustomAnalyticsModal({
    required this.total,
    required this.distribution,
    required this.extras,
  });

  factory WorkspaceCustomAnalyticsModal.fromJson(Map<String, dynamic> json) {
    Map<String, List<DimensionCount>> distributionData = {};
    json['distribution'].forEach((key, value) {
      List<DimensionCount> counts = (value as List)
          .map((item) => DimensionCount.fromJson(item))
          .toList();
      distributionData[key] = counts;
    });

    return WorkspaceCustomAnalyticsModal(
      total: json['total'],
      distribution: distributionData,
      extras: Extras.fromJson(json['extras']),
    );
  }
}

class DimensionCount {
  String dimension;
  int count;

  DimensionCount({
    required this.dimension,
    required this.count,
  });

  factory DimensionCount.fromJson(Map<String, dynamic> json) {
    return DimensionCount(
      dimension: json['dimension'] ?? '',
      count: json['count'],
    );
  }
}

class Extras {
  Map<String, dynamic> colors;
  List<AssigneeDetails> assigneeDetails;

  Extras({
    required this.colors,
    required this.assigneeDetails,
  });

  factory Extras.fromJson(Map<String, dynamic> json) {
    List<AssigneeDetails> details = (json['assignee_details'] as List)
        .map((item) => AssigneeDetails.fromJson(item))
        .toList();

    return Extras(
      colors: json['colors'],
      assigneeDetails: details,
    );
  }
}

class AssigneeDetails {
  String? avatar;
  String email;
  String firstName;
  String lastName;

  AssigneeDetails({
    this.avatar,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory AssigneeDetails.fromJson(Map<String, dynamic> json) {
    return AssigneeDetails(
      avatar: json['assignees__avatar'],
      email: json['assignees__email'],
      firstName: json['assignees__first_name'],
      lastName: json['assignees__last_name'],
    );
  }
}
