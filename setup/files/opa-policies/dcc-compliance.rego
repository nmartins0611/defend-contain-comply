package dcc.compliance

# DCC Workshop Compliance Policy
#
# Evaluates host security posture for the Defend, Contain, Comply workshop.
# Input: JSON object with host facts collected by Ansible or the scan playbook.
#
# Example input:
#   {
#     "httpd_version": "2.4.57-5.el9",
#     "patched_version": "2.4.62-1.el9",
#     "selinux_mode": "Enforcing",
#     "open_cves": ["CVE-2024-38476"],
#     "backup_age_hours": 12,
#     "patch_approved": false,
#     "firewall_active": true
#   }

import rego.v1

default compliant := false

default httpd_vulnerable := false

default selinux_enforcing := false

default backup_current := false

default firewall_active := false

# httpd is vulnerable when installed version does not match patched version
httpd_vulnerable if {
	input.httpd_version != input.patched_version
}

# SELinux must be in enforcing mode
selinux_enforcing if {
	input.selinux_mode == "Enforcing"
}

# Backup is current if taken within 24 hours
backup_current if {
	input.backup_age_hours < 24
}

# Firewall must be active
firewall_active if {
	input.firewall_active == true
}

# Patch is approved for application
patch_approved if {
	input.patch_approved == true
}

# Collect all findings as a set of objects
findings contains finding if {
	httpd_vulnerable
	finding := {
		"rule": "httpd_vulnerable",
		"severity": "critical",
		"message": sprintf("httpd %s has known vulnerabilities; patched version is %s", [input.httpd_version, input.patched_version]),
	}
}

findings contains finding if {
	not selinux_enforcing
	finding := {
		"rule": "selinux_enforcing",
		"severity": "high",
		"message": sprintf("SELinux is %s, must be Enforcing", [input.selinux_mode]),
	}
}

findings contains finding if {
	not backup_current
	finding := {
		"rule": "backup_current",
		"severity": "medium",
		"message": sprintf("Last backup was %d hours ago, exceeds 24h threshold", [input.backup_age_hours]),
	}
}

findings contains finding if {
	not firewall_active
	finding := {
		"rule": "firewall_active",
		"severity": "high",
		"message": "Host firewall is not active",
	}
}

findings contains finding if {
	some cve in input.open_cves
	finding := {
		"rule": "open_cve",
		"severity": "critical",
		"message": sprintf("Unresolved CVE: %s", [cve]),
	}
}

# Host is compliant when no critical or high findings exist
compliant if {
	not httpd_vulnerable
	selinux_enforcing
	backup_current
	firewall_active
	count(input.open_cves) == 0
}

# Summary for API consumers
result := {
	"compliant": compliant,
	"findings": findings,
	"finding_count": count(findings),
}
