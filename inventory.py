import json

with open('terraform.tfstate') as json_file:
    data = json.load(json_file)
    for d in data['resources']:
        for dt in d['instances']:
            print("DT ", dt)
            if(dt == 'ip_address'):
                print("inside")

