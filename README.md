# Learning HashiCorp Vault 

The purpose of this repo was to setup and learn the Architecture and flow of HashiCorp Vault. 


## Prerequisites 
- AWS account 
- AWS Access Key and Secret Access Key ID 
- awscli
- ansible installed on client machine 
- terraform 

## Usage 

By default this will spin up a 1 node vault/consul with UI in a sealed state. To provision run: 

```
terraform plan 
terraform apply 
```

This will then ouput the IP of the node and the DNS name of Application Load Balancer for Vault UI 

## Getting started with Vault Node 
Login to vault node and run the following to get started with the Vault application. 

``` 
[ec2-user@IP_ADDRESS ~]$ export VAULT_ADDR='http://127.0.0.1:8200'  
[ec2-user@IP_ADDRESS ~]$ vault operator init                                                                                                                
Unseal Key 1: ********************************************                                                                                                    
Unseal Key 2: ********************************************                                                                                                    
Unseal Key 3: ********************************************                                                                                                    
Unseal Key 4: ********************************************                                                                                                    
Unseal Key 5: ********************************************                                                                                                    
                                                                                                                                                              
Initial Root Token: **************************                                                                                                                
                                                                                                                                                              
Vault initialized with 5 key shares and a key threshold of 3. Please securely                                                                                 
distribute the key shares printed above. When the Vault is re-sealed,                                                                                         
restarted, or stopped, you must supply at least 3 of these keys to unseal it                                                                                  
before it can start servicing requests.                                                                                                                       
                                                                                                                                                              
Vault does not store the generated master key. Without at least 3 key to                                                                                      
reconstruct the master key, Vault will remain permanently sealed!                                                                                             
                                                                                                                                                              
It is possible to generate new unseal keys, provided you have a quorum of                                                                                     
existing unseal keys shares. See "vault operator rekey" for more information.                                                                                 
```

The above command will initilize the Vault Application. You will then need to save all Unseal Keys in a safe place. You will need them to unseal the cluster. By default the unseal threshold is 3. To unseal run: 

```
vault operator unseal 
```

Once the vault is unsealed you can check the status and login the root token* that was given at initilzation time.

```
vault status
vault login 
Token (will be hidden): 
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                **************************
token_accessor       ************************
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```

Huzzah! You are now logged in and ready to play with vault. I followed the references below as well the provided resources [here](https://learn.hashicorp.com/vault) 

## Resources 
- [Vault LDAP auth](https://www.vaultproject.io/docs/auth/ldap.html)
- [Vault App Role](https://learn.hashicorp.com/tutorials/vault/approle)
- [Vault Architecture-tutorial](https://learn.hashicorp.com/tutorials/vault/reference-architecture?in=vault/day-one-consul#best-case-architecture)
- [Vault Architecture-docs](https://www.vaultproject.io/docs/internals/architecture.html)
- [Security Hardening](https://learn.hashicorp.com/tutorials/vault/production-hardening?in=vault/day-one-consul)
- [Vault Security](https://www.vaultproject.io/docs/internals/security.html)
- [Vault Deployment Guide (w Consul)](https://learn.hashicorp.com/tutorials/vault/deployment-guide?in=vault/day-one-consul)
- [Consul Deployment Guide](https://learn.hashicorp.com/tutorials/consul/deployment-guide)
- [Vault CaC (Configuration as Code)](https://www.hashicorp.com/blog/codifying-vault-policies-and-configuration)

How to assign a vault policy to a ldap group/user
https://stackoverflow.com/questions/64106846/how-to-assign-a-vault-policy-to-a-ldap-group-user

Using HashiCorp Vault 
https://shapeshed.com/hashicorp-vault-ldap/

Using ldap and HashiCorp Vault 
https://xmj.github.io/articles/sysa dmin/vault_and_activedirectory.html

signed ssh certs
https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates

LDAP api 
https://www.vaultproject.io/api/auth/ldap
https://www.vaultproject.io/docs/auth/ldap.html

Using Chef and Vault 
- https://blog.alanthatcher.io/integrating-chef-and-hashicorp-vault/
- https://blog.chef.io/manage-secrets-with-chef-and-hashicorps-vault
- https://shadow-soft.com/using-chef-hashicorp-vault-for-secrets-management/
- https://www.hashicorp.com/blog/using-hashicorps-vault-with-chef
