# Provisioner Configuration

This directory will contain the RHDP (Red Hat Demo Platform) / AgnosticD provisioner configuration for deploying the workshop lab environment.

## Target Architecture

```
┌─────────────────────────────────────────────────────┐
│                   RHDP Deployment                    │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────────┐  ┌──────────────┐                │
│  │ AAP          │  │ EDA          │                │
│  │ Controller   │  │ Controller   │                │
│  │ (2.5+)       │  │              │                │
│  └──────────────┘  └──────────────┘                │
│                                                     │
│  ┌──────────────────────────────────────────┐      │
│  │ RHEL 9 App Server                        │      │
│  │ - httpd (vulnerable → patched)           │      │
│  │ - Podman + local registry                │      │
│  │ - Custom yum repo (staged errata)        │      │
│  └──────────────────────────────────────────┘      │
│                                                     │
│  ┌──────────────┐                                  │
│  │ Showroom     │                                  │
│  │ (lab guide)  │                                  │
│  └──────────────┘                                  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Provisioner Workloads (AgnosticV)

When ready to deploy to RHDP, configure the following workloads:

```yaml
# VM-based showroom deployment
workloads:
  - agnosticd.showroom.vm_workload_showroom

showroom_git_repo: https://github.com/<org>/defend-contain-comply.git
showroom_git_ref: main
showroom_content_antora_playbook: site.yml
```

## Required Pre-staging

The provisioner must:

1. Install `httpd-2.4.57-5.el9` on app-server (vulnerable version)
2. Configure a custom yum repo containing `httpd-2.4.62-1.el9` (patched)
3. Deploy AAP Controller with:
   - Project pointing to this repository
   - Inventory matching `inventory/workshop.yml`
   - Machine credential for app-server SSH
   - Job templates for all playbooks
   - Workflow templates: "Vulnerability Containment" and "Policy-Gated Patching"
4. Deploy EDA Controller with:
   - Rulebook activation for `rulebooks/splunk-cve-alert.yml`
   - Controller token for triggering AAP workflows
   - Webhook token for authentication
5. Install Podman and configure registry container on app-server

## Environment Variables Exposed to Showroom

| Variable | Description |
|----------|-------------|
| `DOMAIN` | Base domain for service URLs |
| `EDA_WEBHOOK_TOKEN` | Token for authenticating webhook calls to EDA |
| `aap_admin_password` | AAP Controller admin password |
| `eda_admin_password` | EDA Controller admin password |
| `app_server_ip` | IP of the RHEL target host |

## Status

**Not yet implemented** — this is a placeholder for future RHDP onboarding. The workshop content and playbooks are functional and can be delivered with manual environment setup.
