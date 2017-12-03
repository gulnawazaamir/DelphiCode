global class PostInstallClass implements InstallHandler  {
  global void onInstall(InstallContext context) {
   
   // Added to create a custom setting record for the first time the package installed
   if(context.previousVersion() == null) {
        delphiDemo__checkTrial__c ct=new delphiDemo__checkTrial__c(name='trial', delphiDemo__expirydate__c=System.now().addHours(12).addMinutes(30)+30);
        insert ct;
   }  
   
   Confidence_level_and_month__c dclm = new Confidence_level_and_month__c();
    if (Confidence_level_and_month__c.name.getDescribe().isCreateable() && Confidence_level_and_month__c.Confidence_Level__c.getDescribe().isCreateable() && 
    Confidence_level_and_month__c.Selected_Month__c.getDescribe().isCreateable()) {
             dclm.name ='Con and mon';
    dclm.Confidence_Level__c = '99';
    dclm.Selected_Month__c ='Apr';
    insert dclm; 
          }
          
          
          Configuration_Instruction__c cin = new Configuration_Instruction__c();
    if (Configuration_Instruction__c.name.getDescribe().isCreateable() && Configuration_Instruction__c.Visible_Page__c.getDescribe().isCreateable()) {
           cin.name = 'Checkbox'; 
    cin.Visible_Page__c = false ;
    insert cin;
          }
          
          
            List<ProbabilityMapping__c> insertProbList=new List<ProbabilityMapping__c>();
     List<TImeMapping__c> insertTimeList=new List<TImeMapping__c>();
     List<OpportunityStage> osList=[SELECT DefaultProbability,MasterLabel FROM OpportunityStage LIMIT 100];
     
      for(OpportunityStage str:osList)
        {
            if(str.DefaultProbability!=100.0 && str.DefaultProbability!=0.0)
        {
             
            ProbabilityMapping__c pm = new ProbabilityMapping__c();
            if (ProbabilityMapping__c.name.getDescribe().isCreateable() && ProbabilityMapping__c.Max_Probability__c.getDescribe().isCreateable() && 
            ProbabilityMapping__c.Min_Probability__c.getDescribe().isCreateable() && ProbabilityMapping__c.Probability_Mean__c.getDescribe().isCreateable() && 
            ProbabilityMapping__c.Probability_SD__c.getDescribe().isCreateable()) {
            
             pm.name =str.MasterLabel;
            pm.Max_Probability__c = 0.00;
            pm.Min_Probability__c= 0.00;
            pm.Probability_Mean__c = 0.00;
            pm.Probability_SD__c = 0.00;
            insertProbList.add(pm);
            
            }
            TImeMapping__c tmp = new TImeMapping__c();
            if (TImeMapping__c.name.getDescribe().isCreateable() && TImeMapping__c.Max_Time__c.getDescribe().isCreateable() && 
            TImeMapping__c.Mean__c.getDescribe().isCreateable() && TImeMapping__c.Min_Time__c.getDescribe().isCreateable() && 
            TImeMapping__c.Standard_Deviation__c.getDescribe().isCreateable()) {
            tmp.name = str.MasterLabel;
            tmp.Max_Time__c = 0;
            tmp.Mean__c = 0;
            tmp.Min_Time__c = 0.000;
            tmp.Standard_Deviation__c = 0.000 ; 
            insertTimeList.add(tmp);
            }
           
            
            
            
        }   
        } 
        
        insert insertProbList;
        insert insertTimeList;
        
        
         batch_processing_date__c bpc=new batch_processing_date__c();
      if (batch_processing_date__c.name.getDescribe().isCreateable()) {
          bpc.name='batch_date';
     insert bpc;
          }
          
       
       
          
       UserMachineLearningBatch um=new UserMachineLearningBatch(1);
       
       Database.executeBatch(um,20);
       
      
       
       UserMachineLearningBatch um2=new UserMachineLearningBatch(2);
       
       Database.executeBatch(um2,20);
       
       UserMachineLearningBatch um3=new UserMachineLearningBatch(3);
       
       Database.executeBatch(um3,20);
        
       
       
      }
      
 
}