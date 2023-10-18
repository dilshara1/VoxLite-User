import 'package:flutter/material.dart';
import 'package:voxliteapp/models/seat.dart';

class SeatLayout extends StatelessWidget {
  final List<Seat> seats;
  final Function(Seat) onSeatSelected;

  SeatLayout({required this.seats, required this.onSeatSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: seats.length,
      itemBuilder: (context, index) {
        Seat seat = seats[index];
        return GestureDetector(
          onTap: () {
            if (seat.isAvailable) {
              onSeatSelected(seat);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: seat.isAvailable
                  ? const Color.fromARGB(255, 75, 39, 39)
                  : Colors.grey,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: seat.isAvailable ? Colors.black : Colors.grey,
                width: 2.0,
              ),
            ),
            child: Center(
              child: Text(
                '${seat.row}${seat.column}',
                style: TextStyle(
                  color: seat.isAvailable ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
