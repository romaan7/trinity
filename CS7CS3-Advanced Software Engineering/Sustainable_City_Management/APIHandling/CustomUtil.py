import json
from django.core.serializers.json import DjangoJSONEncoder

def query_to_json(query):
    return json.loads(json.dumps(list(query), cls=DjangoJSONEncoder))