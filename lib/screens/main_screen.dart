import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  // ... (existing code)
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ... (existing code)
  @override
  Widget build(BuildContext context) {
    // ... (existing code)
    return Scaffold(
      // ... (existing code)
      body: Column(
        // ... (existing code)
        children: [
          // ... (existing code)
          // 최근 챗봇 이력
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '최근 챗봇 이력',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (recentChats.isEmpty)
                  Center(
                    child: Text(
                      '아직 챗봇 대화 내역이 없습니다',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  )
                else
                  Column(
                    children: recentChats.map((chat) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.blue[400],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                chat,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          // ... (rest of the existing code)
        ],
      ),
    );
  }
} 