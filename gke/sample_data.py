#!/usr/bin/env python3

# Create sample data by hitting Storefront sample endpoints

# usage: python3 ./refresh.py

from pprint import pprint
import requests
import time


def main():
    create_sample_data()


def create_sample_data():
    storefront_api_url = 'https://api.dev.storefront-demo.com'
    jwt='token.goes.here'

    sample_urls = [
        'accounts/actuator/health',
        'orders/actuator/health',
        'fulfillment/actuator/health',
        'accounts/customers/sample',
        'orders/customers/sample/orders',
        'orders/customers/sample/fulfill',
        'fulfillment/fulfillments/sample/process',
        'fulfillment/fulfillments/sample/ship',
        'fulfillment/fulfillments/sample/in-transit',
        'fulfillment/fulfillments/sample/receive']

    headers = {'Authorization': 'Bearer ' + jwt}

    for sample_url in sample_urls:
        request_endpoint = storefront_api_url + '/' + sample_url
        r = requests.get(request_endpoint, headers=headers, verify=False)

        print(request_endpoint + '\n' + r.text + '\n' + '---')
        time.sleep(3)


if __name__ == "__main__":
    main()
