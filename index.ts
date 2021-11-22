import * as cdk from "@aws-cdk/core";
import * as ec2 from "@aws-cdk/aws-ec2";
import * as ecs from '@aws-cdk/aws-ecs';
import * as ecs_patterns from '@aws-cdk/aws-ecs-patterns';
import { config } from "dotenv";
config();

var nextzenApiKey = process.env.PLACEHOLDER_NEXTZEN_APIKEY || "123456";
var placeholderStaticPrefix = process.env.PLACEHOLDER_STATIC_PREFIX || "";
var vpcID = process.env.VPC_ID || "123456";
var vpcIsDefault = (process.env.VPC_IS_DEFAULT == "true") ? true : false;
var ec2InstanceType = process.env.INSTANCE_TYPE || "123456";

class EcsGoPlaceholderStack extends cdk.Stack {
    constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps){
        super(scope, id, props);

        // This looks up your existing VPC by ID provided in the .env file.
        // Be sure to check if your existing VPC is a "Default VPC" or not and adjust the parameter below.
        const vpc = ec2.Vpc.fromLookup(this, 'vpc', {
            isDefault: vpcIsDefault,
            vpcId: vpcID
        })

        const cluster = new ecs.Cluster(this, 'Cluster', { vpc });

        cluster.addCapacity('DefaultAutoScalingGroupCapacity', {
            // Here is where you can select the instance type you want to use and desired count for the auto-scaling-group. 
            // You might want to use something smalled, or try the Graviton2 type instance family.
            instanceType: new ec2.InstanceType(ec2InstanceType),
            desiredCapacity: 1,
        });

	var ec2Env = {
                    DEPLOYED_DATE: Date.now().toLocaleString(),
                    PLACEHOLDER_NEXTZEN_APIKEY: nextzenApiKey,
	}

	// To do: assign any/all process.env.PLACEHOLDER_ variables
	
	if (placeholderStaticPrefix != "") {
	   ec2Env["PLACEHOLDER_STATIC_PREFIX"] = placeholderStaticPrefix;
	}
	
        const ec2Service = new ecs_patterns.ApplicationLoadBalancedEc2Service(this, "EC2Service", {
            cluster,
            // here is where you can adjust the memory limit for each task
            memoryLimitMiB: 1024,
            taskImageOptions: {
                image: ecs.ContainerImage.fromAsset(`${__dirname}`),
                containerPort: 8080,
                environment: ec2Env,
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
