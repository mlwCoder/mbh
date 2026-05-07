class DashboardItem {
  const DashboardItem({
    required this.id,
    required this.title,
    required this.value,
    this.unit,
  });

  final String id;
  final String title;
  final String value;
  final String? unit;

  factory DashboardItem.fromJson(Object? json) {
    final Map<String, dynamic> map = json as Map<String, dynamic>;
    return DashboardItem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      value: map['value'] as String? ?? '',
      unit: map['unit'] as String?,
    );
  }
}
