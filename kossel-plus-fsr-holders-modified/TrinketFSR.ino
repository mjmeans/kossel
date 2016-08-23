/*
  Modified version of JohnSL's FSR Trigger for use on the Trinket or ATtiny85
  From: https://github.com/ianlee74/AutoTuningFSRTrigger/blob/master/JohnSL_Trigger_Rewritten_For_Trinket_usingInternalPullUps/JohnSL_Trigger_Rewritten_For_Trinket_usingInternalPullUps.ino
  And from: http://trains.socha.com/2014/07/updating-fsr-endstop-controller-firmware.html

  Loses the following features from his design:
  * Loses LED indicators per FSR
  * Loses Various other IO pins
  
  Retains the following:
  * 1 FSR input (wire the three FSR's in parallel to pin #2)
  * JohnSL's long and short averaging routines
  
  Changes:
  * Changed the LED and endstop/output pin to pins #1 and #0.
  * Changed the ADC chosen to be A1, A2, and A3. (A0 is the reset pin on the
     ATtiny85)

  Changes by Haydn Huntley (haydn.huntley@gmail.com):
  * Ported one of JohnSL's recent improvements, which lowers the response time
     to within ~5ms.
*/
  
// Define the pin that has an LED on it. We have an LED for the FSR to indicate
// when the FSR is triggered. And one power/end stop LED that is on until an
// FSR is triggered.
#define LEDTRIGGER  01
// The end stop output
#define ENDSTOP     00

short fsrPin = 2;               // The pin for the FSR analog input
short fsrAnalogNum = 1;         // Analog pin number to use with analogRead()

#define SHORT_SIZE 8
#define LONG_SIZE 16
#define LONG_INTERVAL (2000 / LONG_SIZE)

unsigned long lastLongTime;              // Last time in millis that we captured a long-term sample
uint16_t longSamples[LONG_SIZE];         // Used to keep a long-term average
uint8_t longIndex = 0;                   // Index of the last long-term sample
uint16_t longAverage = 0;

uint16_t shortSamples[SHORT_SIZE];       // Used to create an average of the most recent samples
uint8_t averageIndex = 0;

void SetOutput(bool triggered)
{
	// Turns on the FSR LED when the FSR is triggered.
    digitalWrite(LEDTRIGGER, triggered);
    // Send the signal for the Z-probe.
    digitalWrite(ENDSTOP, triggered);
}

void InitValues()
{
  for (uint8_t i = 0; i < SHORT_SIZE; i++)
    shortSamples[i] = 0;

  for (uint8_t i = 0; i < LONG_SIZE; i++)
    longSamples[i] = 0;

  lastLongTime = millis();
}

//
// One-time setup for the various I/O ports
//
void setup()
{
  InitValues();

  pinMode(fsrPin, INPUT);
  digitalWrite(fsrPin, HIGH);  // Use the internal pull-up resistors.

  // Set the green combined LED to on so it acts as a power-on indicator.
  // We'll turn it off whenever we trigger the end stop.
  pinMode(LEDTRIGGER, OUTPUT);
  digitalWrite(LEDTRIGGER, HIGH);

  // Set the endstop pin to be an output that is set for NC
  pinMode(ENDSTOP, OUTPUT);
  digitalWrite(ENDSTOP, LOW);
};

//
// Captures a new value once LONG_INTERVAL ms have passed since the last sample.
//
// Returns: The current long-range average
uint16_t UpdateLongSamples(int avg)
{
  // If enough time hasn't passed, just return the last value.
  unsigned long current = millis();
  if (current - lastLongTime <= LONG_INTERVAL)
    return longAverage;

  // Update the long sample with the new value, and then update the long average.
  longSamples[longIndex++] = avg;
  if (longIndex >= LONG_SIZE)
      longIndex = 0;

  uint16_t total = 0;
  for (int i = 0; i < LONG_SIZE; i++)
    total += longSamples[i];
    
  longAverage = total / LONG_SIZE;

  lastLongTime = millis();
  return longAverage;
}

void CheckIfTriggered()
{
  // Calculate the average of the most recent short-term samples.
  uint16_t total = 0;
  for (int i = 0; i < SHORT_SIZE; i++)
  {
    total += shortSamples[i];
  }
  uint16_t avg = total / SHORT_SIZE;
  uint16_t longAverage = UpdateLongSamples(avg);
  uint16_t threshold = 0.85 * longAverage;
  bool triggered = avg < threshold;
  SetOutput(triggered);
}

void loop()
{
  int value = analogRead(fsrAnalogNum);
  shortSamples[averageIndex++] = value;
  if (averageIndex >= SHORT_SIZE)
    averageIndex = 0;
  CheckIfTriggered();
};
