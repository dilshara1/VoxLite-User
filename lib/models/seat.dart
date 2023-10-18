class Seat {
  final int row;
  final int column;
  final bool isAvailable;

  Seat({
    required this.row,
    required this.column,
    required this.isAvailable,
  });

  factory Seat.fromMap(Map<String, dynamic> map) {
    return Seat(
      row: map['row'],
      column: map['column'],
      isAvailable: map['isAvailable'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'row': row,
      'column': column,
      'isAvailable': isAvailable,
    };
  }
}
