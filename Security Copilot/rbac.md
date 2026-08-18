# Security Copilot RBAC

To access the Copilot, configure settings, or perform tasks, appropriate permissions must be assigned. Admins with any of the following roles can perform the task of assigning the appropriate permissions to allow access to Copilot:

* Groups Administrator
* User Administrator
* Privileged Role Administrator
* Global Administrator

## Role Permissions

| **Role** | **Permission** |
|----------|----------------|
| **Global Administrator** | * Global admins can perform all kinds of tasks. They have the keys to the kingdom. The person who signed up your organization for Microsoft Copilot for Security is a global administrator by default and can access to the following administrative, and session creation functionalities:<br>   * Global administrator - Manage plugins.<br>   * Opt in or opt out on product improvements and model improvements.<br>   * Configure Microsoft security product availability for users in the tenant. |
| **Global Reader** | A Global reader role is the read-only version of the Global administrator role. Users in this role can read settings and administrative information but can't take management actions. This role has access to the session creation functionality such as asking questions and invoking prompts. |
| **Security Administrator** | * Security administrators have access to the following administrative and session creation functionalities:<br>   * Manage plugins.<br>   * Opt in or opt out on product improvements and model improvements.<br>   * Configure Microsoft security product availability for users in the tenant. |
| **Security Operator / Security Reader** | Security operators or readers have access to session creation functionality such as asking questions and invoking prompts. |