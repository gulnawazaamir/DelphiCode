@isTest
  public class UserMachineLearningBatch_Test{
           @isTest(SeeAllData=true)
         static  void checkMachineLearningBatch1(){
             
  /*    Opportunity opp1= new Opportunity();
        opp1.Name = 'Test Account3231';
         opp1.StageName = 'Prospecting';
          opp1.CloseDate =Date.today();
        insert opp1;
         DateTime newDate;
         newDate = System.Now().addMonths(-1);
        Opportunity opp2= new Opportunity();
        opp2.Name = 'Test Account3231';
         opp2.StageName = 'Closed Won';
         opp2.Probability=100.0;
          opp2.CloseDate =newDate.Date();
      insert opp2;
        
        Configuration_Instruction__c c1=new Configuration_Instruction__c();
        c1.Machine_Pages_Visible__c=true;
        c1.Name='Trest';
        insert c1;
        List<Opportunity> lst=new List<Opportunity>();
        lst.add(opp1);
       lst.add(opp2);   */
       Test.startTest();
        List<Opportunity> scope=[Select Id from Opportunity where Probability=100.0];
        UserMachineLearningBatch um = new UserMachineLearningBatch(12);    
        Database.QueryLocator ql = um.start(null);
 //       ID batchprocess = Database.executeBatch(um ,100);
        um.execute(null,scope);
       um.Finish(null);
         Test.stopTest();
          System.Assert(true, 'The Test did not insert properly, please check'); 
         
        }
        
        
         static testMethod void checkMachineLearningBatch2(){
            Test.startTest();  
      Opportunity opp1= new Opportunity();
        opp1.Name = 'Test Account3231';
         opp1.StageName = 'Prospecting';
          opp1.CloseDate =Date.today();
          opp1.Probability=100.0;
         
        insert opp1;
         
           System.Assert(opp1.Name!= null, 'The Test did not insert properly, please check'); 
         Configuration_Instruction__c c1=new Configuration_Instruction__c();
        c1.Machine_Pages_Visible__c=true;
         c1.Name='Trest';
        insert c1;
         
           System.Assert(c1.Name!= null, 'The Test did not insert properly, please check'); 
        List<Opportunity> lst=new List<Opportunity>();
        lst.add(opp1);
        UserMachineLearningBatch um = new UserMachineLearningBatch(0.5);    
        Database.QueryLocator ql = um.start(null);
        um.execute(null,lst);
        um.Finish(null); 
        Test.stopTest();
        }
  }