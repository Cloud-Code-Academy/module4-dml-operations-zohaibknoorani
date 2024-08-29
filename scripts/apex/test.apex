* Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {

        Set<String> lastNames = new Set<String>();
        
        for (Contact contact : contactsToUpsert) {
            lastNames.add(contact.LastName);

        }

        Map<String, Account> existingAccountsMap = new Map<String, Account>();

        for (Account acc : [SELECT Id, Name FROM Account WHERE Name IN :lastNames]) {
        existingAccountsMap.put(acc.Name, acc);
        }

        List<Account> newAccountsToInsert = new List<Account>();

        for (Contact contact : contactsToUpsert) {
            Account associatedAccount = existingAccountsMap.get(contact.LastName);
            
            if (associatedAccount != null) {
                contact.AccountId = associatedAccount.Id;
            } else {
                Account newAccount = new Account(Name = contact.LastName);
                newAccountsToInsert.add(newAccount);
                existingAccountsMap.put(contact.LastName, newAccount);
            }
        }

        if (!newAccountsToInsert.isEmpty()) {
            upsert newAccountsToInsert;
        
            for (Account newAccount : newAccountsToInsert) {
                for (Contact contact : contactsToUpsert) {
                    if (contact.LastName == newAccount.Name && contact.AccountId == null) {
                        contact.AccountId = newAccount.Id;
                    }
                }
            }
        }
        
    upsert contactsToUpsert;
    }