<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="sp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title></title>
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" href="css/rwdStyle.css">

<style>

.readonly {
	background-color: #ffffd0;
}

</style>

<script type="text/javascript" src="js/cs.js"></script>
<script type="text/javascript">

//返回前作業
function back(){
	var stack = cs.poll();
	//if (stack) {
		cs.setBack();
		$("body").append("<form method='post' action='CmMain'></form>");
		$("body form:last").submit();
	//}
//	cfmMsg("<sp:message code='SCSRM015'/>", function(){
//
//		$("body").append("<form method='post'></form>");
//		var form = $("body form:last");
//		var jform = $(form);
//		jform.attr("action", "CmMain");
//		var progCallStack = $('#progCallStack').val();
//		if( progCallStack ){
//			var json = JSON.parse(progCallStack);
//			if( json.length > 0 ){
//				json[ json.length - 1 ].back = true;
//				progCallStack = JSON.stringify( json );
//			}
//		}
//		$('<input></input>').val( progCallStack ).attr("type", "hidden").attr("name", 'progCallStack').appendTo( jform );
//		$('<input></input>').val( 'ScSetScoreRwd' ).attr("type", "hidden").attr("name", 'progIdFrom').appendTo( jform );
//
//		jform.submit();
//	});

}

// 設定訊息
function setMsg(msg, cb){
	 if (typeof(msg) == "string")
		 msg = {Content: msg};
	 if(typeof(msg) == "object")
		 msg.popupType ='M';

	 popupMsg(msg, cb);
}


/*
 * 詢問盒
 */
function cfmMsg(msg, cb){
	 if (typeof(msg) == "string")
		 msg = {Content: msg};
	 if(typeof(msg) == "object")
		 msg.popupType ='C';

	 popupMsg(msg, cb);
}

/*
 * popup message box
 * cfg :
 *	 popupType : 訊息類別，M->訊息通知、C->確認訊息
 *	 Title : 訊息標題
 *	 Content : 訊息內容
 *	 Ok : 確定鈕標標題
 *	 Cancel : 取消鈕標題
 *	 okCallback : 確定回呼程式
 *	 cancelCallback : 取消回呼程式
 * cb : 確定回呼函數
 */
function popupMsg(cfg, cb){
	var popupType = "W";

	if (typeof(cfg) == "string"){
		$("#popupMsgContent").text(cfg);
	}else if(typeof(cfg) == "object"){
		var elems = ["Title", "Content", "Ok", "Cancel"];
		elems.forEach(function(element) {
			if( cfg[element] && $('#'+'popupMsg'+ element).length )
				$("#"+'popupMsg'+ element).text(cfg[element]);
		});

		if( cfg.popupType )
			popupType = cfg.popupType

		if (typeof(cb) == 'function')
			cfg.okCallback = cb;

		$("#popupMsgOk").unbind( "click" );
		if( cfg.okCallback && typeof( cfg.okCallback ) == 'function')
			$("#popupMsgOk").click( function(){setTimeout(cfg.okCallback, 500); $("#popupMsgOk").unbind( "click" );} );

		$("#popupMsgCancel").unbind( "click" );
		if( cfg.cancelCallback && typeof( cfg.cancelCallback ) == 'function')
			$("#popupMsgCancel").click( function(){setTimeout(cfg.cancelCallback, 500); $("#popupMsgCancel").unbind( "click" );} );
	}

	if( popupType == "C" ){
		$("#popupMsgBar").removeClass('text-right');
		$("#popupMsgCancel").removeClass('d-none');
		$("#popupMsgIcon").removeClass('fa-info-circle');
		$("#popupMsgIcon").addClass('fa-question-circle');
	}else{
		$("#popupMsgBar").addClass('text-right');
		$("#popupMsgCancel").addClass('d-none');
		$("#popupMsgIcon").addClass('fa-info-circle');
		$("#popupMsgIcon").removeClass('fa-question-circle');
	}

	$("#popupMsgBox").modal({keyboard: true});
}

// 設定梯次清單
function setRdList( rdList, idx ){
	$("#rdId").empty();
	for(var i=0; i<rdList.length; i++){
		var value = rdList[i].rdId + "," + rdList[i].groupSeq + "," + rdList[i].roomSeq;
		var text = rdList[i].rdDesc + "(" + rdList[i].groupSeq + "." + rdList[i].roomSeq + ")";
		var dataQsId = rdList[i].qsId;
		var dataQsName = rdList[i].qsName;
		var dataTotalOptClass = rdList[i].totalOptClass;
		//$("#rdId").append("<option value='" + value + "' data-qsId='" + dataQsId + "' data-qsName='" + dataQsName + "'>" + text + "</option>");
		var elem = $('<option></option>').appendTo( $("#rdId") );
		elem.val( value ).text( text ).attr("data-qsId", dataQsId).attr("data-qsName", dataQsName).attr("data-totalOptClass", dataTotalOptClass);
		if(i==idx)
			elem.attr("selected", true);
	}
	$("#rdId").change( selRdId );
}

