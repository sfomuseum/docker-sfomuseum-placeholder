import * as cdk from "@aws-cdk/core";
import * as ec2 from "@aws-cdk/aws-ec2";
import * as ecs from '@aws-cdk/aws-ecs';
import * as ecs_patterns from '@aws-cdk/aws-ecs-patterns';
import { config } from "dotenv";
config();

var nextzen = process.env.PLACEHOLDER_NEXTZEN_APIKEY || "123456";

class EcsGoPlaceholderStack extends cdk.Stack {
    constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps){
        super(scope, id, props);

        const vpc = new ec2.Vpc(this, 'vpc', { 
            cidr: '10.0.0.0/16',
            maxAzs: 2,
            natGateways: 0,
            subnetConfiguration: [
            {
                name: 'public-subnet-1',
                subnetType: ec2.SubnetType.PUBLIC,
                cidrMask: 24,
              },
            ]
        });

        const cluster = new ecs.Cluster(this, 'Cluster', { vpc });

        const fargateService = new ecs_patterns.ApplicationLoadBalancedFargateService(this, "FargateService", {
            cluster,
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

        new cdk.CfnOutput(this, 'LoadBalancerDNS', { value: fargateService.loadBalancer.loadBalancerDnsName });
    }
}

const app = new cdk.App();
new EcsGoPlaceholderStack(app, "EcsGoPlaceholderStack", {
    env: {
        account: process.env.AWS_ACCOUNT_ID,
        region: process.env.AWS_REGION,
    }
});
