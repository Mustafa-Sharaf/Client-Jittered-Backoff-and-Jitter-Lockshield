import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskone/Real-Time-WebSocket-State-Sync-Gate/rate_limiter_controller.dart';
import '../Widget/CustomAppBar.dart';

class RateLimiterScreen extends StatelessWidget {
  final controller = Get.put(RateLimiterController());

  RateLimiterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "WebSocket State Sync Gate",
        backgroundColor: Color(0xff0aa87d),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff0aa87d),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white),
              ),
              child: Column(
                children: [
                  Text(
                    "🪣 Token Bucket Real-Time Capacity",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(controller.maxTokens, (index) {
                        bool isAvailable =
                            index < controller.currentTokens.value;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? Colors.greenAccent.withOpacity(0.2)
                                : Colors.redAccent.withOpacity(0.1),
                            border: Border.all(
                              color: isAvailable
                                  ? Colors.greenAccent
                                  : Colors.redAccent.withOpacity(0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isAvailable ? Icons.vpn_key : Icons.lock,
                            color: isAvailable
                                ? Colors.greenAccent
                                : Colors.redAccent.withOpacity(0.4),
                            size: 20,
                          ),
                        );
                      }),
                    );
                  }),
                  SizedBox(height: 12),
                  Obx(
                    () => Text(
                      "Available Tokens: ${controller.currentTokens.value} / ${controller.maxTokens}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0aa87d),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  onPressed: () {
                    controller.processStateSyncTransaction();
                  },
                  icon: Icon(Icons.sync, color: Colors.white),
                  label: Text(
                    "Sync State (Spam Here)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onPressed: () => controller.resetGateMetrics(),
                  icon: Icon(Icons.refresh, color: Colors.white),
                  label: Text("Reset", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),

            SizedBox(height: 10),
            Text(
              "💡 Tip: Click the Sync button rapidly to trigger DDoS Load Shedding!",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Divider(color: Colors.white12, height: 30),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📟 Sync Gate Security Terminal Stream:",
                      style: TextStyle(
                        color: Color(0xff0aa87d),
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: Obx(
                        () => ListView.builder(
                          itemCount: controller.gatewayLogs.length,
                          itemBuilder: (context, index) {
                            String log = controller.gatewayLogs[index];
                            Color logColor = log.contains("🚨")
                                ? Colors.redAccent
                                : (log.contains("🟢")
                                      ? Colors.greenAccent
                                      : Colors.white60);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                              child: Text(
                                log,
                                style: TextStyle(
                                  color: logColor,
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
