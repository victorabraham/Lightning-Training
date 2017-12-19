public class AccountContactController {  
   public Account acc{get;set;}  
   public Contact con{get;set;}  
   public AccountContactController()  
   {  
     acc = new Account();  
     con = new Contact();  
   }  
   public pageReference saveAccCont()  
   {  
     PageReference pg = null;  
     if(acc != null)  
     {  
       insert acc;  
       if(con != null && acc.Id != null)  
       {  
         con.AccountId = acc.Id;  
         insert con;  
         pg = new PageReference('/'+acc.Id);  
         return pg;  
       }  
       else  
       {  
         return pg;  
       }  
     }  
     else  
     {  
          return pg;  
     }  
   }  
   public List<SelectOption> getCountryList()  
   {  
     List<SelectOption> countryList = new List<SelectOption>();  
     countryList.add(new SelectOption('US','US'));  
     countryList.add(new SelectOption('CANADA','CANADA'));  
     countryList.add(new SelectOption('MEIXCO','MEIXCO'));  
     return countryList;  
   }  
 }