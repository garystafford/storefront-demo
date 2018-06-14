#!/usr/bin/env python3

# python3 ./refresh.py

from pprint import pprint
from pymongo import MongoClient
import requests
import time

client = MongoClient('mongodb://localhost:27017/')

def main():
    # delete_databases()
    # delete_topics()

    create_sample_data()

    get_mongo_doc('accounts', 'customer.accounts')
    get_mongo_doc('orders', 'customer.orders')
    get_mongo_doc('fulfillment', 'fulfillment.requests')

def delete_databases():
    dbs = ['accounts', 'orders', 'fulfillment']
    for db in dbs:
        client.drop_database(db)

    dbs = client.database_names()
    print('Reamining databases:')
    print(dbs)

def delete_topics():
    # call Kafka Manager API
    topics = ['accounts.customer.change',
              'orders.order.fulfill', 'fulfillment.order.change']
    for topic in topics:
        kafka_manager_url = 'http://localhost:9000/clusters/dev/topics/delete?t=' + topic
        r = requests.post(kafka_manager_url, data={'topic': topic})
        time.sleep(3)
        print('Kafka topic deleted: ' + topic)

def create_sample_data():
    sample_urls = [
        'http://localhost:8080/accounts/customers/sample',
        'http://localhost:8080/orders/customers/sample/orders',
        'http://localhost:8080/orders/customers/fulfill',
        'http://localhost:8080/fulfillment/fulfillment/sample/process',
        'http://localhost:8080/fulfillment/fulfillment/sample/ship',
        'http://localhost:8080/fulfillment/fulfillment/sample/in-transit',
        'http://localhost:8080/fulfillment/fulfillment/sample/receive']

    for sample_url in sample_urls:
        r = requests.get(sample_url)
        print(r.text)
        time.sleep(3)

def get_mongo_doc(db_name, collection_name):
    db = client[db_name]
    collection = db[collection_name]
    # cursor = collection.find()
    # for document in cursor:
    #   pprint(document)
    pprint(collection.find_one())

if __name__ == "__main__":
    main()
