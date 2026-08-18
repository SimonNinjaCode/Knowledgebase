# 🚀 Security Copilot Capacity Deployment

This project outlines the deployment process for provisioning **Microsoft Security Copilot Capacity Units (SCUs)** in Azure using PowerShell and ARM templates.

It includes steps for:

- Authenticating to Azure with tenant and subscription context
- Creating resource groups
- Deploying Security Copilot capacity resources
- Cleaning up deployments for cost and billing optimization
- Recreating resources to ensure accurate billing tracking

---

## 📦 What’s Included

- [deploy-scu.ps1](./deploy-scu.ps1) – PowerShell script to automate deployment  
- [template.json](./template.json) – ARM template for capacity resource  
- [parameters.json](./parameters.json) – Parameter values for deployment  

---

## 🧰 Requirements

- Azure PowerShell (`Az` module)
- Proper Azure AD permissions and RBAC roles
- ARM template for the Security Copilot capacity resource
- Tenant and subscription IDs

---

## 🧠 Use Cases

- **Demo environments** for showcasing Security Copilot
- **Test setups** for validating SCU deployment
- **Cost tracking & monitoring** for short-term resource lifecycles

---

## 💡 Tips

- Use short-lived deployments to reduce costs
- Monitor SCU usage post-deployment through Azure metrics
- Customize capacity units and geo settings as needed

---
