# Sentinel RBAC

| **Role Name** | **Permissions** |
|---------------|----------------|
| Microsoft Sentinel Reader | view data, incidents, workbooks, and other Microsoft Sentinel resources. |
| Microsoft Sentinel Responder | in addition to the above, manage incidents (assign, dismiss, etc.). |
| Microsoft Sentinel Contributor | in addition to the above, install and update solutions from content hub, create and edit workbooks, analytics rules, and other Microsoft Sentinel resources. |
| Microsoft Sentinel Playbook Operator | list, view, and manually run playbooks. |
| Microsoft Sentinel Automation Contributor | allows Microsoft Sentinel to add playbooks to automation rules. It isn't meant for user accounts. |

# Data Retention

| **Log Tier** | **Analytic Logs** | **Basic Logs** | **Archive Logs** |
|--------------|-------------------|----------------|------------------|
| Features | Full KQL Capabilities Alerts supported No Query Limits 90 days retention included | Reduced KQL Capabilites Alerts is not supported Limits on Query concurrency 8 days retention included | Only batch queries with limited KQL 0-7 years archive |
| Ingestion charge (pay-as-you-go) | Sentinel: 2$/GB per month | 0.50$/GB per month | Data archive 0.02$/GB per month |
| Search query charge | N/A | 0.05$ per scanned GB | 0.05$ per scanned GB |
| Restore charge | N/A | N/A | 0.10$/GB per day |
