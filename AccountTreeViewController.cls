public class AccountTreeViewController {
     
	//public Map<String, Map<String, List<Account>>> mapAccounts{get;set;}
	public Map<String, Account> mapAccountsLevel1 {get;set;}
	public Map<String, Account> mapAccountsLevel1A {get;set;}    
	public Map<String, List<Account>> mapAccountsLevel2 {get;set;}
 
    public Set<id> AccountIds;
    public Map<id,List<Account>> mapAccountEntity {get;set;} 
	public Map<String, List<Opportunity>> mapOpps {get;set;}    
     
    public String KeyToCheck {get;set;} 
    
    public Id CurrentAccountId {
    	get; set;
	}
    
    public boolean getKeyExists()
    {
        system.debug( 'Key To Check ' + CurrentAccountId );
    	//return mapOpps.containsKey( KeyToCheck );  
    	return false; 
    } 
    
    public String getAccount( String Id )
    {
        
        return 'Daniela Account Z' + Id ;
    }
    
    
    public void fetchAccounts(){
        
        //mapAccounts = new Map<String, Map<String, List<Account>>>();
        mapAccountsLevel1 = new Map<String, Account>();
        mapAccountsLevel1A = new Map<String, Account>();

        mapAccountsLevel2 = new Map<String, List<Account>>();
        
		mapAccountEntity = new Map<id,List<Account>>();


        for(Account accRecord : [select id, parentid, name, BillingCity, BillingState from account]){
			mapAccountsLevel1A.put(accRecord.id, accRecord);
        }    
        
        AccountIds = new Set<Id>();
        
        List<Account> listOfAccounts = [select id, parentid, name, BillingCity, BillingState from account where parentid <> null];
        for( Account a : listOfAccounts )
        {    
        	AccountIds.add(a.id);
        }
        
        List<Opportunity> listOpps = [ Select Id, Name, AccountId, StageName, Amount, Probability, CloseDate, Type, LeadSource, ForecastCategoryName  from Opportunity Where AccountId in :AccountIds ];
        mapOpps = new Map<String, List<Opportunity>>(); 
            
        for(Opportunity oppRecord : listOpps){
        	
            List<Opportunity> entitiesForKey = mapOpps.get(oppRecord.accountId);
            
            if (entitiesForKey == null) {
                
                system.debug( 'New Parent accRecord ' + oppRecord.Name + ' Id ' + oppRecord.id + ' Parent ' + oppRecord.AccountId );
        		entitiesForKey = new List<Opportunity>();
        		mapOpps.put(oppRecord.accountId, entitiesForKey);
    		}
            
            //system.debug( 'Pass 2 accRecord ' + accRecord.Name + ' Id ' + accRecord.id + ' Parent ' + accRecord.parentid );
        	entitiesForKey.add(oppRecord);
        }             
        
        for(Account accRecord : listOfAccounts){
        	
            List<Account> entitiesForKey = mapAccountEntity.get(accRecord.parentid);
            
            if (entitiesForKey == null) {
                
                system.debug( 'New Parent accRecord ' + accRecord.Name + ' Id ' + accRecord.id + ' Parent ' + accRecord.parentid );
        		entitiesForKey = new List<Account>();
        		mapAccountEntity.put(accRecord.parentid, entitiesForKey);
   
    		}
                
            if( !mapOpps.containsKey(accRecord.id) )
            {
                mapOpps.put( accRecord.id, new List<Opportunity>() );  
            } 
            
            //system.debug( 'Pass 2 accRecord ' + accRecord.Name + ' Id ' + accRecord.id + ' Parent ' + accRecord.parentid );
        	entitiesForKey.add(accRecord);
        } 
        
		system.debug( 'mapOpps.size ' + mapOpps.size() );
        
        for (Id recordId : mapAccountEntity.keySet())
		{
        	//system.debug( 'recordId ' + recordId );
            
            system.debug(mapAccountEntity.get(recordId));
            
        }
        
        
        for(Account accRecord : [select Name, Id, (select Id, Name, Phone, BillingCity from ChildAccounts) from Account Where parentid = null and id = '0013600000RSv85AAD' limit 100]){
            
            String name = accRecord.Name;
            String Id = accRecord.Id;
            system.debug( 'Name ' + name );
                system.debug( 'New ' + Id );
            
            List<Account> AccList = new List<Account> ();
            
            
            if( mapAccountsLevel2.ContainsKey(id) )
            {
            	System.debug( 'Contains ' + Id ) ;  
                
            }
            else
            {
            	System.debug( 'No Contains ' + Id ) ;  
                AccList.add( accRecord );
				mapAccountsLevel2.put( Id, AccList );                
            }     
                
            
            /*
            if(mapAccounts.get(Id) != null){
                if(mapAccounts.get(Id).get(accRecord.Id) != null)
                    mapAccounts.get(Id).get(accRecord.Id).add(accRecord);
                else
                    mapAccounts.get(Id).put(accRecord.Id, new List<Account>{accRecord});
            }
            else{
                system.debug( 'New ' + Id );
                mapAccounts.put(Id, new Map<String, List<Account>>{accRecord.Id => new List<Account>{accRecord}});
                mapAccountsLevel1.put( Id, accRecord );
                //ListAccount.Add( Id );
            }      */      
       	}  
        
            
        //system.debug( 'mapAccounts ' + mapAccounts );

        system.debug( 'mapAccountsLevel1 ' + mapAccountsLevel1 );
        
        //system.debug( 'mapAccounts 0013600000RSv7xAAD ==>> ' + mapAccounts['0013600000RSv7xAAD'] ['0013600000RSv7yAAD'].Name);
        


    }
}