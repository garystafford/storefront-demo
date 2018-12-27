#!/usr/bin/env python3

# Create sample data by hitting Storefront sample endpoints,

# usage: python3 ./refresh.py

from pprint import pprint
import requests
import time


def main():
    create_sample_data()


def create_sample_data():
    storefront_api_url = 'http://api.dev.storefront-demo.com'
    sample_urls = [
        'accounts/customers/sample',
        'orders/customers/sample/orders',
        'orders/customers/sample/fulfill',
        'fulfillment/fulfillments/sample/process',
        'fulfillment/fulfillments/sample/ship',
        'fulfillment/fulfillments/sample/in-transit',
        'fulfillment/fulfillments/sample/receive']

    for sample_url in sample_urls:
        r = requests.get(storefront_api_url + '/' + sample_url)
        print(r.text)
        time.sleep(5)
    print('\n')


if __name__ == "__main__":
    main()
