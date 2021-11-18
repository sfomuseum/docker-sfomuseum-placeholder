import * as cdk from "@aws-cdk/core";
import * as ec2 from "@aws-cdk/aws-ec2";
import * as ecs from '@aws-cdk/aws-ecs';
import * as ecs_patterns from '@aws-cdk/aws-ecs-patterns';
import { config } from "dotenv";
config();

var nextzen = process.env.PLACEHOLDER_NEXTZEN_APIKEY || "123456";
var vpcID = process.env.VPC_ID || "123456";

class EcsGoPlaceholderStack extends cdk.Stack {
    constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps){
        super(scope, id, props);

        // This looks up your existing VPC by ID provided in the .env file.
        // Be sure to check if your existing VPC is a "Default VPC" or not and adjust the parameter below.
        const vpc = ec2.Vpc.fromLookup(this, 'vpc', {
            isDefault: true,
            vpcId: vpcID
        })

        const cluster = new ecs.Cluster(this, 'Cluster', { vpc });

        cluster.addCapacity('DefaultAutoScalingGroupCapacity', {
            // Here is where you can select the instance type you want to use and desired count for the auto-scaling-group. 
            // You might want to use something smalled, or try the Graviton2 type instance family.
            instanceType: new ec2.InstanceType("m6i.large"),
            desiredCapacity: 1,
        });

        const ec2Service = new ecs_patterns.ApplicationLoadBalancedEc2Service(this, "EC2Service", {
            cluster,
            // here is where you can adjust the memory limit for each task
            memoryLimitMiB: 1024,
            taskImageOptions: {
                image: ecs.ContainerImage.fromAsset(`${__dirname}`),
                containerPort: 8080,
                environment: {
                    DEPLOYED_DATE: Date.now().toLocaleString(),
                    PLACEHOLDER_NEXTZEN_APIKEY: nextzen
                }
            },
            desiredCount: 1
        });

        new cdk.CfnOutput(this, 'LoadBalancerDNS', { value: ec2Service.loadBalancer.loadBalancerDnsName });
    }
}

const app = new cdk.App();
new EcsGoPlaceholderStack(app, "EcsGoPlaceholderStack", {
    env: {
        account: process.env.AWS_ACCOUNT_ID,
        region: process.env.AWS_REGION,
    }
});
