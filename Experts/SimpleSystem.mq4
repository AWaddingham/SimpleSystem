//+------------------------------------------------------------------+
//|                                                 SimpleSystem.mq4 |
//|                               Copyright 2019, Sevna Software LTD |
//|                                    https://www.SevnaSoftware.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Sevna Software LTD"
#property link      "https://www.SevnaSoftware.com"
#property version   "1.00"
#property strict

extern int StartHour = 9;

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
  // Check if this can just be a global. 
  static bool IsFirstTick = true;
  
  if (ShouldStartExecutingExpertAdvisor())
  {
    if (IsFirstTick)
    {
      IsFirstTick = false;
      
      // Core of the Algorithmic trading system
      
      Alert("First tick of hour.");    
    }
  }
  else 
  {
    IsFirstTick = true;
  }
}

bool ShouldStartExecutingExpertAdvisor()
{
  return CheckCurrentHourIsStartHour();
}

bool CheckCurrentHourIsStartHour()
{
  return Hour() == StartHour;
}
//+------------------------------------------------------------------+
