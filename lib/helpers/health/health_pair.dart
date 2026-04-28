import 'package:flutter/material.dart';

Icon HealthPointToIcon(String description){
  switch(description){
    case "HEART_RATE" || "RESTING_HEART_RATE":
      return Icon(Icons.monitor_heart);
    case "STEPS" || "activity-WALK":
      return Icon(Icons.directions_walk);
    case "WEIGHT":
      return Icon(Icons.monitor_weight);
    case "DISTANCE_DELTA":
      return Icon(Icons.social_distance);
    case "SLEEP_ASLEEP" || "SLEEP_AWAKE" || "SLEEP_AWAKE_IN_BED" || "SLEEP_DEEP" || "SLEEP_LIGHT" || "SLEEP_OUT_OF_BED" || "SLEEP_REM" || "SLEEP_UNKNOWN" || "SLEEP_SESSION":
      return Icon(Icons.bed);
    case "WATER":
      return Icon(Icons.water_drop);
    case "activity":
      return Icon(Icons.fitness_center);
    default:
      return Icon(Icons.close);
  }
}

String HealthPointToQuantity(String point){
  switch (point){
    case "HEART_RATE" || "RESTING_HEART_RATE":
      return "b.p.m.";
    case "STEPS":
      return "steps";
    case "WEIGHT":
      return "kg";
    case "DISTANCE_DELTA":
      return "m";
    case "SLEEP_ASLEEP" || "SLEEP_AWAKE" || "SLEEP_AWAKE_IN_BED" || "SLEEP_DEEP" || "SLEEP_LIGHT" || "SLEEP_OUT_OF_BED" || "SLEEP_REM" || "SLEEP_UNKNOWN" || "SLEEP_SESSION":
      return "mins";
    case "WATER":
      return "l";
    default:
      return "Unknown";
  }
}