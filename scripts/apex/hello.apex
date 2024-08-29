// List<Opportunity> existingOppList = [SELECT Id, Name FROM Opportunity WHERE Name = :oppNames]


// /**
//      * Question 8
//      * Insert or updates opportunities from list of names.
//      * Associate the Opportunities with account that has the name accountName.
//      * There should be an Opportunity for each name provided in the list.
//      * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
//      * @param accountName The name of the Account.
//      * @param oppNames The list of Opportunity names.
//      */
//     public static void upsertOpportunities(String accountName, List<String> oppNames) {

//         List<Account> accountList = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
//         Account relatedAccount;

//         if(accountList.isEmpty()){
//             relatedAccount = new Account();
//             relatedAccount.Name = accountName;
//         } else{
//             relatedAccount = accountList[0];
//         }

//         upsert relatedAccount;

//         Set<String> setOppName = new Set<String>();
//         List<Opportunity> opportunityList = new List<Opportunity>();

//         for(String oppUnique: oppNames){
//             setOppName.add(oppUnique);
//         }

//         for(String opp : setOppName){
//             Opportunity newOpp = new Opportunity();
//             newOpp.Name = opp;
//             newOpp.AccountId = relatedAccount.Id;
//             newOpp.CloseDate = Date.today().addMonths(3);
//             newOpp.StageName = 'Prospecting';

//             opportunityList.add(newOpp);
//         }

//     upsert opportunityList;
//     }







//     DMLOperations.upsertOpportunities(accountName, oppNames);
    
//         // Retrieve the updated Opportunities from the database
//         List<Opportunity> updatedOpps = [SELECT Id, Name FROM Opportunity WHERE AccountId = :retrievedAcc.Id];
        
//         // Assert that the Opportunities were successfully updated
//         System.assertEquals(oppNames.size(), updatedOpps.size(), 'The number of updated Opportunities should match the number of Opportunity names provided');
    
//         for (Opportunity opp : updatedOpps) {
//             System.assert(oppNames.contains(opp.Name), 'All updated Opportunity names should be found in the database');
//         }
//     }


//     [{"Id":"006aj000004c4oHAAQ","Name":"Opp 1"},{"Id":"006aj000004c4oIAAQ","Name":"Opp 2"},{"Id":"006aj000004c4oJAAQ","Name":"Opp 3"}]
//     [{"Id":"006aj000004c4oHAAQ","Name":"Opp 1"},{"Id":"006aj000004c4oIAAQ","Name":"Opp 2"},{"Id":"006aj000004c4oJAAQ","Name":"Opp 3"}]
//     [{"Id":"006aj000004c4oHAAQ","Name":"Opp 1"},{"Id":"006aj000004c4oIAAQ","Name":"Opp 2"},{"Id":"006aj000004c4oJAAQ","Name":"Opp 3"}]


// oppNames.clear();

// for(Integer i = 0; i >= opportunityList.size();  i++){
//     oppNames.add(opportunityList[i].Name);

