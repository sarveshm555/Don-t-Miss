import 'priority.dart';

/// Immutable model representing a single reminder / task in "Don't Miss".
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final int dueHour;
  final int dueMinute;
  final Priority priority;
  final String? url;
  final bool isNotificationEnabled;
  final bool isCompleted;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    required this.dueHour,
    required this.dueMinute,
    this.priority = Priority.medium,
    this.url,
    this.isNotificationEnabled = true,
    this.isCompleted = false,
    required this.createdAt,
  });

  /// Combines [dueDate], [dueHour], and [dueMinute] into a single [DateTime].
  DateTime get fullDueDateTime {
    return DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      dueHour,
      dueMinute,
    );
  }

  /// Checks if this task has passed its due date & time and is not completed.
  bool get isOverdue {
    return !isCompleted && fullDueDateTime.isBefore(DateTime.now());
  }

  /// Generates a positive 32-bit integer identifier for notification scheduling.
  int get notificationId {
    return id.hashCode.abs() % 1000000;
  }

  /// Creates a copy of this task with the given fields replaced.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    int? dueHour,
    int? dueMinute,
    Priority? priority,
    String? url,
    bool? isNotificationEnabled,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueHour: dueHour ?? this.dueHour,
      dueMinute: dueMinute ?? this.dueMinute,
      priority: priority ?? this.priority,
      url: url ?? this.url,
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converts the Task instance to a JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'dueHour': dueHour,
      'dueMinute': dueMinute,
      'priority': priority.name,
      'url': url,
      'isNotificationEnabled': isNotificationEnabled,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Creates a Task instance from a JSON Map.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      dueDate: DateTime.parse(json['dueDate'] as String),
      dueHour: json['dueHour'] as int? ?? 12,
      dueMinute: json['dueMinute'] as int? ?? 0,
      priority: Priority.fromString(json['priority'] as String?),
      url: json['url'] as String?,
      isNotificationEnabled: json['isNotificationEnabled'] as bool? ?? true,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
