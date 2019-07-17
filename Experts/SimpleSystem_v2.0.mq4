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
extern int MA_Period = 100;

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
      
      CloseOpenOrders(ticket);
            
      ticket = CreateOrder();    
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

void CloseOpenOrders(int ticket)
{
  if(OrderSelect(ticket, SELECT_BY_TICKET))
  {
    if(OrderCloseTime() == 0)
    {
      bool orderCloseResult = OrderClose(ticket, Lots, OrderClosePrice(), 10);
      CheckOrderCloseResult(orderCloseResult);
    }
  }
}

int CreateOrder()
{
  int ticket = 0;  
  double ma = iMA(Symbol(), Period(), MA_Period, 0, 0, 0, 1);
  
  if (Open[0] < Open[StartHour])
  {
    ticket = CreateBuyOrder();
  }
  else
  {
  ticket = CreateSellOrder();
  }
  
  return ticket;
}

int CreateBuyOrder()
{
  int ticket = 0;
  double ma = GetMovingAverage();
  
  if(Close[1] < ma)
  {
   ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, (Bid - (StopLoss * Point) * 10), (Bid + (TakeProfit * Point) * 10), "Set by SimpleSystem");
   CheckOrderSendResult(ticket);
  }
  
  return ticket;
}

int CreateSellOrder()
{
  int ticket = 0;
  double ma = GetMovingAverage();

  if(Close[1] > ma)
  {
    ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, (Ask + (StopLoss * Point) * 10), (Ask - (TakeProfit * Point) * 10), "Set by SimpleSystem");
    CheckOrderSendResult(ticket);
  }
  
  return ticket;
}

double GetMovingAverage()
{
  return iMA(Symbol(), Period(), MA_Period, 0, 0, 0, 1);
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

void CheckOrderCloseResult(bool result)
{
  if(result)
  {
    Alert("Order closed successfully.");
  }
  else
  {
    Alert("Failed to close order.");
  }    
}
//+------------------------------------------------------------------+
