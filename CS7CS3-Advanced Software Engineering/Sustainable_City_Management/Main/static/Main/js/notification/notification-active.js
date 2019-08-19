(function ($) {
 "use strict";
 
var luas_data = []

function getBody(content) 
{
   var test = content.toLowerCase();    // to eliminate case sensitivity
   var x = test.indexOf("<body");
   if(x == -1) return "";

   x = test.indexOf(">", x);
   if(x == -1) return "";

   var y = test.lastIndexOf("</body>");
   if(y == -1) y = test.lastIndexOf("</html>");
   if(y == -1) y = content.length;    // If no HTML then just grab everything till end

   return content.slice(x + 1, y);   
} 

/**
	Loads a HTML page
	Put the content of the body tag into the current page.
	Arguments:
		url of the other HTML page to load
		id of the tag that has to hold the content
*/
function createXHR() 
{
    var request = false;
        try {
            request = new ActiveXObject('Msxml2.XMLHTTP');
        }
        catch (err2) {
            try {
                request = new ActiveXObject('Microsoft.XMLHTTP');
            }
            catch (err3) {
		try {
			request = new XMLHttpRequest();
		}
		catch (err1) 
		{
			request = false;
		}
            }
        }
    return request;
}

function loadHTML(url, fun, storage, param)
{
	var xhr = createXHR();
	xhr.onreadystatechange=function()
	{ 
		if(xhr.readyState == 4)
		{
			{
				document.getElementById("displayed").innerHTML = getBody(xhr.responseText);
          var myNodelist = document.getElementById("displayed").getElementsByTagName("li");
          var i;
          for (i = 0; i < myNodelist.length; i++) {
                 var obj = {};
                 obj.title = myNodelist[i].getElementsByTagName('h3')[0].innerHTML;
                 obj.content = myNodelist[i].getElementsByClassName('content')[0].innerHTML;
                 luas_data.push(obj);
            }
				//fun(storage, param);
			}
		} 
	}; 

	xhr.open("GET", url , true);
	xhr.send(null); 

} 

	/**
		Callback
		Assign directly a tag
	*/		


	function processHTML(temp, target)
	{
		target.innerHTML = temp.innerHTML;
	}

	function loadWholePage(url)
	{
		var y = document.getElementById("storage");
		var x = document.getElementById("displayed");
		loadHTML(url, processHTML, x, y);
	}	


	/**
		Create responseHTML
		for acces by DOM's methods
	*/	
	
	function processByDOM(responseHTML, target)
	{
		target.innerHTML = "Extracted by id:<br />";

		// does not work with Chrome/Safari
		//var message = responseHTML.getElementsByTagName("div").namedItem("two").innerHTML;
		var message = responseHTML.getElementsByTagName("div").item(1).innerHTML;
		
		target.innerHTML += message;

		target.innerHTML += "<br />Extracted by name:<br />";
		
		message = responseHTML.getElementsByTagName("form").item(0);
		target.innerHTML += message.dyn.value;
	}
	
	function accessByDOM(url)
	{
		//var responseHTML = document.createElement("body");	// Bad for opera
		var responseHTML = document.getElementById("storage");
		var y = document.getElementById("displayed");
		loadHTML(url, processByDOM, responseHTML, y);
	}	



/////////////////////////////
//get data from luas api
loadHTML('http://luasforecasts.rpa.ie/mobilecontent/news.ashx','displayed');

//////////////////////////////////////////////////////////////////////////////////////////////////////
	/*
	 * Notifications
	 */
	function notify(from, align, icon, type, animIn, animOut,titlem,messagem){
		$.growl({
			icon: icon,
			title: titlem,
			message: messagem,
			url: ''
		},{
				element: 'body',
				type: type,
				allow_dismiss: true,
				placement: {
						from: from,
						align: align
				},
				offset: {
					x: 20,
					y: 85
				},
				spacing: 10,
				z_index: 1031,
				delay: 2500,
				timer: 5000,
				url_target: '_blank',
				mouse_over: false,
				animate: {
						enter: animIn,
						exit: animOut
				},
				icon_type: 'class',
				template: '<div data-growl="container" class="alert" role="alert">' +
								'<button type="button" class="close" data-growl="dismiss">' +
									'<span aria-hidden="true">&times;</span>' +
									'<span class="sr-only">Close</span>' +
								'</button>' +
								'<span data-growl="icon"></span>' +
								'<span data-growl="title"></span>' +
								'<span data-growl="message"></span>' +
								'<a href="#" data-growl="url"></a>' +
							'</div>'
		});
	};
	
  
  
var curNewsIndex = -1;
	$('.notification-demo .btn').on('click', function(e){
    console.log("test")
    		e.preventDefault();
    ++curNewsIndex;
    if (curNewsIndex >= luas_data.length) {
        curNewsIndex = 0;
    }
    var nFrom = $(this).attr('data-from');
		var nAlign = $(this).attr('data-align');
		var nIcons = $(this).attr('data-icon');
		var nType = "success"
		var nAnimIn = $(this).attr('data-animation-in');
		var nAnimOut = $(this).attr('data-animation-out');
    var titlem = luas_data[curNewsIndex].title;
    var messagem = luas_data[curNewsIndex].content;
    notify(nFrom, nAlign, nIcons, nType, nAnimIn, nAnimOut,titlem,messagem);
	});

//var intervalID = setInterval(advanceNewsItem, 10*1000);//every 10 seconds
 
})(jQuery); 