// 選擇梯次
function selRdId(totalOptList, itemOptHeader, itemList, itemOptMap, itemScoMap){
	var selElem = $("#rdId option:selected");
	$("#qsName").val( selElem.attr("data-qsName") );

	if( totalOptList && itemOptHeader && itemList){
		setTotalOptList(totalOptList);
		setItemOptHeader(itemOptHeader);
		setItemList(itemList, itemOptMap, itemScoMap);
		return;
	}

	var rdAry = $("#rdId").val().split(/,/);
	var req = {};
	req.rdId          = rdAry[0];
	req.groupSeq      = rdAry[1];
	req.roomSeq       = rdAry[2];
	req.qsId          = selElem.attr("data-qsId");
	req.totalOptClass = selElem.attr("data-totalOptClass");

	$.post("ScSetScoreRwd_selRdId", req, function (res) {
		if( res.success ){
			setTotalOptList(res.totalOptList);
			setItemOptHeader(res.itemOptHeader);
			setItemList(res.itemList, res.itemOptMap, res.itemScoMap);
			//$("#examinee").attr("data-quiet", "Y");
			setExList( res.exList, res.preExamineeIdx );
			setExamineeScore(res);
		}else{
			setMsg(res.status);
		}

	}, "json");

}

// 設定考生清單
function setExList(exList, idx){
	$("#examinee").empty();
	var examinee = $("#examinee");
	for(var i=0; i<exList.length; i++){
		var value = exList[i].sectSeq;
		var dataExaminee = exList[i].examinee;
		var text = "[" + exList[i].execTime + "]" + exList[i].examinee + " " + exList[i].examineeName;
		var elem = $('<option></option>');
		elem.val(value).attr('data-examinee', dataExaminee).text(text);
		if(i==idx)
			elem.attr("selected", true);
		elem.appendTo(examinee);
		//$("#examinee").append("<option value='" + value + "'" + (i==idx? " selected " : "") + ">" + text + "</option>");
	}

	if( ! $("#examinee option:selected").attr("data-examinee") ){
		setExamineeScore(null);
		setMsg( "<sp:message code='SCSRE012'/>" );
		return;
	}

	$("#examinee").change( selExaminee );
}

//選擇考生
function selExaminee( ){
    if( $("#examinee").attr("data-quiet") == 'Y' ){
        $("#examinee").attr("data-quiet", "");
        return;
    }
	var rdId = $("#rdId").val();
	var rdAry = rdId.split(/,/);
	var req = {};
	req.rdId = rdAry[0];
	req.groupSeq = rdAry[1];
	req.roomSeq = rdAry[2];
	req.sectSeq = $("#examinee").val();
	if( ! $("#examinee option:selected").attr("data-examinee") ){
		setExamineeScore(null);
		setMsg( "<sp:message code='SCSRE012'/>" );
		return;
	}

	$.post("ScSetScoreRwd_selExaminee", req, function (res) {
		if( res.success ){
			setExamineeScore(res);
		}else{
			setMsg(res.status);
		}

	}, "json");
}

//設定整體分數選項
function setTotalOptList(optList){
	$("#totalOptId").empty();
	//$("#totalOptId").append("<option value=''></option>");
	$('<option></option>').appendTo( $("#totalOptId") );
	for(var i=0; i<optList.length; i++){
		var value = optList[i].optId;
		var text = optList[i].optDesc;
		$('<option></option>').val(value).text(text).appendTo( $("#totalOptId") );
	}
}

//設定項目分數標題
function setItemOptHeader(optList){
	$("#optHeader").empty();
	for(var i=0; i<optList.length; i++)
		$('<div></div>').addClass("col p-0 inner").text(optList[i].optDesc).appendTo( $("#optHeader") );
}
// 設定表格 active
function setActive(src){
	$('#itemGrid .sco-grid-data').removeClass('active');
	$(src).addClass('active');
}

//設定項目清單
function setItemList(itemList, itemOptMap, itemScoMap){
	$("#itemGrid").empty();
	for(var i=0; i<itemList.length; i++){
		var optList = itemOptMap[itemList[i].optClass];

		var eRow = $('<div></div>').addClass("row sco-grid-data").bind("click", function(){setActive(this);} ).appendTo( $("#itemGrid") );
		$('<div></div>').addClass("col-md-1 align-self-center  inner").text( itemList[i].itemNo ).appendTo( eRow );
		$('<div></div>').addClass("col-md-5 align-self-center text-left inner").text( String(itemList[i].itemDesc).replace(/\n+/g, "<br>") ).appendTo( eRow );
		var eDesc = $('<div></div>').addClass("col-md-1 py-1 inner").appendTo( eRow );
		$('<input></input>').addClass("btn btn-sco").val( '<sp:message code='SCSRT015'/>' ).attr("type", "button").attr("data-tip", escape(itemList[i].tip) ).bind("click", function(){showTip(this);} ).appendTo( eDesc );

		var eOpt = $('<div></div>').addClass("col-md-3 py-1 row m-0 inner").appendTo( eRow );
		for(var j=0; j < optList.length; j++){
			var eDiv = $('<div></div>').addClass("col radio-sco").appendTo( eOpt );
			var eRdo = $('<input></input>').val( optList[j].optId ).attr("type", "radio").attr("name", 'optIdRadio' + i ).attr("data-score", optList[j].score ).appendTo( eDiv );
			eRdo.prop("checked", false).bind("change", function(){calcuScore();});
			if( optList[j].noSel == 'Y' )
				eRdo.css("display", "none");
		}
		var eInp = $('<div></div>').addClass("col-md-2 py-1 row m-0 inner").appendTo( eRow );
		var eD1 = $('<div></div>').addClass("col-6 px-0").appendTo( eInp );
		$('<input></input>').val( '<sp:message code='SCSRT008'/>' ).addClass("btn btn-sco").attr("type", "button").attr("name", 'examComm' + i ).bind("click", function(){openPopupComm(this);} ).appendTo( eD1 );
		var eD2 = $('<div></div>').addClass("col-6 px-0").appendTo( eInp );
		$('<input></input>').val( '<sp:message code='SCSRT009'/>' ).addClass("btn btn-sco").attr("type", "button").attr("name", 'examPic' + i ).bind("click", function(){editPic(this);} ).appendTo( eD2 );
	}
}

