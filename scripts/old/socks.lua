local url = 'http://127.0.0.1:4343/' 
 local args = '' 
   
 server_on = http.get(url..'hello/') 
   
 if server_on == nil then 
     print('PyServer is off') 
     return 
 else 
     print('PyServer ready') 
 end 
         
 while true do 
     src = http.get(url..args) 
     if src then  
         for i, s in pairs(src) do 
             for i, n in pairs(n) do 
                 print(s) 
             end 
         end 
     end 
 end