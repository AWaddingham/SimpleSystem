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
extern double Lots = 1.0;
extern int TakeProfit = 40;
extern int StopLoss = 40;

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
  // Check if this can just be a global. 
  static bool IsFirstTick = true;
  static int ticket = 0;
  
  if (ShouldStartExecutingExpertAdvisor())
  {
    if (IsFirstTick)
    {
      IsFirstTick = false;
      
      if (Open[0] < Open[StartHour])
      {
        ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Bid - (StopLoss * Point), Bid + (TakeProfit * Point), "Set by SimpleSystem");
        CheckOrderSendResult(ticket);
      }
      else
      {
        ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, Ask + (StopLoss * Point), Ask - (TakeProfit * Point), "Set by SimpleSystem");
        CheckOrderSendResult(ticket);
      }    
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

void CheckOrderSendResult(int result)
{
    switch(result)
    {
      case -1:
        Alert("Order failed.");
      break;
      default:
        Alert("Order Ticket Number: ", result);
    }
}
//+------------------------------------------------------------------+
