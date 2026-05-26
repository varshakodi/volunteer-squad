import 'package:cloud_firestore/cloud_firestore.dart';

// ==========================================
// DATA MODELS
// ==========================================

class VolunteerUser {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;
  final List<String> skills;
  final int totalHours;
  final int level;
  final List<String> unlockedBadges;
  final List<String> joinedSquads;
  final DateTime createdAt;
  final String userType; // 'volunteer' or 'organization'

  VolunteerUser({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.skills,
    required this.totalHours,
    required this.level,
    required this.unlockedBadges,
    required this.joinedSquads,
    required this.createdAt,
    required this.userType,
  });

  factory VolunteerUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VolunteerUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      totalHours: data['totalHours'] ?? 0,
      level: data['level'] ?? 1,
      unlockedBadges: List<String>.from(data['unlockedBadges'] ?? []),
      joinedSquads: List<String>.from(data['joinedSquads'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userType: data['userType'] ?? 'volunteer',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'skills': skills,
      'totalHours': totalHours,
      'level': level,
      'unlockedBadges': unlockedBadges,
      'joinedSquads': joinedSquads,
      'createdAt': Timestamp.fromDate(createdAt),
      'userType': userType,
    };
  }
}

class VolunteerEvent {
  final String id;
  final String title;
  final String organizationId;
  final String organizationName;
  final String description;
  final List<String> requiredSkills;
  final DateTime eventDate;
  final String location;
  final int totalSlots;
  final int filledSlots;
  final List<String> registeredVolunteers;
  final String category;
  final int estimatedHours;
  final DateTime createdAt;

  VolunteerEvent({
    required this.id,
    required this.title,
    required this.organizationId,
    required this.organizationName,
    required this.description,
    required this.requiredSkills,
    required this.eventDate,
    required this.location,
    required this.totalSlots,
    required this.filledSlots,
    required this.registeredVolunteers,
    required this.category,
    required this.estimatedHours,
    required this.createdAt,
  });

  factory VolunteerEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VolunteerEvent(
      id: doc.id,
      title: data['title'] ?? '',
      organizationId: data['organizationId'] ?? '',
      organizationName: data['organizationName'] ?? '',
      description: data['description'] ?? '',
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      eventDate: (data['eventDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: data['location'] ?? '',
      totalSlots: data['totalSlots'] ?? 0,
      filledSlots: data['filledSlots'] ?? 0,
      registeredVolunteers: List<String>.from(data['registeredVolunteers'] ?? []),
      category: data['category'] ?? '',
      estimatedHours: data['estimatedHours'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'organizationId': organizationId,
      'organizationName': organizationName,
      'description': description,
      'requiredSkills': requiredSkills,
      'eventDate': Timestamp.fromDate(eventDate),
      'location': location,
      'totalSlots': totalSlots,
      'filledSlots': filledSlots,
      'registeredVolunteers': registeredVolunteers,
      'category': category,
      'estimatedHours': estimatedHours,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class Squad {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final List<String> memberIds;
  final String inviteCode;
  final int totalImpactHours;
  final DateTime createdAt;

  Squad({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.memberIds,
    required this.inviteCode,
    required this.totalImpactHours,
    required this.createdAt,
  });

  factory Squad.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Squad(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      creatorId: data['creatorId'] ?? '',
      memberIds: List<String>.from(data['memberIds'] ?? []),
      inviteCode: data['inviteCode'] ?? '',
      totalImpactHours: data['totalImpactHours'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'creatorId': creatorId,
      'memberIds': memberIds,
      'inviteCode': inviteCode,
      'totalImpactHours': totalImpactHours,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class ImpactRecord {
  final String id;
  final String volunteerId;
  final String eventId;
  final int hoursLogged;
  final DateTime loggedAt;
  final String notes;

  ImpactRecord({
    required this.id,
    required this.volunteerId,
    required this.eventId,
    required this.hoursLogged,
    required this.loggedAt,
    required this.notes,
  });

  factory ImpactRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ImpactRecord(
      id: doc.id,
      volunteerId: data['volunteerId'] ?? '',
      eventId: data['eventId'] ?? '',
      hoursLogged: data['hoursLogged'] ?? 0,
      loggedAt: (data['loggedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'volunteerId': volunteerId,
      'eventId': eventId,
      'hoursLogged': hoursLogged,
      'loggedAt': Timestamp.fromDate(loggedAt),
      'notes': notes,
    };
  }
}

class Badge {
  final String id;
  final String name;
  final String description;
  final int requiredHours;
  final String iconName;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredHours,
    required this.iconName,
  });
}
