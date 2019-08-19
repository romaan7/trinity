from django.shortcuts import render
from django.http import HttpResponseRedirect
from django.contrib.auth import authenticate, login, logout

# Create your views here.
def login_process(request):
    try:
        user = authenticate(username=request.POST['username'], password=request.POST['password'])
    except KeyError:
        return render(request, 'login.html',{
            'login_message' : 'init',})
    if user is not None:
        if user.is_active:
            login(request, user)
        else:
            return render(request, 'login.html',{
                'login_message' : 'The user has been removed',})
    else:
        return render(request, 'login.html',{
            'login_message' : 'Enter the username and password correctly',})
    return HttpResponseRedirect('/')

def logout_process(request):
    logout(request)
    return HttpResponseRedirect('/')