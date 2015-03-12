2015-01-09 11:22:12
```java
SELECT ID, 
								Name 
						FROM 	RecordType 
						WHERE 	sObjectType = 'Application__c'
```

2015-03-06 13:26:51
```java
SELECT Name, AccountID FROM USer
```

2015-03-06 15:23:58
```java
SELECT Name, AccountID, Contact.AccountID, Contact.Account.ParentId, Contact.Account.Parent.ParentId, Account_ID__c FROM USer
```

