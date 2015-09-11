<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta content="yes" name="apple-mobile-web-app-capable"/>
<meta content="yes" name="apple-touch-fullscreen"/>
<meta content="telephone=no,email=no" name="format-detection"/>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no"/>
<title>JavaScriptCore</title>
<script src="./js/lib/zepto-1.1.3.min.js"></script>
</head>
<body>
水电费水电费1112
<a href="javascript:void(0);" id="calledBtn">点击调用OC</a><br/>
<br/>
<br/>
<br/>
<label>JSExport协议展示结果如下：</label><br/>
<label id="personInfo"></label>
<script type="text/javascript">
// 1.在 app 里被调用 block
// var alertFn = function() {
//     alert('oc called js success, hahahhaha~~~~');
// }

// 2. 在 app 里面是可以正常调用的
// alert(threeNumByBlock(5));


// 3. JSExport
var loadPeopleFromJSON = function() {
    var data = [
    { "first": "Grace",     "last": "Hopper",   "year": 1906 },
    { "first": "Ada",       "last": "Lovelace", "year": 1815 },
    { "first": "Margaret",  "last": "Hamilton", "year": 1936 }
    ];
    var str = '';
    for (i = 0; i < data.length; i++) {
        // app 中 Person 类方法 createWithFirstNameLastName
        var person = Person.createWithFirstNameLastName(data[i].first, data[i].last);
        person.birthYear = data[i].year;
        str += ('name:' + data[i].first + '  ' + data[i].last + ',  birthYear:' + data[i].year + '\n');
    }
    alert(str);
    $('#personInfo').html(str);
}
$('#calledBtn').on('click', function() {
                   loadPeopleFromJSON();
                   });

</script>

</body>
</html>