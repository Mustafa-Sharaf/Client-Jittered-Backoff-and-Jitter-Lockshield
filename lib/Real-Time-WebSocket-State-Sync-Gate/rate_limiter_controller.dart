import 'dart:async';
import 'package:get/get.dart';

class RateLimiterController extends GetxController {
  // Maximum capacity metrics for the Token Bucket mechanism
  final int maxTokens = 5;

  // Reactive observable tracking current tokens available inside the bucket
  var currentTokens = 5.obs;

  // Continuous trace logger stream for the terminal UI viewport
  var gatewayLogs = <String>[].obs;

  // Refill daemon timer to reconstruct depleted tokens periodically
  Timer? _refillTimer;

  @override
  void onInit() {
    super.onInit();
    _startTokenRefillDaemon();
  }

  // Background daemon loop that replenishes tokens to maintain system resilience
  void _startTokenRefillDaemon() {
    _refillTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentTokens.value < maxTokens) {
        currentTokens.value++;
        _addLog("⏳ [Refill Engine]: Generated +1 Token. Bucket Sync status: (${currentTokens.value}/$maxTokens)");
      }
    });
  }

  // Core Gateway Ingress check implementing the Token Bucket Rate Limiting logic
  bool processStateSyncTransaction() {
    // Condition 1: Token available -> Allow transaction pass and mutate packet state
    if (currentTokens.value > 0) {
      currentTokens.value--;
      _addLog("🟢 [Gate Clearance]: Transaction approved. Token consumed. Available: ${currentTokens.value}");
      return true;
    }
    // Condition 2: Bucket exhausted -> Execute Load Shedding to drop malicious overflow traffic
    else {
      _addLog("🚨 [LOAD SHEDDING]: Request dropped via Rate Limiter Gate! DDoS mitigation triggered.");
      return false;
    }
  }

  // Formats tracking markers and injects rows in an inverse chronological layout
  void _addLog(String msg) {
    final time = DateTime.now().toString().split(' ')[1].substring(0, 8);
    String formattedLog = "[$time] $msg";
    gatewayLogs.insert(0, formattedLog);
    print("SYNC_GATE_LOG: $formattedLog");
    if (gatewayLogs.length > 25) gatewayLogs.removeLast(); // Retain RAM efficiency
  }

  // Clears live simulation traces and re-establishes default infrastructure states
  void resetGateMetrics() {
    currentTokens.value = maxTokens;
    gatewayLogs.clear();
    _addLog("♻️ [Gateway Reset]: Token bucket capacity restored to $maxTokens.");
  }

  @override
  void onClose() {
    _refillTimer?.cancel(); // Safe runtime teardown hook to avoid continuous background leaks
    super.onClose();
  }
}