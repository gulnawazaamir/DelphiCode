public with sharing class DelphiAdminTab{
  public String selectedVal{get;set;}
  public Boolean batchExecution{get;set;}
  public Boolean altCheck{get;set;}
  
    public DelphiAdminTab(){
    List<Configuration_Instruction__c> lst =Configuration_Instruction__c.getAll().values();

      batchExecution=false;
      altCheck=false;
     
    }
    
    
       public Pagereference  tgetUser(){
           List<OpportunityHistory> alloppo = [SELECT Amount,CloseDate,CreatedDate,OpportunityId,Probability,StageName FROM OpportunityHistory where StageName='Value Proposition' ORDER BY CreatedDate DESC];
           System.debug('::::::::  ---- size '+alloppo.size());
           List<Id> ids = new List<Id>();
           for(OpportunityHistory i: alloppo)
           ids.add(i.OpportunityId);
           
           
          List<opportunity> opp1= [select id,StageName,Amount,name,Accountid,account.name,account.owner.name,Completion_Date__c,owner.name from opportunity where stagename='Closed Won' AND Id in: ids ORDER BY CreatedDate DESC];
                                  
          System.debug('::::::::  ---- opp1 '+opp1.size());
          
          Pagereference objPagereference = new Pagereference('/apex/DelphiTables');          
              return objPagereference;         
        }
        public Pagereference backToHome(){       
         return new Pagereference('/home/home.jsp');
        }
        
         public Pagereference machineLogic(){       
         return new Pagereference('/apex/DelphiMachineLogic');
        }
        
        public List<SelectOption> getbackWardList(){
       selectedVal='1/2';
        List<SelectOption> optns = new List<Selectoption>();
        // before getting here you must populate your queryResult list with required fields
        
           
           optns.add(new selectOption('1','1 year'));
           optns.add(new selectOption('2','2 year'));
           optns.add(new selectOption('3','3 year'));         

        return optns;
}

public void updateDates(){
  // altCheck=true;
  
     System.debug('::::::::  ---- alt check -'+altCheck);
     System.debug('::::::::  ---- batchExecution -'+batchExecution);
     List<Configuration_Instruction__c> lst =Configuration_Instruction__c.getAll().values();
     if(lst!=null && lst.size()>0)
     {
    altCheck=lst[0].Machine_Pages_Visible__c;
    }
    else
    {
    altCheck=false;
    }
    if(altCheck==true)
    {
     batchExecution=false;
    }
    //um.mainFunction();
   
         
    }
    
    public void doCheck(){
    
  //  List<Configuration_Instruction__c> lst =Configuration_Instruction__c.getAll().values();

   //   batchExecution=lst[0].Machine_Pages_Visible__c;
   altCheck=false;
   List<Configuration_Instruction__c> lst =Configuration_Instruction__c.getAll().values();
    
      lst[0].Machine_Pages_Visible__c=false;
       update lst[0];
  System.Debug('The value is : ' + selectedVal);
    Decimal myDecimal = decimal.valueOf(selectedVal);
    DateTime endDate = System.Now();
               DateTime newDate;
              if(myDecimal==0.5)
              {
              newDate = System.Now().addMonths(-6);
              }
              else
              {
              
               newDate = System.Now().addYears(-Integer.valueof(myDecimal));
              }
    List<Opportunity> scope=[Select Id,CloseDate from Opportunity where   CloseDate > :newDate.Date()  and     CloseDate <= :endDate.Date() and Probability=100.0];
    if(scope.size()>=1)
    {
    UserMachineLearningBatch um=new UserMachineLearningBatch(myDecimal );
    
    Database.executeBatch(um,200);
   batchExecution=true;
   }
   else
   {
   batchExecution=false;
      apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'The total number of Closed Won Opportunities for the selected time period is less than 200. Try selecting a time period greater than the current selected time period. ');
        apexpages.addmessage(msg);

   }
   
    }
}