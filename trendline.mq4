//+------------------------------------------------------------------+
//|                                                    trendline.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property strict
#property indicator_chart_window
#include <Arrays\ArrayString.mqh>

extern string InpFileName= "history.csv";
struct orderdata
{
   //int               order_id
   //datetime          open_time;
   //double            open_price;
   //datetime          close_time;
   //double            close_price;
   string orderitem;
};

int OnInit()
{
   int file_handle;
   file_handle = FileOpen(InpFileName,FILE_CSV|FILE_READ,';');
   if(file_handle < 1)
   {
      Print("未找到文件，错误", GetLastError());
      return(false);
   }
   
   CArrayString *arr=new CArrayString; 
   //CArrayString *arrAmount=new CArrayString; 
   //orderdata arr[];
   //FileReadArray(file_handle,arr);
   //int size=ArraySize(arr);
   //for(int i=0;i<size;i++)
   //{
     // Print(arr[i]);
   //}
   int str_size;
   string str ;
   int i = 0;
   int index = 0;
   while(!FileIsEnding(file_handle))
   {
      str = FileReadString(file_handle,str_size);
      if(i % 13 == 0)
      {
         
         arr.Add(str);
         index ++;
      }else{
         arr.Update(index-1 , arr[index]+","+str);
         Print(arr[index-1]);
         //Print(index);
      }
      i++;
   }
   
   for(int i=0;i<arr.Total();i++)
   {
      //Print(arr[i]);
   }
   FileClose(file_handle);
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   
   ObjectCreate("#14 104.940 -> 101.828",OBJ_TREND,0,D'2016.07.28 18:04:49',1.31532,D'2016.07.28 20:16:25',1.31644,D'2016.07.28 20:16:25',1.31644);
   ObjectSet("#14 104.940 -> 101.828",OBJPROP_COLOR,Blue);
   ObjectSet("#14 104.940 -> 101.828",OBJPROP_STYLE,STYLE_DOT);
   ObjectSet("#14 104.940 -> 101.828",OBJPROP_BACK,false);
   ObjectSet("#14 104.940 -> 101.828",OBJPROP_RAY,false);
   
   ObjectCreate("#14 sell 0.10 USDJPYecn at 104.940",OBJ_ARROW,0,D'2016.07.28 18:04:49',1.31532);
   ObjectSet("#14 sell 0.10 USDJPYecn at 104.940",OBJPROP_COLOR,Blue);
   ObjectSet("#14 sell 0.10 USDJPYecn at 104.940",OBJPROP_ARROWCODE,1);
   
   ObjectCreate("#14 sell 0.10 USDJPYecn at 104.940 close at 101.828",OBJ_ARROW,0,D'2016.07.28 20:16:25',1.31644);
   ObjectSet("#14 sell 0.10 USDJPYecn at 104.940 close at 101.828",OBJPROP_COLOR,Blue);
   ObjectSet("#14 sell 0.10 USDJPYecn at 104.940 close at 101.828",OBJPROP_ARROWCODE,3);
   
   
   
   return(rates_total);
  }
//+------------------------------------------------------------------+
void GetStringPositions(const int handle,ulong &arr[])
  {
//--- default array size
   int def_size=127;
//--- allocate memory for the array
   ArrayResize(arr,def_size);
//--- string counter
   int i=0;
//--- if this is not the file's end, then there is at least one string
   if(!FileIsEnding(handle))
     {
      arr[i]=FileTell(handle);
      i++;
     }
   else
      return; // the file is empty, exit
//--- define the shift in bytes depending on encoding
   int shift;
   if(FileGetInteger(handle,FILE_IS_ANSI))
      shift=1;
   else
      shift=2;
//--- go through the strings in the loop
   while(1)
     {
      //--- read the string
      FileReadString(handle);
      //--- check for the file end
      if(!FileIsEnding(handle))
        {
         //--- store the next string's position
         arr[i]=FileTell(handle)+shift;
         i++;
         //--- increase the size of the array if it is overflown
         if(i==def_size)
           {
            def_size+=def_size+1;
            ArrayResize(arr,def_size);
           }
        }
      else
         break; // end of the file, exit
     }
//--- define the actual size of the array
   ArrayResize(arr,i);
  }
