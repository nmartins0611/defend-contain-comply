# Defend, Contain, Comply

An Ansible Automation Platform workshop for vulnerability management on RHEL.

Participants manage a complete vulnerability lifecycle — from CVE detection through automated containment to compliant container delivery — using AAP Controller, Event-Driven Ansible, and Podman.

## Workshop Structure (120–150 min)

| Module | Title | Duration | Key Concepts |
|--------|-------|----------|--------------|
| 1 | **DEFEND** — Detect and Contain | ~45 min | EDA rulebooks, webhook sources, containment workflows |
| 2 | **CONTAIN** — Patch and Enforce | ~45 min | Workflow templates, approval nodes, policy-as-code |
| 3 | **COMPLY** — Secure Supply Chain | ~30 min | Podman builds, image scanning, registry push |

## Scenario

You are a platform engineer at **Benekratis Capital**. A Splunk alert fires: a critical CVE affects your customer-facing RHEL application server running `httpd`. No patch exists yet — you must contain the threat. When a patch becomes available you enforce policy-gated remediation. Finally you containerize the hardened application for immutable deployment.

## Repository Layout

```
setup/              Pre-work playbooks (run by framework provisioner)
  deploy-central-services.yml   Splunk + OPA containers on central
  configure-errata-repo.yml     Yum errata repo on central
  configure-app-server.yml      Vulnerable httpd + SELinux on rhel01
  configure-aap.yml             AAP job/workflow templates
  configure-eda.yml             EDA rulebook activation
  configure-vault.yml           Vault KV paths
  configure-splunk-alerts.yml   Splunk saved searches + webhook
  main.yml                      Master orchestrator
  vars/workshop.yml             Shared variables
  files/                        updateinfo.xml, OPA policies
  templates/                    Jinja2 templates (errata-repo.repo.j2)
playbooks/          Ansible playbooks organized by exercise
  defend/           Exercise 1: scan, contain, harden
  contain/          Exercise 2: pre-patch, patch, verify, report
  comply/           Exercise 3: build, scan, push container
rulebooks/          Event-Driven Ansible rulebook definitions
policies/           Policy-as-code gate definitions
templates/          Jinja2 templates, sample payloads, Containerfile
inventory/          Workshop inventory (workshop.yml)
collections/        Galaxy collection requirements
NotUsed/            Unused files from initial scaffolding
```

## Prerequisites

- AAP Controller 2.5+
- EDA Controller
- RHEL 9 target host (with httpd installed)
- Podman + local container registry
- Collections listed in `collections/requirements.yml`

## Quick Start

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

## License

Apache-2.0
