# Endava Devops Challenge

## Task description
1) Fork this repository
2) Choose a free Cloud Service Provider and register a free account with AWS, Azure, etc. or run VirtualBox/VMware Player locally
3) Provision an Application stack running Apache Mysql PHP, each of the service must run separately on a node - virtual machine or container 
4) Automate the provisioning with the tools you like to use - bash, puppet, chef, Ansible, etc.
5) Implement service monitoring either using free Cloud Service provider monitoring or Datadog, Zabbix, Nagios, etc.
6) Automate service-fail-over, e.g. auto-restart of failing service
7) Document the steps in git history and commit your code
8) Present a working solution, e.g. not a powerpoint presentation, but a working demo

## Time Box 
The task should be completed within 5 days. 

## Time accounting
1. 3h research work
2. 4h initial implementation of terraform
3. 5h initial playbook implementation
4. 2h Updates and fixes for playbook and terraform templates
5. 3h for v2 implementation work

## Solution 1
This is a simple fault-tolerant solution in case of failure of single host from single group or in case of data center ( availability zone ) failure. Every node from each group is placed in one or the other availability zone
Automation tools used :
- Terraform - to create the base setup of the network in 2 availability zones in AWS with resource creation and provisioning
- Ansible - for config management and application deployment to setup each node

### Steps
1. Install AWS cli tool and configure your credentials. We need this for our terraform tool
2. Update main.tf file with your SSH key name, region, Route53 zone-id, domain name
3. Execute terraform ( init, plan, apply ) in region-former directory
4. Copy results in app-playbook/hosts file ( dbserver to -> dbservers group, lbserver to -> lbservers group, lbserver to -> webservers group, nagios to -> monitoring group
5. Execute command "ansible-playbook -i hosts site.yml" from directory "app-playbook"
6. Enjoy simple php page by visiting "nkalev.domain.com"
7. Go to "nagios.domain.com" for monitoring view ( use credentials : nagiosadmin / nagiosadmin )

### TODO
- Implement auto-scaling group to use the functionality of auto recovery of a host
- link ansible and terraform ( maybe even extend ansible for relevant parts to manage AWS resources )

## Solution 2
This solution is a bit more complex in nature, but it is fully tollerant to multiple failures from a single or multiple groups. It has the ability to auto-heal and recover hosts and applications
Automation tools used :
- Terraform - to provision and create our base setup, auto-scaling group, resource creation and provisioning
- Ansible - for config management and application deployment to setup each node
- Kubernetes - for automating deployment, scaling and management of containerized applications
- Docker - container technology that we can deply in a single kubernetes pod ( or multiple containers in single pod )
- Istio - service mesh and traffic managemen

### TODO
- Implement terraform base setup and configuration
- Complete application setup of apache, php and mysql stack using docker containers
- Ansible playbook additions for apache, php,mysql and prometheus
- Correct wiring of all services using istio ( possibility to do blue / green setup )
