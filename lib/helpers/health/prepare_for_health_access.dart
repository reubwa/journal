import 'package:health/health.dart';

/*https://pub.dev/packages/health*/

Future<List<HealthDataPoint>> PrepareForHealthAccess(DateTime date) async{
  final health = Health();
  await health.configure();

  var types = [
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_AWAKE_IN_BED,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_OUT_OF_BED,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_UNKNOWN,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.WATER
  ];

  bool requested = await health.requestAuthorization(types);

  return health.getHealthDataFromTypes(types: types, startTime: date, endTime: date);
}