// 顯示評分說明
function showTip(src){
	var tip = unescape( $(src).attr('data-tip') );
	$("#popupTipContent").html( tip.replace(/\n+/g, "<br>") );
	//$("#popupTipContent").html( tip );
	$("#popupTip").modal({keyboard: true});
}

//2019/05/03 by sam 增查詢當前考生功能鍵
function qryCurExaminee(req){
    if( !req || typeof(req) != 'object' )
        req = {};
	$.post("ScSetScoreRwd_qryCurExaminee", req, function (res) {
		if( res.success ){
			setRdList( res.rdList, res.rdIdIdx );
			selRdId( res.totalOptList, res.itemOptHeader, res.itemList, res.itemOptMap, res.itemScoMap );
			//$("#examinee").attr("data-quiet", "Y");
			setExList( res.exList, res.preExamineeIdx );
			setExamineeScore(res);
		}else{
			setMsg(res.status);
		}

	}, "json");
}

//設定(顯示)考生分數
function setExamineeScore(res){
	if( !res ){
		$("#totalScore").val( "" );
		$("#totalOptId").val( "" );
		$("#totalExamComm").attr( "data-examComm", "" );
		$("#totalExamPic").attr( "data-examPic", "" );

		for(var i=0; i<$("#itemGrid").children().length; i++)
			$("input[name*=optIdRadio" + i + "]").prop("checked", false);

		return;
	}

	$("#totalScore").val( res.score );
	$("#totalOptId").val( res.optId );
	$("#totalExamComm").attr( "data-examComm", escape(res.examComm) );
	$("#totalExamPic").attr( "data-examPic", escape(res.examPic) );
	if( res.absent == "Y" )
		setMsg(res.status);

	for(var i=0; i<$("#itemGrid").children().length; i++){
		if( res.itemScoMap && res.itemScoMap[i+1] ){
			$("input[name*=optIdRadio" + i + "][value='" + res.itemScoMap[i+1].optId + "']").prop("checked", true);
			$("input[name*='examComm" + i + "']").attr("data-examComm", escape(res.itemScoMap[i+1].examComm));
			$("input[name*='examPic" + i + "']").attr("data-examPic", escape(res.itemScoMap[i+1].examPic));
		}else{
			$("input[name*=optIdRadio" + i + "]").prop("checked", false);
			$("input[name*='examComm" + i + "']").attr("data-examComm", "");
			$("input[name*='examPic" + i + "']").attr("data-examPic", "");
		}
	}
}

// 計算得分
function calcuScore(){
	var score = 0;
	for(var i=0; i<$("#itemGrid").children().length; i++){
		var n = $("input[name*='optIdRadio" + i + "']:checked").attr("data-score");
		if( !isNaN(n) )
			score += parseInt( n );
	}

	$("#totalScore").val( score );
}

// 開啟考官註記
function openPopupComm(src){
	var examComm = unescape( $(src).attr('data-examComm') );
	var elemName = $(src).attr('name');
	$("#popupCommContent").attr("data-target", elemName );
	$("#popupCommContent").val( examComm );
	$("#popupCommExaminee").val( $("#examinee option:selected").text() );

	if( elemName == 'totalExamComm' )
		$("#popupCommItemDesc").parent().css("display", "none");
	else{
		$("#popupCommItemDesc").parent().css("display", "block");
		$("#popupCommItemDesc").val( $(src).parent().parent().parent().children().eq(1).text() );
	}

	$("#popupComm").modal({keyboard: true});
	setTimeout(function (){ $("#popupCommContent").focus(); }, 500);
}

// 鍵盤輸入確定
function popupCommOk(){
    var target = $("#popupCommContent").attr("data-target");
    var value = $("#popupCommContent").val().trim();
    $("input[name*='" + target + "']").attr('data-examComm', escape( value ) );
	var examComm =  $("input[name*='" + target + "']").attr('data-examComm');
}

