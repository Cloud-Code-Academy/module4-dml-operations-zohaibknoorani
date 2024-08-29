/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Zohaib Karim Noorani
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account newAccount = new Account();
    
        // Set the Name field on the Account to 'New Account' followed by the current timestamp
        // This ensures the Account name is unique by appending the current time in milliseconds
        newAccount.Name = 'New Account' + DateTime.now().getTime();
    
        // Insert the Account into the database
        insert newAccount;
    
        // Return the Id of the newly created Account to the caller
        return newAccount.Id;
    }
    

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline

        Account newCreateAccount = new Account(Name = name, Industry = industry);

        // Insert the Account
        insert newCreateAccount;
        
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact();

        // // Set some fields on the Contact

        newContact.FirstName = 'CloudCode';
        newContact.LastName = 'Student' + DateTime.now().getTime();

        // Set the AccountId field to the given accountId
        newContact.AccountId = accountId;

        // Insert the Contact into the database

        insert newContact;

        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]

        Contact newUpdateContact = [SELECT Id FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name
        newUpdateContact.LastName = newLastName;

        // Update the Contact in the database
        update newUpdateContact;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]

        Opportunity updateOpportunity = [SELECT Id FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage

        updateOpportunity.StageName = newStage;

        // Update the Opportunity in the database

        update updateOpportunity;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        Account updateAccount = [SELECT Id FROM Account WHERE Id = :accountId];

        // Update the Account with the given Id with the new name and industry
        updateAccount.Name = newName;
        updateAccount.Industry = newIndustry;

        update updateAccount;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list

        for(Opportunity opp: opportunities){
            // Set the Opportunity's Stage to Qualification
            opp.StageName = 'Qualification';
            // Set the Opportunity's Close Date to 3 months from today
            opp.CloseDate = Date.today().addMonths(3);
            // Set the Opportunity's Amount to 50000
            opp.Amount = 50000;
        }
        // Upsert the opportunities List so that records are either updated or created   
        upsert opportunities;
            
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        
        // Query to get the Account record matching the provided accountName
        List<Account> accountList = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
        
        // Clone the list of opportunity names for further processing
        List<String> oppNamesClone = oppNames.clone();

        Account relatedAccount;
    
        // If the account does not exist, create a new Account record
        if (accountList.isEmpty()) {
            relatedAccount = new Account(Name = accountName);
            insert relatedAccount;
        } else {
            // If the account exists, use the existing Account record
            relatedAccount = accountList[0];
        }

        // Initialize a list to store the opportunities to be inserted/updated
        List<Opportunity> opportunityList = new List<Opportunity>();

        // Query to find existing opportunities that match the provided names
        List<Opportunity> existingOppList = [SELECT Id, Name FROM Opportunity WHERE Name = :oppNames];

        // If any existing opportunities are found, associate them with the related account
        if (!(existingOppList.isEmpty())) {
            for (Opportunity existingopp : existingOppList) {
                existingopp.AccountId = relatedAccount.Id;
                // Remove the name of the existing opportunity from the cloned list
                oppNamesClone.remove(oppNamesClone.indexOf(existingopp.Name));
                // Add the existing opportunity to the list to be upserted
                opportunityList.add(existingopp);
            }
        }

        // If there are still opportunity names in the cloned list, create new opportunities
        if (!(oppNamesClone.isEmpty())) {
            for (String opp : oppNamesClone) {
                Opportunity newOpp = new Opportunity(
                    Name = opp,
                    AccountId = relatedAccount.Id,
                    CloseDate = Date.today().addMonths(3),
                    StageName = 'Prospecting'
                );
                // Add the new opportunity to the list to be upserted
                opportunityList.add(newOpp);
            }
        }
    
        // Perform the upsert operation on the list of opportunities (inserts new and updates existing records)
        upsert opportunityList;
    }
    
    
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
        // Query for the Account with the provided name
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
    
        // If the Account exists, update its description
        if (!accounts.isEmpty()) {
            accounts[0].Description = 'Updated Account';
        } 
        // If the Account does not exist, create a new Account and set the description
        else {
            Account newAccount = new Account();
            newAccount.Name = accountName;
            newAccount.Description = 'New Account';
            accounts.add(newAccount);
        }
    
        // Upsert the Account (insert new or update existing)
        upsert accounts;
    
        // Return the first Account (either updated or newly created)
        return accounts[0];
    }
    

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
    public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {

        // Loop through each Contact in the provided list
        for (Contact c : contactsToUpsert) {
            // Check if the Contact's associated Account has a name
            if (c.Account.Name != null) {
                // If the Account's name is different from the Contact's last name, update the Account
                if (!c.Account.Name.equals(c.LastName)) {
                    Account newAccount = upsertAccount(c.LastName);
                    c.AccountId = newAccount.Id;   
                }
            } else {
                // If the Account's name is null, create or update an Account using the Contact's last name
                Account createAccount = upsertAccount(c.LastName);
                c.AccountId = createAccount.Id;
            }
        }
    
        // Upsert the list of Contacts (insert new or update existing)
        upsert contactsToUpsert;
    }
    

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {

        List<Lead> leadList = new List<Lead>();
    
        // Loop through each lead name and create a Lead record
        for (String newlead : leadNames) {
            Lead createLead = new Lead(
                LastName = newlead,
                Company = 'TBD',
                Status = 'Open - Not Contacted'
            );
            leadList.add(createLead);
        }
    
        // Insert the created Lead records into the database
        insert leadList;
    
        // Delete the inserted Lead records from the database
        delete leadList;
    }
    


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {

        List<Case> newCases = new List<Case>();
    
        // Loop to create and add the specified number of Cases to the list
        for (Integer i = 1; i >= numOfCases; i++) {
            Case newCase = new Case();
            newCase.AccountId = accountId;
            newCase.Status = 'New';
            newCase.Description = 'New Case: # ' + String.valueOf(i);
    
            newCases.add(newCase);
        }
    
        // Delete the created Cases (note: this deletes the cases before they are inserted)
        delete newCases;
    }
}    