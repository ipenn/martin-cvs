#property strict
#property indicator_chart_window
#include <Arrays\ArrayString.mqh>

extern string InpFileName= "history.csv";


int OnInit()
{
   int file_handle;
   file_handle = FileOpen(InpFileName,FILE_CSV|FILE_READ,';');
   if(file_handle < 1)
   {
      Print("未找到文件，错误", GetLastError());
      return(false);
   }
   string symbol = StringSubstr(Symbol(),0,6);
   CArrayString *arr = new CArrayString; 
   int str_size;
   string str ;
   int i = 0;
   int index = 0;
   string strplit[13];
   ushort u_sep = StringGetCharacter(",",0);
   
   while(!FileIsEnding(file_handle))
   {
      str = FileReadString(file_handle,str_size);
      if(i % 13 == 0)
      {
         arr.Add(str);
         index ++;
      }else{
         arr.Update(index-1 , arr[index-1]+","+str);
      }
      i++;
   }
   
   datetime open_time,close_time;
   double open_price,close_price;
   string op_type,lot;
   
   for(int i=0;i<arr.Total();i++)
   {
      StringSplit(arr[i],u_sep,strplit);
      if(strplit[3] == symbol)
      {
         open_time = StringToTime(strplit[0]);
         close_time = StringToTime(strplit[7]);
         open_price = StrToDouble(strplit[4]);
         close_price = StrToDouble(strplit[8]);
         op_type = strplit[1];
         Draw_Trend(open_time,close_time,open_price,close_price,op_type,lot,i);
      }
      
   }
   FileClose(file_handle);
   return(INIT_SUCCEEDED);
}

void Draw_Trend(datetime open_time,datetime close_time,double open_price,double close_price,string op_type,string lot,int id)
{
   color c = Blue;
   if(op_type == "Sell")c = Red;
   string t_name = "#"+ id+" "+ open_price +" -> "+close_price;
   
   ObjectCreate(t_name,OBJ_TREND,0,open_time,open_price,close_time,close_price);
   ObjectSet(t_name,OBJPROP_COLOR,c);
   ObjectSet(t_name,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet(t_name,OBJPROP_BACK,false);
   ObjectSet(t_name,OBJPROP_RAY,false);
   
   string open_name = "#"+id+" "+op_type+" "+lot+" at "+open_price;
   ObjectCreate(open_name,OBJ_ARROW,0,open_time,open_price);
   ObjectSet(open_name,OBJPROP_COLOR,c);
   ObjectSet(open_name,OBJPROP_ARROWCODE,1);
   
   string close_name = "#"+id+" "+op_type+" "+lot+" at "+open_price+" close at "+ close_price;
   ObjectCreate(close_name,OBJ_ARROW,0,close_time,close_price);
   ObjectSet(close_name,OBJPROP_COLOR,c);
   ObjectSet(close_name,OBJPROP_ARROWCODE,3);
}


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
   
   return(rates_total);
}

void OnDeinit(const int reason)
{
   ObjectsDeleteAll();
}