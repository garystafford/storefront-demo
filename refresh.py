#!/usr/bin/env python3

# python3 ./refresh.py

from pprint import pprint
from pymongo import MongoClient
import requests
import time

client = MongoClient('mongodb://localhost:27017/')

def main():
    delete_databases()
    delete_topics()
    create_sample_data()

    get_accounts_docs()
    get_orders_docs()
    get_fulfillment_docs()

def delete_databases():
    client = MongoClient('mongodb://localhost:27017/')
    dbs = ['accounts', 'orders', 'fulfillment']
    for db in dbs:
        client.drop_database(db)

    dbs = client.database_names()
    print('databases:')
    print(dbs)


def delete_topics():
    topics = ['accounts.customer.change',
              'orders.order.fulfill', 'fulfillment.order.change']
    for topic in topics:
        kafka_manager_url = 'http://localhost:9000/clusters/dev/topics/delete?t=' + topic
        r = requests.post(kafka_manager_url, data={'topic': topic})
        time.sleep(3)
        print('Kafka topic deleted: ' + topic)

def create_sample_data():
    sample_urls = [
        'http://localhost:8085/customers/sample',
        'http://localhost:8090/customers/sample/orders',
        'http://localhost:8090/customers/fulfill',
        'http://localhost:8095/fulfillment/sample/process',
        'http://localhost:8095/fulfillment/sample/ship',
        'http://localhost:8095/fulfillment/sample/in-transit',
        'http://localhost:8095/fulfillment/sample/receive']

    for sample_url in sample_urls:
        r = requests.get(sample_url)
        print(r.text)
        time.sleep(3)

def get_accounts_docs():
    db = client['accounts']
    collection = db['customer.accounts']
    cursor = collection.find()
    for document in cursor:
      pprint(document)

def get_orders_docs():
    db = client['orders']
    collection = db['customer.orders']
    cursor = collection.find()
    for document in cursor:
      pprint(document)

def get_fulfillment_docs():
    db = client['fulfillment']
    collection = db['fulfillment.requests']
    cursor = collection.find()
    for document in cursor:
      pprint(document)

if __name__ == "__main__":
    main()
