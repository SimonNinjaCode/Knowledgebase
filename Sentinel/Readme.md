# Microsoft Sentinel

## Cloud-Native SIEM & SOAR

**Microsoft Sentinel** is a scalable, cloud-native **Security Information and Event Management (SIEM)** and **Security Orchestration, Automation, and Response (SOAR)** solution. It delivers intelligent security analytics and threat intelligence across your enterprise, providing visibility, detection, investigation, and automated response across hybrid environments.

---

## Key Capabilities

| Category            | Capabilities |
|---------------------|-------------|
| **Data Collection** | Ingest logs and signals from Microsoft 365, Azure, Entra ID, Defender XDR, Firewalls, and third-party tools |
| **Threat Detection** | Built-in and custom analytics rules, UEBA, threat intelligence, and MITRE ATT&CK mapping |
| **Investigation**    | Interactive workbooks, hunting queries, investigation graphs, incident timeline |
| **Automation**       | Playbooks (Logic Apps), automated remediation, enrichment workflows |
| **Response**         | Manual and automated incident response via SOAR integrations |
| **Integration**      | Native support for Microsoft security stack + REST APIs for custom pipelines |

---

## Operational Framework

### Daily

- Triage and investigate [**incidents**](https://learn.microsoft.com/en-us/azure/sentinel/tutorial-detect-threats-siem)
- Review [**Sentinel Workbooks**](https://learn.microsoft.com/en-us/azure/sentinel/sentinel-workbooks)
- Run hunting queries and evaluate [**bookmarks**](https://learn.microsoft.com/en-us/azure/sentinel/bookmarks)
- Update or close existing alerts
- Launch [**advanced hunting**](https://learn.microsoft.com/en-us/azure/sentinel/hunting-overview) as needed
- [**Automatically create incidents**](https://learn.microsoft.com/en-us/azure/sentinel/tutorial-respond-threats-playbook)

### Weekly

- [**Review analytics rules**](https://learn.microsoft.com/en-us/azure/sentinel/tutorial-detect-threats-custom) and tune thresholds  
- Validate [**data connector health**](https://learn.microsoft.com/en-us/azure/sentinel/connect-data-sources) and log ingestion  
- Update workbooks for new data  
- Conduct [**audit reviews**](https://learn.microsoft.com/en-us/azure/sentinel/audit-logs) of Sentinel configuration changes

### Monthly

- Audit [**permissions**](https://learn.microsoft.com/en-us/azure/sentinel/roles) and user access  
- Review [**Log Analytics Retention Policy**](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-retention-policy)  
- Monitor changes in [**product updates**](https://learn.microsoft.com/en-us/azure/sentinel/whats-new)  
- Curate new content from the [**Sentinel GitHub Repository**](https://github.com/Azure/Azure-Sentinel)

---

## Use Cases

- Detect credential theft, lateral movement, and insider threats  
- Automate phishing response across Defender for Office 365 and Entra ID  
- Integrate third-party threat intelligence feeds  
- Enable alert enrichment using Logic Apps or Defender for Endpoint context  
- Surface risky entities using User and Entity Behavior Analytics (UEBA)

---

## 📦 Architecture Best Practices

- Centralize collection via [Log Analytics Workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview)  
- Use [**sentinel content hub**](https://learn.microsoft.com/en-us/azure/sentinel/sentinel-solutions-deploy) to deploy rules, playbooks, and parsers  
- Tag and group incidents for triage  
- Segment by tenant/workload using workspaces or tables  
- Use [**Microsoft Sentinel Deployment Best Practices**](https://learn.microsoft.com/en-us/azure/sentinel/best-practices) as a deployment guide

---

## Roles & Permissions

| Role                        | Responsibility |
|-----------------------------|----------------|
| **Microsoft Sentinel Contributor** | Full access to manage Sentinel resources |
| **Microsoft Sentinel Reader**      | View-only access |
| **Entra ID Security Reader**       | View user & group security configuration |
| **Automation Operator**            | Trigger playbooks and automation |
| **Log Analytics Contributor**      | Manage tables and ingestion pipelines |

---

## 🎯 Hunting & Detection

- Use built-in hunting queries or write your own in KQL  
- [Create custom analytics rules](https://learn.microsoft.com/en-us/azure/sentinel/tutorial-detect-threats-custom)  
- Implement detection rules mapped to MITRE ATT&CK  
- Automate response with playbooks (e.g., auto-disable users, open tickets, send alerts)

---

## Essential Resources

- [Microsoft Sentinel Documentation](https://learn.microsoft.com/en-us/azure/sentinel/)
- [List of Data Connectors](https://learn.microsoft.com/en-us/azure/sentinel/connect-data-sources)
- [Built-in Hunting Queries](https://learn.microsoft.com/en-us/azure/sentinel/hunting-overview)
- [Microsoft Sentinel GitHub](https://github.com/Azure/Azure-Sentinel)
- [MITRE ATT&CK Integration](https://learn.microsoft.com/en-us/azure/sentinel/mitre-framework)

---

## Recommended Reading for Roles

### Administrators

- [Pre-deployment checklist](https://learn.microsoft.com/en-us/azure/sentinel/onboard-prerequisites)  
- [Workspace architecture](https://learn.microsoft.com/en-us/azure/sentinel/best-practices-workspace-architecture)  
- [Costs and billing](https://learn.microsoft.com/en-us/azure/sentinel/billing)  
- [MSSP configuration](https://learn.microsoft.com/en-us/azure/sentinel/mssp-protect-ip)

### Analysts

- [Recommended playbooks](https://learn.microsoft.com/en-us/azure/sentinel/tutorial-respond-threats-playbook)  
- [Handle false positives](https://learn.microsoft.com/en-us/azure/sentinel/detect-false-positives)  
- [Detect out-of-the-box threats](https://learn.microsoft.com/en-us/azure/sentinel/tutorial-detect-threats-siem)  
- [Hunting & KQL tips](https://learn.microsoft.com/en-us/azure/sentinel/hunting-overview)

---