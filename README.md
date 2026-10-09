# **README.md – Problem 6 Reflection**

**Student Name:** Farhan Sabbir Siddique  
**Option Chosen:** Option B – NGINX Load Balancer (local)  
Assignment: Assignment 8: High-Availability Web Service with Load Balancing

# **Problem 6 – Reflection**

## **1\. Solution Comparison: AWS ALB vs. NGINX**

The local NGINX solution and AWS Application Load Balancer (ALB) offer distinct trade-offs:

* **NGINX (Local Containerized Setup):**  
  * **Advantages:** Zero financial cost, lightweight resource usage, complete control over raw configuration files (`nginx.conf`), and immediate offline debugging capabilities without needing cloud infrastructure or credentials.  
  * **Limitations:** Requires manual maintenance, lacks native autoscaling, and requires custom configuration for advanced capabilities like SSL management, dynamic target discovery, and high-availability failover.  
* **AWS ALB (Cloud Managed Setup):**  
  * **Advantages:** Fully managed serverless service with native multi-AZ high availability, seamless integration with AWS Auto Scaling Groups, automated AWS Certificate Manager (ACM) SSL offloading, and built-in CloudWatch metrics.  
  * **Limitations:** Incurs ongoing cloud infrastructure costs (hourly base rates plus LCU usage), introduces vendor lock-in to AWS, and provides less granular visibility into low-level proxy mechanics compared to self-managed configuration files.

## **2\. Load Balancer Failure & Single Point of Failure (SPOF) Mitigation**

If a standalone load balancer node (such as the single `nginx-lb` container) fails, all client traffic is immediately blocked, resulting in a complete service outage despite backend servers remaining functional. In a single-node configuration, the load balancer represents a critical Single Point of Failure (SPOF).

In enterprise production environments, this issue is resolved using multi-tiered high-availability strategies:

* **Active-Passive / Active-Active Clusters:** Running redundant NGINX nodes with floating Virtual IP (VIP) addresses managed by daemon protocols like Keepalived and VRRP (Virtual Router Redundancy Protocol). If the primary node fails, the VIP instantly shifts to a secondary standby node.  
* **DNS-Level Load Balancing & Anycast:** Utilizing Global Server Load Balancing (GSLB) or DNS routing (e.g., AWS Route 53 with health-check failover policy) to direct traffic across multiple load balancer IP addresses spanning different data centers.  
* **Managed Cloud Infrastructure:** Leveraging cloud load balancers (such as AWS ALB), which internally deploy redundant proxy nodes across multiple physical Availability Zones under a single managed endpoint.

## **3\. Challenges Faced & Implementation Solution**

**Problem:** During initial stack deployment with `docker-compose up`, `nginx-lb` launched simultaneously with `nginx-a` and nginx-b. Because the proxy initialized before the backend web servers were fully ready to process HTTP requests, early client requests resulted in temporary 502 Bad Gateway errors. Standard Docker Compose depends\_on only checks container startup status rather than service application readiness.

Solution: I implemented active healthchecks in `docker-compose.yml` for both `nginx-a` and `nginx-b` using `wget --spider -q http://localhost/` running on 10-second intervals. I then updated the depends\_on block for nginx-lb to require condition: service\_healthy for both backends. Additionally, I configured passive health monitoring in nginx.conf via `max_fails=3` and `fail_timeout=10s` within the `upstream backend_cluster` block. This ensured that `nginx-lb` only receives traffic once backend targets are confirmed ready and gracefully drops non-responsive targets without presenting error pages to users.