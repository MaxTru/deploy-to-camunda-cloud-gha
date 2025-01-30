# deploy-to-camunda-cloud-gha

A simple GitHub Action to deploy to Camunda 8 SaaS.

## Compatibility

This action is compatible with [Camunda 8.6+ SaaS](https://docs.camunda.io/docs/guides/).

It is currently not set-up for self-managed deployments (but that can be easily added if needed).

## Example usage

You can use this action to for example deploy `process.bpmn` and `form.form` to Camunda SaaS on every change on the `main` branch by setting up the following GitHub action.

```yml
name: Deploy BPMN to Cloud

on:
  push:
    branches:
      - main
    paths:
      - 'process.bpmn'
      - 'form.form'

jobs:
  deploy-to-cloud:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Deploy to Camunda Cloud
        uses: MaxTru/deploy-to-camunda-cloud-gha@v0.1.3
        with:
          client_id: ${{ secrets.CLIENT_ID }}
          client_secret: ${{ secrets.CLIENT_SECRET }}
          region: cluster-region
          cluster_id: cluster-id
          files: 'process.bpmn,form.form'
```