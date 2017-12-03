public with sharing class DelphiUserTab{
    public boolean chkbox{get;set;}
 
    public List<Configuration_Instruction__c> configInstr {get;set;}
    
    public DelphiUserTab(){
    configInstr = Configuration_Instruction__c.getAll().values();
    }
    
    public Pagereference  tgetUser(){
    if (Configuration_Instruction__c.Visible_Page__c.getDescribe().isUpdateable()) {
               if(configInstr!=null && configInstr.size()>0)
               {
               if(configInstr[0].Visible_Page__c == false ){
        configInstr[0].Visible_Page__c = chkbox;      
        update configInstr;       
        } 
                
                }
          }          
             
         
        Pagereference objPagereference = new Pagereference('/apex/DelphiGraphPage');          
            return objPagereference; 
                   
    }
    public Pagereference backToHome(){       
         return new Pagereference('/home/home.jsp');
     }
}