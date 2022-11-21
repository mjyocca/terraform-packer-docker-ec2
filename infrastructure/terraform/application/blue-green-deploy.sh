#!/bin/bash
CURRENT_STACK=$1
NEW_STACK=$2

# Provision both blue/green stacks
terraform apply \
-var "traffic_distribution=$CURRENT_STACK" \
--auto-approve

sleep 15

## Health Checks Here
for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

terraform apply \
-var "traffic_distribution=$CURRENT_STACK-90" \
--auto-approve

sleep 15

## Health Checks Here
for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

terraform apply \
-var "traffic_distribution=split" \
--auto-approve

sleep 15

## Health Checks Here
for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

terraform apply \
-var "traffic_distribution=$NEW_STACK" \
--auto-approve

sleep 15

## Health Checks Here
for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

## Scale Down Previous Setack
terraform apply \
-var "traffic_distribution=$NEW_STACK" \
-var "enable_${CURRENT_STACK}_env=false" \
--auto-approve
