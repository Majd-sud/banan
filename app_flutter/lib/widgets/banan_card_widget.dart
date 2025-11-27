import 'package:flutter/material.dart';
import '../theme.dart';

class BananCardWidget extends StatelessWidget {
  final String nationalId;
  final String fullName;
  final String fingerprintNumber;
  final bool isSaved;

  const BananCardWidget({
    super.key,
    required this.nationalId,
    required this.fullName,
    required this.fingerprintNumber,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Banan Card',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: bananDark,
                  ),
                ),
                Icon(Icons.fingerprint, color: bananGreen, size: 32),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              fullName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text('National ID: $nationalId'),
            const SizedBox(height: 4),
            Text('Digital Fingerprint: $fingerprintNumber'),
            const Spacer(),
            const Text(
              'Issue: 2025-11-27',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Text(
              'Expiry: 2030-11-27',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (isSaved) ...[
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.check_circle, size: 16, color: bananGreen),
                  SizedBox(width: 4),
                  Text(
                    'Saved on this device',
                    style: TextStyle(fontSize: 12, color: bananGreen),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
