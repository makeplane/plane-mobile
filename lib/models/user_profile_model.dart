import 'dart:convert';

class UserProfile {
  UserProfile({
    required this.id,
    required this.lastLogin,
    required this.username,
    required this.displayName,
    required this.mobileNumber,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.dateJoined,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLocation,
    required this.createdLocation,
    required this.isSuperuser,
    required this.isManaged,
    required this.isPasswordExpired,
    required this.isActive,
    required this.isStaff,
    required this.isEmailVerified,
    required this.isPasswordAutoset,
    required this.isOnboarded,
    required this.token,
    required this.billingAddressCountry,
    required this.billingAddress,
    required this.hasBillingAddress,
    required this.userTimezone,
    required this.lastActive,
    required this.lastLoginTime,
    required this.lastLogoutTime,
    required this.lastLoginIp,
    required this.lastLogoutIp,
    required this.lastLoginMedium,
    required this.lastLoginUagent,
    required this.tokenUpdatedAt,
    required this.lastWorkspaceId,
    required this.myissuesprop,
    required this.role,
    required this.isBot,
    required this.theme,
    required this.groups,
    required this.userPermissions,
    required this.onboardingStep,
    required this.workspace,
  });
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
        id: map['id'],
        lastLogin: map['last_login'],
        username: map['username'],
        mobileNumber: map['mobile_number'],
        email: map['email'],
        firstName: map['first_name'],
        lastName: map['last_name'],
        avatar: map['avatar'],
        dateJoined: map['date_joined'],
        createdAt: map['created_at'],
        updatedAt: map['updated_at'],
        lastLocation: map['last_location'],
        createdLocation: map['created_location'],
        isSuperuser: map['is_superuser'],
        isManaged: map['is_managed'],
        isPasswordExpired: map['is_password_expired'],
        isActive: map['is_active'],
        isStaff: map['is_staff'],
        isEmailVerified: map['is_email_verified'],
        isPasswordAutoset: map['is_password_autoset'],
        isOnboarded: map['is_onboarded'],
        token: map['access_token'],
        billingAddressCountry: map['billing_address_country'],
        billingAddress: map['billing_address'],
        hasBillingAddress: map['has_billing_address'],
        userTimezone: map['user_timezone'],
        lastActive: map['last_active'],
        lastLoginTime: map['last_login_time'],
        lastLogoutTime: map['last_logout_time'],
        lastLoginIp: map['last_login_ip'],
        lastLogoutIp: map['last_logout_ip'],
        lastLoginMedium: map['last_login_medium'],
        lastLoginUagent: map['last_login_uagent'],
        tokenUpdatedAt: map['token_updated_at'],
        lastWorkspaceId: map['last_workspace_id'],
        myissuesprop: map['my_issues_prop'],
        role: map['role'],
        isBot: map['is_bot'],
        theme: map['theme'],
        groups: map['groups'],
        userPermissions: map['user_permissions'],
        onboardingStep: map['onboarding_step'],
        workspace: map['workspace'],
        displayName: map['display_name']);
  }
  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);
  final String? id;
  final String? lastLogin;
  final String? username;
  final String? displayName;
  final String? mobileNumber;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String? dateJoined;
  final String? createdAt;
  final String? updatedAt;
  final String? lastLocation;
  final String? createdLocation;
  final bool? isSuperuser;
  final bool? isManaged;
  final bool? isPasswordExpired;
  final bool? isActive;
  final bool? isStaff;
  final bool? isEmailVerified;
  final bool? isPasswordAutoset;
  bool? isOnboarded;
  final String? token;
  final String? billingAddressCountry;
  final String? billingAddress;
  final bool? hasBillingAddress;
  final String? userTimezone;
  final String? lastActive;
  final String? lastLoginTime;
  final String? lastLogoutTime;
  final String? lastLoginIp;
  final String? lastLogoutIp;
  final String? lastLoginMedium;
  final String? lastLoginUagent;
  final String? tokenUpdatedAt;
  String? lastWorkspaceId;
  final String? myissuesprop;
  final String? role;
  final bool? isBot;
  final Map? theme;
  final List<dynamic>? groups;
  final List<dynamic>? userPermissions;
  final Map<String, dynamic>? onboardingStep;
  final Map<String, dynamic>? workspace;

  static UserProfile initialize(
      {String? firstName,
      String? lastName,
      String? id,
      String? lastWorkspaceId}) {
    return UserProfile(
        id: id ?? '',
        lastLogin: '',
        username: '',
        displayName: '',
        mobileNumber: '',
        email: '',
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        avatar: '',
        dateJoined: '',
        createdAt: '',
        updatedAt: '',
        lastLocation: '',
        createdLocation: '',
        isSuperuser: false,
        isManaged: false,
        isPasswordExpired: false,
        isActive: false,
        isStaff: false,
        isEmailVerified: false,
        isPasswordAutoset: false,
        isOnboarded: false,
        token: '',
        billingAddressCountry: '',
        billingAddress: '',
        hasBillingAddress: false,
        userTimezone: '',
        lastActive: '',
        lastLoginTime: '',
        lastLogoutTime: '',
        lastLoginIp: '',
        lastLogoutIp: '',
        lastLoginMedium: '',
        lastLoginUagent: '',
        tokenUpdatedAt: '',
        lastWorkspaceId: lastWorkspaceId ?? '',
        myissuesprop: '',
        role: null,
        isBot: false,
        theme: {},
        groups: [],
        userPermissions: [],
        onboardingStep: {},
        workspace: {});
  }

  UserProfile copyWith({
    String? id,
    String? lastLogin,
    String? username,
    String? displayName,
    String? mobileNumber,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
    String? dateJoined,
    String? createdAt,
    String? updatedAt,
    String? lastLocation,
    String? createdLocation,
    bool? isSuperuser,
    bool? isManaged,
    bool? isPasswordExpired,
    bool? isActive,
    bool? isStaff,
    bool? isEmailVerified,
    bool? isPasswordAutoset,
    bool? isOnboarded,
    String? token,
    String? billingAddressCountry,
    String? billingAddress,
    bool? hasBillingAddress,
    String? userTimezone,
    String? lastActive,
    String? lastLoginTime,
    String? lastLogoutTime,
    String? lastLoginIp,
    String? lastLogoutIp,
    String? lastLoginMedium,
    String? lastLoginUagent,
    String? tokenUpdatedAt,
    String? lastWorkspaceId,
    String? myissuesprop,
    String? role,
    bool? isBot,
    Map? theme,
    List<dynamic>? groups,
    List<dynamic>? userPermissions,
    Map<String, dynamic>? onboardingStep,
    Map<String, dynamic>? workspace,
  }) {
    return UserProfile(
        id: id ?? this.id,
        lastLogin: lastLogin ?? this.lastLogin,
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        avatar: avatar ?? this.avatar,
        dateJoined: dateJoined ?? this.dateJoined,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastLocation: lastLocation ?? this.lastLocation,
        createdLocation: createdLocation ?? this.createdLocation,
        isSuperuser: isSuperuser ?? this.isSuperuser,
        isManaged: isManaged ?? this.isManaged,
        isPasswordExpired: isPasswordExpired ?? this.isPasswordExpired,
        isActive: isActive ?? this.isActive,
        isStaff: isStaff ?? this.isStaff,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        isPasswordAutoset: isPasswordAutoset ?? this.isPasswordAutoset,
        isOnboarded: isOnboarded ?? this.isOnboarded,
        token: token ?? this.token,
        billingAddressCountry:
            billingAddressCountry ?? this.billingAddressCountry,
        billingAddress: billingAddress ?? this.billingAddress,
        hasBillingAddress: hasBillingAddress ?? this.hasBillingAddress,
        userTimezone: userTimezone ?? this.userTimezone,
        lastActive: lastActive ?? this.lastActive,
        lastLoginTime: lastLoginTime ?? this.lastLoginTime,
        lastLogoutTime: lastLogoutTime ?? this.lastLogoutTime,
        lastLoginIp: lastLoginIp ?? this.lastLoginIp,
        lastLogoutIp: lastLogoutIp ?? this.lastLogoutIp,
        lastLoginMedium: lastLoginMedium ?? this.lastLoginMedium,
        lastLoginUagent: lastLoginUagent ?? this.lastLoginUagent,
        tokenUpdatedAt: tokenUpdatedAt ?? this.tokenUpdatedAt,
        lastWorkspaceId: lastWorkspaceId ?? this.lastWorkspaceId,
        myissuesprop: myissuesprop ?? this.myissuesprop,
        role: role ?? this.role,
        isBot: isBot ?? this.isBot,
        theme: theme ?? this.theme,
        groups: groups ?? this.groups,
        userPermissions: userPermissions ?? this.userPermissions,
        onboardingStep: onboardingStep ?? this.onboardingStep,
        workspace: workspace ?? this.workspace);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'last_login': lastLogin,
      'username': username,
      'display_name': displayName,
      'mobile_number': mobileNumber,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
      'date_joined': dateJoined,
      'created_at': createdAt,
      'updatedAt': updatedAt,
      'last_location': lastLocation,
      'created_location': createdLocation,
      'is_superuser': isSuperuser,
      'is_managed': isManaged,
      'is_password_expired': isPasswordExpired,
      'is_active': isActive,
      'is_staff': isStaff,
      'is_email_verified': isEmailVerified,
      'is_password_autoset': isPasswordAutoset,
      'is_onboarded': isOnboarded,
      'token': token,
      'billing_address_country': billingAddressCountry,
      'billing_address': billingAddress,
      'has_billing_address': hasBillingAddress,
      'user_timezone': userTimezone,
      'last_active': lastActive,
      'last_login_time': lastLoginTime,
      'last_logout_time': lastLogoutTime,
      'last_login_ip': lastLoginIp,
      'last_logout_ip': lastLogoutIp,
      'last_login_medium': lastLoginMedium,
      'last_login_uagent': lastLoginUagent,
      'token_updated_at': tokenUpdatedAt,
      'last_workspace_id': lastWorkspaceId,
      'my_issues_prop': myissuesprop,
      'role': role,
      'is_bot': isBot,
      'theme': theme,
      'groups': groups,
      'user_permissions': userPermissions,
      'onboarding_step': onboardingStep,
      'workspace': workspace
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserProfile(id: $id, last_login: $lastLogin, username: $username, displayName: $displayName, mobile_number: $mobileNumber, email: $email, first_name: $firstName, last_name: $lastName, avatar: $avatar, date_joined: $dateJoined, created_at: $createdAt, updated_at: $updatedAt, last_location: $lastLocation, created_location: $createdLocation, is_superuser: $isSuperuser, is_managed: $isManaged, is_password_expired: $isPasswordExpired, is_active: $isActive, is_staff: $isStaff, is_email_verified: $isEmailVerified, is_password_autoset: $isPasswordAutoset, is_onboarded: $isOnboarded, token: $token, billing_address_country: $billingAddressCountry, billing_address: $billingAddress, has_billing_address: $hasBillingAddress, user_timezone: $userTimezone, last_active: $lastActive, last_login_time: $lastLoginTime, last_logout_time: $lastLogoutTime, last_login_ip: $lastLoginIp, last_logout_ip: $lastLogoutIp, last_login_medium: $lastLoginMedium, last_login_uagent: $lastLoginUagent, token_updated_at: $tokenUpdatedAt, last_workspace_id: $lastWorkspaceId, my_issues_prop: $myissuesprop, role: $role, is_bot: $isBot, theme: $theme, groups: $groups, user_permissions: $userPermissions, onboarding_step: $onboardingStep, workspaceL $workspace)';
  }
}
