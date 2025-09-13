class MockApi {
  static Map<String, dynamic> createUser(Map<String, dynamic> profile) {
    return {"user_id": "12345"};
  }

  static Map<String, dynamic> getTodaySession(String userId) {
    return {
      "title": "Full Body Strength",
      "exercises": [
        {"name": "Push Ups", "sets": 3, "reps": 12},
        {"name": "Squats", "sets": 3, "reps": 15},
      ],
    };
  }

  static Map<String, dynamic> predictReadiness() {
    return {"score": 78};
  }
}
