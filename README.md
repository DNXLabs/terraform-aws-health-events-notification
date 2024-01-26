# terraform-aws-health-events-notification

[![Lint Status](https://github.com/DNXLabs/terraform-aws-template/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-template/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-template)](https://github.com/DNXLabs/terraform-aws-template/blob/master/LICENSE)

Terraform module to configure AWS EventBridge Rules and SNS Notifications for AWS Personal Health Dashboard

The following resources will be created:

 - Event Bridge
   - You can use a defaut event pattern or a custom event pattern, where you can select which services you want monitor
      - Amazon ECR image scanning helps in identifying software vulnerabilities in your container images.
 - SNS topics / Subscriptions


You can enable organizational view from the AWS Health console. You must sign in to the management account of your AWS organization.
To view the AWS Health Dashboard for your organization

    Open your AWS Health Dashboard at https://health.aws.amazon.com/health/home

In the navigation pane, under Your organization health, choose Configurations.

On the Enable organizational view page, choose Enable organizational view.

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

No provider.

## Inputs

No input.

## Outputs

No output.

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-template/blob/master/LICENSE) for full details.