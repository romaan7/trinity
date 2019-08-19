from django.template import loader
from django.http import HttpResponse

def index(request):
    latest_question_list = []
    template = loader.get_template('APIHandling/index.html')
    context = {
        'latest_question_list': latest_question_list,
    }
    return HttpResponse(template.render(context, request))

