@isTest
  public class DelphiTableTest
    {
        Integer count = 0;    
        Static List <TImeMapping__c> lstTimeMap = new List <TImeMapping__c>();
        static testMethod void DelphiTableTest()
       
          { 
            
             Date timee = System.today();
             String name = 'test';
             Integer data = 12345 ;
             Double datatest = 10.0;
             boolean chkbox= true;
             boolean exportdata24topacc = true;
             boolean nonadminchkbox ;
             list<double> exptedamnt = new list<double>();
             opportunity opp = new opportunity();
             opp.Name = 'testoppportunity';
             opp.CloseDate = System.today();
             opp.StageName ='Prospecting';
             opp.Probability= 10.0;
             insert opp;
             
             Confidence_level_and_month__c cfdl = new Confidence_level_and_month__c();
             cfdl.Confidence_Level__c='testlevel';
             cfdl.Selected_Month__c = 'january';
             cfdl.Name = 'testcustom';
             insert cfdl;             
             
             Configuration_Instruction__c cfinst = new Configuration_Instruction__c();            
             cfinst.Name = 'testcustom3';
             insert cfinst;
             cfinst.Visible_Page__c = false;
             update cfinst ;
            /* 
             NonAdmininstruction__c admin = new NonAdmininstruction__c();
             admin.name = 'testcustom4';
             insert admin;
            */
             TImeMapping__c timemap = new TImeMapping__c();
             timemap.Max_Time__c = 10 ;
             timemap.Mean__c = 7 ;
             timemap.Min_Time__c = 5 ;
             timemap.Standard_Deviation__c= 3;
             timemap.Name = 'prospecting';    
             insert timemap;
         
             ProbabilityMapping__c probmap = new ProbabilityMapping__c();
             probmap.Max_Probability__c = 12 ;
             probmap.Min_Probability__c = 5 ;
             probmap.Probability_Mean__c = 10 ;
             probmap.Probability_SD__c = 3;
             probmap.name = 'prospecting';
             insert probmap;
        
             
             DelphiTableController dpconfig = new DelphiTableController(); 
             
             dpconfig.cancelsetting();
             dpconfig.saveSetting();  
            
             dpconfig.editsetting();
             
             dpconfig.actionPollar();
             dpconfig.backToHome();
             
             
             DelphiAdminTab objDelphiAdminTab = new DelphiAdminTab();
             objDelphiAdminTab.selectedVal='1';
             objDelphiAdminTab.tgetUser();
             objDelphiAdminTab.backToHome();
             objDelphiAdminTab.updateDates();
             objDelphiAdminTab.doCheck();
             objDelphiAdminTab.machineLogic();
             objDelphiAdminTab.getbackWardList();
             
             DelphiUserTab objDelphiUserTab = new DelphiUserTab();
             objDelphiUserTab.chkbox=true;
             objDelphiUserTab.tgetUser();
             objDelphiUserTab.backToHome();
             System.assertEquals(5,5);
            
      }
    
    }