class ProjectDetailModel {
  ProjectDetailModel(
      {this.id,
      this.workspace,
      this.defaultAssignee,
      this.projectLead,
      this.isFavorite,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.description,
      this.descriptionText,
      this.descriptionHtml,
      this.network,
      this.identifier,
      this.emoji,
      this.iconProp,
      this.moduleView,
      this.cycleView,
      this.issueViewsView,
      this.pageView,
      this.inboxView,
      this.coverImage,
      this.createdBy,
      this.updatedBy,
      this.estimate});

  ProjectDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workspace = json['workspace'] != null
        ? Workspace.fromJson(json['workspace'])
        : null;
    defaultAssignee = json['default_assignee'];
    projectLead = json['project_lead'];
    isFavorite = json['is_favorite'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    description = json['description'];
    descriptionText = json['description_text'];
    descriptionHtml = json['description_html'];
    network = json['network'];
    identifier = json['identifier'];
    emoji = json['emoji'];
    iconProp = json['icon_prop'];
    moduleView = json['module_view'];
    cycleView = json['cycle_view'];
    issueViewsView = json['issue_views_view'];
    pageView = json['page_view'];
    inboxView = json['inbox_view'];
    coverImage = json['cover_image'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    estimate = json['estimate'];
  }
  String? id;
  Workspace? workspace;
  Map<String, dynamic>? defaultAssignee;
  Map<String, dynamic>? projectLead;
  bool? isFavorite;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? description;
  String? descriptionText;
  String? descriptionHtml;
  int? network;
  String? identifier;
  String? emoji;
  String? iconProp;
  bool? moduleView;
  bool? cycleView;
  bool? issueViewsView;
  bool? pageView;
  bool? inboxView;
  String? coverImage;
  String? createdBy;
  String? updatedBy;
  String? estimate;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (workspace != null) {
      data['workspace'] = workspace!.toJson();
    }
    data['default_assignee'] = defaultAssignee;
    data['project_lead'] = projectLead;
    data['is_favorite'] = isFavorite;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['name'] = name;
    data['description'] = description;
    data['description_text'] = descriptionText;
    data['description_html'] = descriptionHtml;
    data['network'] = network;
    data['identifier'] = identifier;
    data['emoji'] = emoji;
    data['icon_prop'] = iconProp;
    data['module_view'] = moduleView;
    data['cycle_view'] = cycleView;
    data['issue_views_view'] = issueViewsView;
    data['page_view'] = pageView;
    data['inbox_view'] = inboxView;
    data['cover_image'] = coverImage;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['estimate'] = estimate;
    return data;
  }
}

class Workspace {
  Workspace(
      {this.id,
      this.owner,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.logo,
      this.slug,
      this.companySize,
      this.createdBy,
      this.updatedBy});

  Workspace.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    logo = json['logo'];
    slug = json['slug'];
    companySize = json['company_size'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
  }
  String? id;
  Owner? owner;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? logo;
  String? slug;
  int? companySize;
  String? createdBy;
  String? updatedBy;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['name'] = name;
    data['logo'] = logo;
    data['slug'] = slug;
    data['company_size'] = companySize;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    return data;
  }
}

class Owner {
  Owner(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.avatar,
      this.isBot});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    avatar = json['avatar'];
    isBot = json['is_bot'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? avatar;
  bool? isBot;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['avatar'] = avatar;
    data['is_bot'] = isBot;
    return data;
  }
}