// 儲存評分
function saveScore() {
	var rdAry = $("#rdId").val().split(/,/);
	var req = {};
	req.rdId          = rdAry[0];
	req.groupSeq      = rdAry[1];
	req.roomSeq       = rdAry[2];
	req.sectSeq = $("#examinee").val();
	req.totalOptId = $("#totalOptId").val();
	req.totalExamComm = unescape( $("#totalExamComm").attr("data-examComm") );
	req.totalExamPic = unescape( $("#totalExamPic").attr("data-examPic") );
	req.itemCount = $("#itemGrid").children().length;

	// 空堂，沒有考生
	if( ! $("#examinee option:selected").attr("data-examinee") ){
		setMsg( "<sp:message code='SCSRE012'/>" );
		return;
	}

	// 沒有設定整體得分
	if( !req.totalOptId ){
		setMsg( "<sp:message code='SCSRE007'/>" );
		return;
	}

	// 抓取項次得分
	for(var i=0; i<$("#itemGrid").children().length; i++){
		var optId =$("input:radio[name=optIdRadio" + i + "]:checked").val();
		if( !optId ){ // 尚未評分
			setMsg( "<sp:message code='SCSRE008' arguments='" + (i+1) + "'/>" );
			return;
		}
		req[ 'optId_' + i ] = optId;
		req[ 'examComm_' + i ] = unescape( $("input[name*='examComm" + i + "']").attr("data-examComm" ));
		req[ 'examPic_' + i ] = unescape( $("input[name*='examPic" + i + "']").attr("data-examPic" ));
	}

	$.post("ScSetScoreRwd_saveScore", req, function (res) {
		setMsg(res.status);
	}, "json");
}

//刪除評分
function delScore() {
	var rdAry = $("#rdId").val().split(/,/);
	var req = {};
	req.rdId          = rdAry[0];
	req.groupSeq      = rdAry[1];
	req.roomSeq       = rdAry[2];
	req.sectSeq = $("#examinee").val();

	// 空堂，沒有考生
	if( ! $("#examinee option:selected").attr("data-examinee") ){
		setMsg( "<sp:message code='SCSRE012'/>" );
		return;
	}

	cfmMsg("<sp:message code='SCSRM010'/>", function(){
		$.post("ScSetScoreRwd_delScore", req, function (res) {
			setMsg(res.status);
			selExaminee( );
		}, "json");
	});
}

//註記缺考
function setAbsent() {
	var rdAry = $("#rdId").val().split(/,/);
	var req = {};
	req.rdId          = rdAry[0];
	req.groupSeq      = rdAry[1];
	req.roomSeq       = rdAry[2];
	req.sectSeq = $("#examinee").val();

	// 空堂，沒有考生
	if( ! $("#examinee option:selected").attr("data-examinee") ){
		setMsg( "<sp:message code='SCSRE012'/>" );
		return;
	}

	cfmMsg("<sp:message code='SCSRM013'/>", function(){
		$.post("ScSetScoreRwd_setAbsent", req, function (res) {
			setMsg(res.status);
		}, "json");
	});
}

//取消註記缺考
function unsetAbsent() {
	var rdAry = $("#rdId").val().split(/,/);
	var req = {};
	req.rdId          = rdAry[0];
	req.groupSeq      = rdAry[1];
	req.roomSeq       = rdAry[2];
	req.sectSeq = $("#examinee").val();

	// 空堂，沒有考生
	if( ! $("#examinee option:selected").attr("data-examinee") ){
		setMsg( "<sp:message code='SCSRE012'/>" );
		return;
	}

	$.post("ScSetScoreRwd_unsetAbsent", req, function (res) {
		setMsg(res.status);
	}, "json");
}

