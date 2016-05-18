$(function(){
	showInfo("开始渲染btns")
	btnsInit()

	//显示屏幕宽高
	$(".screnn").html("宽："+document.body.clientWidth+" 高："+document.body.clientHeight )

})


var showInfo = function(msg){
	$(".info").html(msg);
}

var hi = function(){
	alert("liugaohui perfect")

	$(".info").html("hi");
}

var hello = function(msg){
//    prompt("hello " + msg)
    confirm("hello " + msg)
//	alert("hello " + msg)
	if(msg.obj != undefined)
//        alert(msg.obj)
//		prompt(msg.obj)
        confirm(msg.obj)
}

var getName = function(){
	return "liuyanwei"
}


var btnsInit = function(){
	var btns = ["js-btn:调用自身js的hi方法","js-btn:调用ios的hello方法"]
	$.each(btns,function(i,item){
		var btnHtml = "<a>" + item+"</a>"
		$(".btns").append(btnHtml)
	})
	$(".btns a").click(function(){
		var btnText = $(this).html()
		showInfo("你点击了："+btnText)
		if (btnText ==btns[0]) {
			hello()
		}
		if (btnText ==btns[1]) {
			var message = { 
							'method' : 'helloWorld',
							'param1' : 'liuyanwei',
					    	};
            window.webkit.messageHandlers.WinnerB.postMessage(message);
		}
		
	})	

	showInfo("html加载完成")
}