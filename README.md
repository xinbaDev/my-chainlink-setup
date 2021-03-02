# My chainlink setup

My goal for this project is to create a secure, highly available, easy to setup/maintain and cost efficient setup. I hope it serves as a starting point for people who are new to chainlink to create their own setups. The project is currently in early development stage and not production ready yet, there are still many features/improvements I want to make and there might be bugs in code(hopefully not). You have been warned:).

## My chainlink node infrastructure

This setup is built with the [Best Security and Operating Practices](https://docs.chain.link/docs/best-security-practices) in mind.

* Security
  - [x] Restricting Access. Servers can only be accessed through vpn(wireguard).
  - [x] Credentials are encrypted and stored in the cloud.
  - [x] Servers are secured by security groups. Only traffic from inside the vpc are allowed.

* Monitoring
  - [x] Prometheus + Grafana for both application and infrastructure monitoring.
  - [x] Alertmanger + Telegram for alarm notification.
  - [x] Cloudwatch for AWS RDS monitoring.

* High availability
  - [x] At least two Chainlink nodes in different availability zones are running at any one time to ensure failover if one fails.
  - [x] Running PostgreSql db by using aws rds, which offers auto failover, auto backup, and more.
  - [x] Infrastructure as code(IaC).  It is relatively easy to run the whole infrastructure in another region at the same time, which further improve availability.
  - [ ] Set up a load balancer for Ethereum client (still working on it, I think it maybe deserves a separate project).

* Cost efficient
  - [x] All servers are launched in a region where the price is relatively cheap.
  - [x] Thanks to IaC, the whole infrastructure can be spinned up/teared down in minutes, which saves me time/money when testing.
  - [x] Try to avoid using expensive tools/services(kubernetes/natgateway) to minimize infrastructure cost.

## How to setup

### 1. Setup aws programmatic access

#### 1.1 Install aws-cli

- Follow [this doc](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html) to install aws cli.

#### 1.2 Create cloud credentials

- Follow [this video](https://www.youtube.com/watch?v=FOK5BPy30HQ), get your keys as below :
  ```
  AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXX
  AWS_SECRET_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ```
- use command ```aws configure``` to save the keys to your local machine.

### 2. Generate an aws ec2 keypair

- Follow [this doc](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) to create keypair. The key is needed to ssh into your servers.Replace the public key in aws_key_pair(In ```key.tf```) with the newly generated one.

### 3. Install wireguard

- Install the WireGuard tools for your OS: https://www.wireguard.com/install/
- Generate a key pair for client
  - `wg genkey | tee client1-privatekey | wg pubkey > client1-publickey`
- Generate a key pair for the server
  - `wg genkey | tee server-privatekey | wg pubkey > server-publickey`
- Add the server private key to the AWS SSM parameter: `/wireguard/wg-server-private-key`
    ```
    AWS_REGION=us-east-1
    aws ssm put-parameter --region $AWS_REGION --name /wireguard/wg-server-private-key --type SecureString --value $ServerPrivateKeyValue
    ```
- Replace the client public key in wg_client_public_keys map with your own key(in ```variables.tf```).

    ```
    variable "wg_client_public_keys" {
      description = "List of maps of client IPs and public keys."
      default = [
        { "192.168.200.200/32" = "<Replace with your client public key>" },
      ]
    }
    ```

### 4. Create telegram bot for notification

* Create Telegram bot with [BotFather](https://t.me/BotFather), it will return your bot token(it will be used in step 6)
* Follow [this StakeOverflow answer](https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id) to get chat id

### 5. Upload credentials to cloud

Replace the value below with your own

```sh

AWS_REGION=us-east-1
# db password
aws ssm put-parameter --region $AWS_REGION --name /db/passwd --type SecureString --value $YOUR_DB_PASSWD

# chainlink node admin password
aws ssm put-parameter --region $AWS_REGION --name /linknode/admin_passwd --type SecureString --value $YOUR_ADMIN_PASSWD

# chainlink node wallet password
aws ssm put-parameter --region $AWS_REGION --name /linknode/wallet_passwd --type SecureString --value $YOUR_WALLET_PASSWD

# telegram bot token
aws ssm put-parameter --region $AWS_REGION --name /monitor/telegram_bot_token --type SecureString --value $YOUR_TELEGRAM_TOKEN
```

### 6. Set variables

In ```variables.tf```, there are currently two variables that needed to be configured. One is ```telegram_chat_id``` and the other is ```eth_url```.
If you have no idea what eth_url is, please check [this doc](https://docs.chain.link/docs/running-a-chainlink-node#ethereum-client-on-the-same-machine) and [this doc](https://docs.chain.link/docs/run-an-ethereum-client#a-hrefhttpsinfuraiodocsethereumwssintroductionmd-target_blankinfuraa). 

### 7. Install terraform

Follow [this doc](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install.

### 8. Deploy

In project root folder, run
```sh
terraform init
terraform apply
```

## How to access

After the deployment is completed, replace endpoint ip in the wireguard client config with the ```vpn_ip``` shown on the screen.

Your wireguard client config(wg0.conf) should look something like below:
```sh
[Interface]
PrivateKey = <Your Client Private Key>
Address = 192.168.200.200/32

[Peer]
PublicKey = <Your VPN Server Public Key>
Endpoint = <vpn_ip>:51821
AllowedIPs = 0.0.0.0/0
```

After connecting to your vpn server, you should be able to access the following servers:

- chainlink node:
  - http://192.168.11.11:6688 or http://192.168.12.12:6688 (it depends on which node connects to db first)
  - The default admin email is user@test.com, which can be changed in ```variables.tf```, use the password you created
    in step 5 to login.
- monitor:
  - grafana: http://192.168.11.222:3000 (using the default admin account to login)
  - prometheus: http://192.168.11.222:9090
  - alertmanager: http://192.168.11.222:9093


## Clean up

You can easily tear down the whole infrastructure by running ```terraform destroy```. But before that, don't forget to ***diconnect from your wireguard*** first, otherwise it will fail.
