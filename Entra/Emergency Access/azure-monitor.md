# Monitor Break-Glass Sign-Ins 
## Azure Monitor
  
## Pre-Requisites
Send Entra ID sign-in logs to Azure Monitor.  
SignInLogs and AuditLogs should be sent to a Log Analytics Workspace.
 
## Obtain Object IDs of the break glass accounts
1. Sign in to the Azure portal with an account with at least a sufficient Reader or User Administrator role.
2. Select Entra ID > Users.
3. Search for the break-glass account and select the user's name.
4. Copy and save the Object ID attribute so that you can use it later.
5. Repeat previous steps for second break-glass account.
 
## Create an alert rule
1. Sign in to the Azure portal with an account assigned to the Monitoring Contributor role in Azure Monitor.
2. Select All services, enter "log analytics" in Search and then select Log Analytics workspaces.
3. Select a workspace.
4. In your workspace, select Alerts > New alert rule.
5. Under Resource, verify that the subscription is the one with which you want to associate the alert rule.
6. Under Condition, select Add.
7. Select Custom log search under Signal name.
8. Under Search query, enter the following query, inserting the object IDs of the two break glass accounts.

*For each additional break glass account you want to include, add another "or UserId == "ObjectGuid"" to the query.*

Adjust severity to 0 - Critical.
 
## Create an action group
1. Select Create an action group.
2. Enter the action group name and a short name.
3. Verify the subscription and resource group.
4. Under action type, select Email/SMS/Push/Voice.
5. Enter an action name such as Notify global admin.
6. Select the Action Type as Email/SMS/Push/Voice.
7. Select Edit details to select the notification methods you want to configure and enter the required contact information, and then select OK to save the details.
8. Add any additional actions you want to trigger.
9. Select OK.
 
When the Alert is triggered - a notification will be emailed to the email defined in the assigned action group.
Alerts can be viewed in the Log Analytics Workspace > Alerts
 
In the email, a summary will be provided for the alert, including the query of the alert and the query results.
 
| Field | Value |
|-------|-------|
| Alert name | Break Glass Account Sign-In |
| Severity | Severity Level |
| Monitor condition | Fired |
| Affected resource | Log Analytics Workspace |
| Resource type | microsoft.operationalinsights/workspaces |
| Resource group | Resource Group |
| Subscription | Subscription |
| Monitoring service | Log Alerts V2 |
| Signal type | Log |

---