function editPic(target) {
    $("#edPic").dialog("open");
    $("#baseColor").combobox('select', '#FF0000');
    // 2019/05/03 by sam 畫面登入預設選取畫筆
    //$("#baseType").combobox('select', 'mouse-pointer.png');
    $("#baseType").combobox('select', 'edit.png');
    $("#basePaintWidth").combobox('select', 3);

	loadCanvas();

	var arg = {};
    if (target != null && target != '') {
    	$("#out").unbind('click');
    	$("#out").bind('click', function() {
    		out('I');
    	});
        //項目輸入
    	arg = $("#itemList").datagrid('getRows')[getRowIndex(target)];
    	$("#dItemNo").val(arg.itemNo);
    	var itemDesc = "<sp:message code='SCSST002'/>";
    	fontsize = 20;
    	for (var item = 0; item < 2; item++)
        {
            //設定起始座標
            var drawPointX = baseX;
            var drawPointY;
            var diffH;
            if (item == 0)
                drawPointY = baseY;
            else
                drawPointY += baseH + diffH;

            diffH = 0;
            var iniText;
            if (item === 0)
                iniText = itemDesc;
            else
                iniText = arg.itemDesc;

            //項目文字
            var param = {
                fillStyle: '#000',
                strokeWidth: 1,
                x: drawPointX + wordPadding.top, y: drawPointY + wordPadding.left,
                fontSize: fontsize,
                fontFamily: 'Trebuchet MS, sans-serif',
                maxWidth: iDescW - wordPadding.left - wordPadding.right,
                fromCenter: false,
                align: 'left',
                text: iniText
            };

            var iDescParams = $canvasP1.measureText(param);
            $canvasP1.drawText(param);

            if (iDescParams.height + wordPadding.top + wordPadding.bottom > baseH)
                diffH = iDescParams.height + wordPadding.top + wordPadding.bottom - baseH; //因為有可能字太多所以要拉大框

            //項目的框
            $canvasP1.drawRect({
                strokeStyle: 'black',
                strokeWidth: 1,
                x: drawPointX, y: drawPointY,
                fromCenter: false,
                width: iDescW,
                height: baseH + diffH
            });

            drawPointX += iDescW;
            //顯示opt類別
            for (var cnt = 0; cnt < opt[arg.optClass].length; cnt++)
            {
            	var optText;
    	        if (item === 0)
    	        	optText = opt[arg.optClass][cnt].optDesc;
    	        else {
    	            if (opt[arg.optClass][cnt].noSel != 'Y')
    	        		optText = opt[arg.optClass][cnt].optId;
    	            else
    	                optText = '';
    	        }
            	//opt類別文字
                var param = {
                    fillStyle: '#000',
                    strokeWidth: 1,
                    x: drawPointX + wordPadding.top, y: drawPointY + wordPadding.left,
                    fontSize: fontsize,
                    fontFamily: 'Trebuchet MS, sans-serif',
                    maxWidth: optW - wordPadding.left - wordPadding.right,
                    fromCenter: false,
                    align: 'center',
                    text: optText
                };
                $canvasP1.drawText(param);

                //如果有分數就畫個圈
                if (arg.optId === opt[arg.optClass][cnt].optId && item !== 0) {
                    var p = $canvasP1.measureText(param);
    	            $canvasP1.drawArc({
    	                layer: true,
    	                strokeStyle: 'red',
    	                strokeWidth: 3,
    	                x: drawPointX + (p.width/2),
    	                y: drawPointY + (p.height/2),
    	                fromCenter: false,
    	                radius: p.width
    	            });
                }

                //opt類別的框
                $canvasP1.drawRect({
                    strokeStyle: 'black',
                    strokeWidth: 1,
                    x: drawPointX, y: drawPointY,
                    fromCenter: false,
                    width: optW,
                    height: baseH + diffH
                });

                drawPointX += optW;
            }
        }
    }
    else {
    	$("#out").unbind('click');
    	$("#out").bind('click', function() {
            out('T');
        });
        //主題輸入
        var totOptClassList = $("#optId").combobox('getData');
        arg.examPic = $("#examPic").val();
        var p = {};
        var drawPointX = baseX;
        var drawPointY = baseY;
        fontsize = 15;
        var param = {
            fillStyle: '#000',
            strokeWidth: 1,
            x: drawPointX, y: drawPointY,
            fontSize: fontsize,
            fontFamily: 'Trebuchet MS, sans-serif',
            //maxWidth: optW - wordPadding.left - wordPadding.right,
            fromCenter: false,
            align: 'center',
            text: "<sp:message code='SCSST016'/>:"
        };
        p = $canvasP1.measureText(param);
        $canvasP1.drawText(param);
        drawPointX += p.width + 10;
        //PASS
        var r = $("#resList").val().replace(/\'/g, '"');
/* 2019/06/28 by sam 與中嘯醫藥學院陳醫師討論後決議評分作業不顯示「考試結果」，因考試通過分數須事後於考試統計作業設定。
        var resList = JSON.parse(r)['resList'];
        for (var o = 0; o < resList.length; o++) {
            //前面要畫方框，跟字等高
            var rectWH = 15;
            $canvasP1.drawRect({
                strokeStyle: '#000',
                strokeWidth: 1,
                x: drawPointX, y: drawPointY,
                fromCenter: false,
                width: rectWH,
                height: rectWH
            });

            //勾的邊長比，r1是方框到勾的起點邊長比率
            //theta = θ, 夾角
            var r1 = (1.3 * rectWH) / 3;
            var r2 = (2.6 * rectWH) / 3;
            var r3 = (4 * rectWH) / 3;

            var theta1 = Math.PI/12; //15°
            var theta2 = Math.PI/4; //45°
            var theta3 = Math.PI/3.3; //約55°

            var p1 = {'x':0, 'y':0};
            var p2 = {'x':0, 'y':0};
            var p3 = {'x':0, 'y':0};

            p1.x = drawPointX - (r1 * Math.sin(theta1));
            p1.y = drawPointY + (r1 * Math.cos(theta1));
            p2.x = p1.x + (r2 * Math.sin(theta2));
            p2.y = p1.y + (r2 * Math.cos(theta2));
            p3.x = p2.x + (r3 * Math.cos(theta3));
            p3.y = p2.y - (r3 * Math.sin(theta3));

         	// 2019/06/28 by sam 與中嘯醫藥學院陳醫師討論後決議評分作業不顯示「考試結果」，因考試通過分數須事後於考試統計作業設定。
            //if ($("#result").textbox('getText') === resu[resList[o].value]) {
            //    //打勾
            //	$canvasP1.drawLine({
            //        strokeStyle: 'red',
            //        strokeWidth: 3,
            //        x1: p1.x, y1: p1.y,
            //        x2: p2.x, y2: p2.y,
            //        x3: p3.x, y3: p3.y
            //    });
            //}
            drawPointX += fontsize + 3;

            optText = resList[o].text;
            var param = {
                fillStyle: '#000',
                strokeWidth: 1,
                x: drawPointX, y: drawPointY,
                fontSize: fontsize,
                fontFamily: 'Trebuchet MS, sans-serif',
                //maxWidth: optW - wordPadding.left - wordPadding.right,
                fromCenter: false,
                align: 'center',
                text: optText
            };
            p = $canvasP1.measureText(param);
            $canvasP1.drawText(param);

            drawPointX += p.width + 10;
        }

        */
        drawPointX += 10
        //整體級分
        //先算最長的框
        var param = {
            fillStyle: '#000',
            strokeWidth: 1,
            x: drawPointX, y: drawPointY,
            fontSize: fontsize,
            fontFamily: 'Trebuchet MS, sans-serif',
            //maxWidth: optW - wordPadding.left - wordPadding.right,
            fromCenter: true,
            align: 'center'
        };
        var maxWidth = 0;
        var maxHeight = 0;
        for (var o = 0; o < totOptClassList.length; o++) {
        	optText = totOptClassList[o].optDesc;
        	param.text = optText;
            p = $canvasP1.measureText(param);
            if (p.width > maxWidth)
            	maxWidth = p.width;
            maxHeight = p.height;
        }
        maxWidth += wordPadding.left + wordPadding.right; //文字內距，原本是用減的現在邊往外算
        maxHeight += wordPadding.top + wordPadding.bottom;

        //畫框跟放字
        for (var o = 0; o < totOptClassList.length; o++) {

        	//畫框
        	var rectX = drawPointX - wordPadding.left;
        	var rectY = drawPointY - wordPadding.top;
            $canvasP1.drawRect({
                strokeStyle: '#000',
                strokeWidth: 1,
                x: rectX, y: rectY,
                fromCenter: false,
                width: maxWidth,
                height: maxHeight
            });

            var wordX = rectX + (maxWidth/2);
        	optText = totOptClassList[o].optDesc;
        	param.text = optText;
        	param.x = wordX;
        	param.y = drawPointY + wordPadding.top;
            p = $canvasP1.measureText(param);
            $canvasP1.drawText(param);

            if ($("#optId").combobox('getValue') === totOptClassList[o].optId) {
                $canvasP1.drawArc({
                    layer: true,
                    strokeStyle: 'red',
                    strokeWidth: 3,
                    x: wordX + 0, y: drawPointY + (p.height/2),
                    fromCenter: true,
                    radius: (p.width+5)/2
                });
            }
            //下一個畫點應該是一個框的距離
            drawPointX += maxWidth;
        }
    }

    //下載上次存檔的圖
    if (arg.examPic) {
    	cc.clean();
    	cc.disp().examPic = arg.examPic;
        cc.post('ScSetScore_getPic', function(res){

              if (res.success) {
                  $canvasP2.drawImage({
                  	source: 'data:image/png;base64,' + cc.disp().imageBase64,
                  	x: 0, y: 0,
                  	fromCenter: false
                  });
              }

        });
    }
}

</script>
</head>
<body>

<nav class="navbar navbar-expand-sm navbar-light sticky-top mainNav mx-0 px-0 pt-0"  style="opacity:0.98;">
    <div class="col-12 row">
        <div class="col-12 row py-2 px-0 m-2" style="border-bottom-style: solid; border-width: 10px; border-color: #344b6b;">

    		<div class="col-sm-4 col-md-3 py-2" >
    			<img src="images/ron_logo.png" height="70px;" class="pl-0 d-none d-lg-block" alt="">
    		</div>
    		<div class="col-12 col-sm-4 col-md-6 d-flex flex-column justify-content-center align-items-center sys-name" style="color: #344b6b;">
    			<label><sp:message code='CMMAT002'/><span id="titleAppend" style="font-size:50%;">${titleAppend}</span></label>
    		</div>
    		<div class="col-sm-4 col-md-3" style="font-size:0.7rem;">
                <div class="d-none d-lg-block">
                    <div class="row">
                        <label class="" ><sp:message code='CMMAT003'/>
                            <input type="text" id="userId" class="ml-1 readonly" value="${userId}" style="width: 80px; height: 30px; font-size:0.8em;" readonly/>
                            <input type="text" id="userName" class="ml-1 readonly" value="${userName}" style="width: 100px; height: 30px; font-size:0.8em;" readonly/>
                        </label>
                    </div>
                    <div class="row">
                        <label><sp:message code='CMMAT004'/>
                            <input type="text" id="progId" class="ml-1 readonly" value="${progId}" style="width: 80px; height: 30px; font-size:0.8em;" readonly/>
                            <input type="text" id="privDesc" class="ml-1 readonly" value="${privDesc}" style="width: 100px; height: 30px; font-size:0.8em;" readonly/>
                        </label>
                    </div>
                    <div class="row">
                        <label><sp:message code='CMMAT005'/>
                            <input type="text" id="progTitle" class="ml-1 readonly" value="${progTitle}" style="width: 188px; height: 30px; font-size:0.8em;" readonly/>
                        </label>
                    </div>
                </div>
    		</div>

        </div>

        <div class="col-6 col-sm-4 col-lg-2 px-1 mb-1">
            <div class="form-inline">
                <label class="col-3  col-lg-4 my-1 px-0"><sp:message code='SCSRT003'/></label>
                <select id="rdId" class="col-9 col-lg-8 p-0 custom-select-sm">
                </select>

            </div>
        </div>

        <div class="col-6 col-sm-4 col-lg-2 px-1 my-1">
            <div class="form-inline">
                <label class="col-4 my-1 px-0"><sp:message code='SCSRT004'/></label>
                <input id="qsName" type="text" class="col-8 px-0 readonly" value="" readonly/>
            </div>
        </div>

        <div class="col-6 col-sm-5 col-lg-3 px-1 mb-1">
            <div class="form-inline px-0">
                <label class="col-3 col-sm-3 col-lg-2 my-1 px-0"><sp:message code='SCSRT005'/></label>
                <select id="examinee" class="col-4 col-sm-5 col-lg-7 custom-select-sm" οnchange="selExaminee(this.options[this.selectedIndex].value);">
                </select>
                <div class="col-4 col-sm-3 col-lg-3">
               		<input id="btnQryCurExaminee" class=" btn btn-sco px-2" type="button" onclick="qryCurExaminee();" value="<sp:message code='SCSRT002'/>">
               	</div>
            </div>
        </div>

        <div class="col-6 col-sm-4 col-lg-1 px-1 my-1">
            <div class="form-inline px-0">
                <label class="col-4 col-sm-7 my-1 p-1"><sp:message code='SCSRT006'/></label>
                <input id="totalScore" type="text"  class="col-8 col-sm-5 px-0 readonly" value="" readonly/>
            </div>
        </div>

        <div class="col-6 col-sm-3 col-lg-2 px-1 mb-1">
            <div class="form-inline px-0">
                <label class="col-3 col-lg-6 my-1 px-0"><sp:message code='SCSRT007'/></label>

                <select id="totalOptId" class="col-4 col-lg-6 py-0 px-0 custom-select-sm">
                </select>
<%/*
                <input id="totalExamComm" name="totalExamComm" class="col-2 col-lg-3 px-0 ml-1 btn btn-sco" type="button" onclick="openPopupComm(this);" value="<sp:message code='SCSRT008'/>">
                <input id="totalExamPic" name="totalExamPic" class="col-2 col-lg-3 px-0 ml-1 btn btn-sco" type="button" onclick="alert('手寫輸入')" value="<sp:message code='SCSRT009'/>">
*/ %>
            </div>
        </div>

        <div class="col-6 col-sm-4 col-lg-2 p-1 m-0">
       		<button type="button" class="btn btn-sco dropdown-toggle px-1" data-toggle="dropdown"><sp:message code='SCSRT019'/></button>
       		<div class="dropdown-menu px-1">
				<input id="totalExamComm" name="totalExamComm" class="dropdown-item" type="button" onclick="openPopupComm(this);" value="<sp:message code='SCSRT022'/>">
				<input name="totalExamPic" class="dropdown-item" type="button" onclick="alert('手寫輸入')" value="<sp:message code='SCSRT009'/>">
				<hr>
				<input class="dropdown-item" type="button" onclick="delScore();" value="<sp:message code='SCSRT011'/>">
				<input class="dropdown-item" type="button" onclick="setAbsent();" value="<sp:message code='SCSRT020'/>">
				<input class="dropdown-item" type="button" onclick="unsetAbsent();" value="<sp:message code='SCSRT021'/>">
			</div>
			<button type="button" onclick="saveScore();" class="btn btn-sco ml-1 px-1"><sp:message code='SCSRT010'/></button>
			<button type="button" onclick="back();" class="btn btn-sco ml-1 px-1"><sp:message code='SCSRT012'/></button>
        </div>

        <!-- 表格 title -->
        <div class="col-12 p-0 ml-2">
            <div class="row sco-grid-header ml-0" style="font-size:0.8rem;">
                <div class="col-md-1 py-1"><sp:message code='SCSRT013'/></div>
                <div class="col-md-5 py-1"><sp:message code='SCSRT014'/></div>
                <div class="col-md-1 py-1"><sp:message code='SCSRT015'/></div>
                <div id="optHeader" class="col-md-3 py-1 row m-0"></div>
                <div class="col-md-2 py-1 m-0">
                    <sp:message code='SCSRT022'/>
                </div>
            </div>
        </div>
    </div>
</nav>


<section class="mx-2 my-2">
    <div class="container-fluid">
        <div id="itemGrid" class="sco-grid mb-4">
<%/*
            <div class="row sco-grid-data">
                <div class="col-md-1 py-1 inner">1</div>
                <div class="col-md-5 py-1 text-left inner">項目一</div>
                <div class="col-md-1 py-1 inner"><input class="px-1 btn-sco" type="button" onclick="alert('說明')" value="檢視"></div>
                <div class="col-md-3 py-1 row m-0 inner">
                    <div class="col radio-sco"><input type="radio" name="optIdRadio1"></div>
                    <div class="col radio-sco"><input type="radio" name="optIdRadio1"></div>
                    <div class="col radio-sco"><input type="radio" name="optIdRadio1"></div>
                </div>
                <div class="col-md-2 py-1 row m-0 inner">
                    <div class="col-6 mx-0"><input class="mx-1 btn-sco" type="button" onclick="alert('鍵盤輸入')" value="輸入"></div>
                    <div class="col-6 mx-0"><input class="mx-1 btn-sco" type="button" onclick="alert('手寫輸入')" value="輸入"></div>
                </div>
            </div>
*/%>
        </div>
    </div>
</div>
</section>

<!-- 彈出訊息盒 -->
<div class="modal fade" id="popupMsgBox">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header" style="background-color:#2196F3; color:#fff">
				<p class="modal-title"><i id="popupMsgIcon" class="fa fa-info-circle" style="font-size:1.3rem;">&nbsp;</i><b id="popupMsgTitle"><sp:message code='SCSRT001'/></b></p>
				<button type="button" class="close" data-dismiss="modal">&times;</button>
			</div>
			<div class="modal-body text-left" id="popupMsgContent" style="font-size:1rem; line-height: 1.2rem"></div>
			<div id="popupMsgBar" class="row m-3 text-right">
				<div class="col-6">
					<button type="button" class="btn btn-warning d-none" id="popupMsgCancel" data-dismiss="modal"><sp:message code='CMALT006'/></button>
				</div>
				<div class="col-6">
					<button type="button" class="btn btn-warning" id="popupMsgOk" data-dismiss="modal"><sp:message code='SCSRT018'/></button>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 彈出評分說明 -->
<div class="modal fade" id="popupTip">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header" style="background-color:#2196F3; color:#fff">
				<p class="modal-title"><i class="fa fa-lightbulb-o" style="font-size:1.3rem;">&nbsp;</i><b ><sp:message code='SCSRT015'/></b></p>
				<button type="button" class="close" data-dismiss="modal">&times;</button>
			</div>
			<div class="modal-body text-left" id="popupTipContent" style="line-height: 1.2em"></div>
			<div class="card-footer">
				<button type="button" class="btn-sco" data-dismiss="modal"><sp:message code='SCSRT018'/></button>
			</div>
		</div>
	</div>
</div>

<!-- 考官註記 -->
<div class="modal fade" id="popupComm">
	<div class="modal-dialog modal-lg modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header" style="background-color:#2196F3; color:#fff">
				<p class="modal-title"><i id="popupMsgIcon" class="fa fa-pencil-square-o" style="font-size:1.3rem;">&nbsp;</i><b><sp:message code='SCSRT022'/></b></p>
				<button type="button" class="close" data-dismiss="modal">&times;</button>
			</div>
			<div class="modal-body row text-left">
				<div class="col-4 form-group">
					<label><sp:message code='SCSRT005'/></label>
    				<input type="text" class="form-control readonly" id="popupCommExaminee" readonly>
    			</div>
				<div class="col-8 form-group">
					<label><sp:message code='SCSRT014'/></label>
    				<input type="text" class="form-control readonly" id="popupCommItemDesc" readonly>
    			</div>
    			<div class="col-12 form-group">
					<textarea class=" form-control" rows="5" id="popupCommContent" style="font-size:1rem;"></textarea>
				</div>
			</div>
			<div class="card-footer row">
				<div class="col">
					<button type="button" class="btn btn-warning" data-dismiss="modal"><sp:message code='CMALT006'/></button>
				</div>
				<div class="col">
					<button type="button" class="btn btn-warning" data-dismiss="modal" onclick="popupCommOk()"><sp:message code='SCSRT018'/></button>
				</div>
			</div>
		</div>
	</div>
</div>

<a href="#" class="go-top"><em class="fa fa-angle-up"></em></a>
<input type='hidden' id="progCallStack" value='${progCallStack}' />
<script src="js/jquery-3.2.1.slim.min.js"></script>
<script src="js/popper.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/custom.js"></script>
<script src="js/jcanvas.js"></script>
<script type="text/javascript">
	var initVar = '${initVar}';
	var errorMsg = '${errorMsgt}';
	if( initVar ){
		var initData = JSON.parse( decodeURIComponent( initVar) );
		if( initData.success ){
			var rec = {};
			rec.rdId = '${rdId}';
			rec.groupSeq = '${groupSeq}';
			rec.roomSeq = '${roomSeq}';
			rec.sectSeq = '${sectSeq}';
			if( rec.rdId && rec.groupSeq && rec.roomSeq && rec.sectSeq ){
				$("#rdId").addClass("readonly").attr("disabled", true);
				$("#examinee").addClass("readonly").attr("disabled", true);
				$("#btnQryCurExaminee").attr("disabled", true);
			} else
				rec = {};
			qryCurExaminee( rec );
		}else if( initData.status ){
			setMsg( initData.status );
		}
	}
</script>
</body>
</html>