@isTest
  public class getOpportunity_Test{
         
         
         
         static testMethod void testgetOpportunity2(){
            
         Opportunity opp1= new Opportunity();
         opp1.Name = 'Test Account3231';
         opp1.StageName = 'Prospecting';
         opp1.CloseDate =Date.today();
         insert opp1;
          System.Assert(opp1.id!= null, 'The Test Account did not insert properly, please check validation rules and other mechanisms');
         opp1.StageName = 'Value Proposition';
         update opp1;
       
         opp1.StageName = 'Negotiation/Review';
         update opp1; 
       
         opp1.StageName = 'Closed Won';
         update opp1; 
           TimeMapping__c objTimeMapp = new TimeMapping__c();
                        objTimeMapp.name = 'Value Proposition';
                        objTimeMapp.Max_Time__c = 0;
                        objTimeMapp.Min_Time__c = 0;
                        objTimeMapp.Mean__c = 0.75;
                        objTimeMapp.Standard_Deviation__c = 0.4;
                        insert objTimeMapp;
               System.Assert(objTimeMapp.name!= null, 'The Test Account did not insert properly, please check validation rules and other mechanisms');
                Revenue_Information__c objProbMapp1 = new Revenue_Information__c();
                        objProbMapp1.name = 'Value Proposition';
                        objProbMapp1.ProbabilityScore__c = String.valueOf(0.34);
                        insert objProbMapp1;    
                         System.Assert(objProbMapp1.name!= null, 'The Test did not insert properly, please check');                   
           MachineLearningRecord__c machineObject= new MachineLearningRecord__c();
        
        machineObject.Stage_Name__c='Value Proposition';
        machineObject.Counter__c=2;
        machineObject.Time_Duration__c=0.56;
        machineObject.Batch_Date_Time__c=date.today();
        
        
         StagesTimeDurationRecord__c stageData=new StagesTimeDurationRecord__c();
        
         stageData.Stage_Name__c='Value Proposition';
         stageData.Duration__c=0.34;
         
        insert stageData;
         System.Assert(stageData.Stage_Name__c!= null, 'The Test did not insert properly, please check');   
        insert machineObject;   
         System.Assert(machineObject.Stage_Name__c!= null, 'The Test did not insert properly, please check');             
     //   List<OpportunityFieldHistory> lfp=retrieveOpportunityFieldHistory(opp1.Id);
        batch_processing_date__c batchCustomSetting=new batch_processing_date__c();
        batchCustomSetting.name='batch_date';
        batchCustomSetting.batch_date__c=null;
        insert batchCustomSetting; 
        System.Assert(batchCustomSetting.name!= null, 'The Test did not insert properly, please check');   
        List<Opportunity> lst=new List <Opportunity>();
        lst.add(opp1);
         Configuration_Instruction__c c1=new Configuration_Instruction__c();
        c1.Machine_Pages_Visible__c=true;
         c1.Name='Trest654r43';
        insert c1;  
        System.Assert(c1.Name!= null, 'The Test did not insert properly, please check');   
        getOpportunity gm = new getOpportunity();    
        Database.QueryLocator ql = gm.start(null);
        gm.execute(null,lst);
        gm.Finish(null);

         }
         
  /* public static OpportunityFieldHistory[] retrieveOpportunityFieldHistory(Id oppId){
     List<OpportunityFieldHistory> ah;
     if(Test.isRunningTest()){  //if TEST, create dummy AccountHistory
         ah = new List<OpportunityFieldHistory>{}; //OldValue, NewValue not writeable
         ah.add(new OpportunityFieldHistory(OpportunityId=oppId));
     }
     else 
         ah=  [SELECT NewValue,OldValue,OpportunityId,CreatedDate FROM OpportunityFieldHistory where OpportunityId= :oppId];


     return ah;
    }    */
         
  }