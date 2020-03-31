
# BankingAPI ![.github/workflows/elixir.yml](https://github.com/andrepaes/api_banking/workflows/.github/workflows/elixir.yml/badge.svg) [![Coverage Status](https://coveralls.io/repos/github/andrepaes/api_banking/badge.svg?branch=master)](https://coveralls.io/github/andrepaes/api_banking?branch=master)

## Introduction

This api has two main contexts: Accounts and Backoffice. 

Accounts will take care about bank transactions like withdraw and transfer money and the Backoffice take care about operational area that will get some reports and etc.

The balance account can't be negative, the account can't transfer money for yourself and the amount of money to transfer and withdraw can't be negative too

## Setup

There is a Makefile that call some docker commands to start the application and test it.

To start the application:
> make up

To start application in iterative mode:
> make up-iterative

To run application tests the application:
> make test

To stop the containers:
> make down

## Deployment

The api use the github actions for CI/CD and is is hosted at https://gigalixir.com/ on a free plan.
The public endpoint is: https://stone-banking-api.gigalixirapp.com/api/v1

A api example of utilization is provided here: 

[![Run in Insomnia}](https://insomnia.rest/images/run.svg)](https://insomnia.rest/run/?label=banking-api&uri=https%3A%2F%2Fraw.githubusercontent.com%2Fandrepaes%2Fapi_banking%2Fmaster%2FInsomnia.json)

The above insomnia config file provide a dev and prod environment, so if you want to try it on localhost, just use the "dev" environment variable or use the "prod" environment variable to consume the public endpoint

**important node: The only endpoints that is not protected by the auth mechanism is: accounts/sign-up, accounts/sign-in, backoffices/sign-up, backoffices/sign-in. To access the others endpoints you need to pass a bearer token provided by the [resource]/sign-in endpoint, just copy the token and paste inside Auth > Bearer Token.**
