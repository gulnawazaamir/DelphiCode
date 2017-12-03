@isTest
  public class MachineLearningData_Test{
  
         static testMethod void testMachineLearningData1(){
            
          MachineLearningData m1=new MachineLearningData();
          m1.stageName='Prospecting';
          m1.duration=1.0;
          m1.counter=1;
          m1.createdDate=Date.today();
          
           System.Assert(m1.stageName!= null, 'The Test did not insert properly, please check');

         }
  }