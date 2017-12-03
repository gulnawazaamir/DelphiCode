public with sharing class DelphiOppDates{
   
    
    public String selectedVal{get;set;}  // This will hold the selected value, the id in here 
    public DelphiOppDates(){
    
          
    }
    public void updateDates(){
   
    System.Debug('The value is : ' + selectedVal);
    Integer backValue=Integer.valueof(selectedVal);
    UserMachineLearningBatch um=new UserMachineLearningBatch(backValue);
    um.mainFunction();
   
         
    }
    
    

       public List<SelectOption> getbackWardList(){
       selectedVal='1/2';
        List<SelectOption> optns = new List<Selectoption>();
        // before getting here you must populate your queryResult list with required fields
        
           optns.add(new selectOption('1/2','6 months'));
           optns.add(new selectOption('1','12 months'));
           optns.add(new selectOption('2','2 year'));
           optns.add(new selectOption('3','3 year'));         

        return optns;
}
    
}