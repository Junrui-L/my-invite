<!DOCTYPE html>
<html lang="en">
<head>
    <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
    <title>${company}</title>
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0">
    <meta content="telephone=no" name="format-detection"/>
    <meta content="email=no" name="format-detection"/>

    <link rel="stylesheet" href="${base}/resources/wx/css/base.css">
    <link rel="stylesheet" href="${base}/resources/wx/css/layer.css">
    <link rel="stylesheet" href="${base}/resources/wx/css/tmqj.css">
    <script src="${base}/resources/wx/js/layer.js"></script>
    <script src="${base}/resources/wx/js/jquery1.91.min.js"></script>
    <script src="${base}/resources/wx/js/fastclick.js"></script>
</head>
<body>
<section>
    <div class="form">
        <input type="tel" maxlength='11' id="mobile" name="phone" oninput="this.value=this.value.replace(/\D/g,'')"
               placeholder="请输入手机号码"/>
        <div class="yzm">
            <input type="text" maxlength='6' id="code" name="code"
                   placeholder="验证码："
                   oninput="this.value=this.value.replace(/\D/g,'')"/>
            <button class="get-code" id="getCode">获取验证码</button>
        </div>
        <input type="password" maxlength='20' id="pwd" name="pwd"
               placeholder="请输入密码,最少6位"/>
        <p class="clerfix">
            <label class="clerfix"><input type="checkbox"
                                          checked="checked"><span>我已经阅读并同意</span></label><a
                href="http://wxssj.ygs001.com/bjsm/userAgreement_20151228.html">移公社用户协议</a>
        </p>
        <input type="button" value="注册" class="register"/> <input
            type="hidden" id="recommendedId" value="${mbId}"/>
    </div>
</section>
</body>
<script>
    $(function () {
        var timer;
        var reg1 = /^1[34578]\d{9}$/;
        FastClick.attach(document.body);
        /*点击发送短信验证码按钮时*/
        $('#getCode').on("click", function sendMessage() {

            if (reg1.test($("#mobile").val())) {
                var _this = $(this);
                console.log(_this.text());
                var countdown = 60;
                clearInterval(timer);
                $('#getCode').off("click");
                //启动计时器，1秒执行一次
                timer = setInterval(function () {

                    if (countdown == 0) {
                        clearInterval(timer);//停止计时器
                        _this.removeAttr("disabled");//启用按钮
                        _this.text("重新发送验证码");
                        _this.css({background: "#fff", color: "#03a3dd"});
                        $('#getCode').off("click").on("click", sendMessage);
                    } else {
                        //设置button效果，开始计时
                        _this.css({background: "#ccc", color: "#fff"});
                        _this.attr("disabled", true);
                        countdown--;
                        _this.text(countdown + "秒后重新获取");
                    }
                }, 1000);

                $.ajax({
                    type: 'POST',
                    url: '${base}/wx/login!getmsg.action',
                    dataType: 'json',
                    data: {'smsType': 'register', 'phone': $("#mobile").val()},
                    success: function (data) {
                        if (data.code == '0') {
                            layer.open({
                                title: [
                                    '提示',
                                    'background-color: #ff6d00; color:#fff; font-size:.16rem'
                                ],
                                content: '短信发送成功,请注意查收',
                                btn: '我知道了',
                                time: 5
                            });
                        } else {
                            if (data.message == '账号已存在，请勿重复注册，您可在移公社所有终端上使用。') {
                                clearInterval(timer);//停止计时器
                                _this.removeAttr("disabled");//启用按钮
                                _this.text("获取验证码");
                                _this.css({background: "#fff", color: "#03a3dd"});
                                $('#getCode').on("click", sendMessage);
                                layer.open({
                                    title: [
                                        '提示',
                                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                                    ],
                                    content: data.message,
                                    btn: '立即下载',
                                    yes: function (index) {
                                        window.location.href = "http://wechat.ygs001.com/weixin/wx/near!loadapp.action";//下载APP的请求
                                    }
                                });
                            } else if (data.message == '验证码发送已达上限，请稍后再试.') {
                                clearInterval(timer);//停止计时器
                                _this.removeAttr("disabled");//启用按钮
                                _this.text("获取验证码");
                                _this.css({background: "#fff", color: "#03a3dd"});
                                $('#getCode').on("click", sendMessage);
                                layer.open({
                                    title: [
                                        '提示',
                                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                                    ],
                                    content: data.message,
                                    btn: '我知道了'

                                });

                            } else {
                                //其他出错的情况
                                layer.open({
                                    title: [
                                        '提示',
                                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                                    ],
                                    content: data.message,
                                    btn: '我知道了',
                                    time: 5
                                });
                            }

                        }
                    }
                });
            } else if ($('#mobile').val() == '') {
                layer.open({
                    title: [
                        '提示',
                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                    ],
                    content: '请输入您的手机号码',
                    btn: '我知道了',
                    time: 5
                });
                return false;
            } else if (!reg1.test($("#mobile").val())) {
                layer.open({
                    title: [
                        '提示',
                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                    ],
                    content: '手机号码不正确,请重新填写',
                    btn: '我知道了',
                    time: 5
                });
                return false;
            }

            return false;
        });

        /*点击注册按钮的时候*/
        $("input[type='button']").click(function () {
            if ($('#mobile').val() == "") {
                layer.open({
                    title: [
                        '提示',
                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                    ],
                    content: '请输入手机号码',
                    btn: '我知道了',
                    time: 5
                });
                return false;
            } else if (!reg1.test($("#mobile").val())) {
                layer.open({
                    title: [
                        '提示',
                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                    ],
                    content: '手机号码可能不正确,请重新填写',
                    btn: '我知道了',
                    time: 5
                });
                return false;
            } else if ($("#code").val() == "") {
                layer.open({
                    title: [
                        '提示',
                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                    ],
                    content: '请输入验证码',
                    btn: '我知道了',
                    time: 5
                });
                return false;
            } else if ($("#pwd").val().length < 6) {
                layer.open({
                    title: [
                        '提示',
                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                    ],
                    content: '密码不能小于6位',
                    btn: '我知道了',
                    time: 5
                });
                return false;
            } else if ($("#pwd").val().length > 20) {
                layer.open({
                    title: [
                        '提示',
                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                    ],
                    content: '密码不能大于20位',
                    btn: '我知道了',
                    time: 5
                });
                return false;
            } else if (!$("p").find("input").is(':checked')) {
                layer.open({
                    title: [
                        '提示',
                        'background-color: #ff6d00; color:#fff; font-size:.16rem'
                    ],
                    content: '您尚未接受“移公社用户协议”，请勾选后再注册!',
                    btn: '我知道了',
                    time: 5
                });
                return false;
            }

            $.ajax({
                type: 'POST',
                url: '${base}/wx/login!marketRegister.action',
                dataType: 'json',
                data: {
                    'memberVo.mbMember.phone': $("#mobile").val(),
                    'memberVo.mbMember.password': $("#pwd").val(),
                    'memberVo.verCode': $("#code").val(),
                    'memberVo.mbMember.createdBy': $("#recommendedId").val()
                },
                success: function (data) {
                    if (data.code == 0) {
                        layer.open({
                            title: [
                                '温馨提示',
                                'background-color: #ff6d00; color:#fff; font-size:.16rem'
                            ],
                            content: '恭喜您，注册成功，您可在移公社所有终端上获得优惠和收益。',
                            shadeClose: false,
                            btn: '立即下载',
                            yes: function () {
                                window.location.href = "http://wechat.ygs001.com/weixin/wx/near!loadapp.action";//下载APP的请求
                            }
                        });
                    } else {
                        if (data.message == '验证码不正确') {
                            layer.open({
                                title: [
                                    '提示',
                                    'background-color: #ff6d00; color:#fff; font-size:.16rem'
                                ],
                                content: data.message,
                                btn: '我知道了',
                                time: 5
                            });
                        } else {
                            layer.open({
                                title: [
                                    '温馨提示',
                                    'background-color: #ff6d00; color:#fff; font-size:.16rem'
                                ],
                                content: data.message,
                                btn: '立即下载',
                                yes: function () {
                                    window.location.href = "http://wechat.ygs001.com/weixin/wx/near!loadapp.action";//下载APP的请求
                                }
                            });
                        }
                    }
                }
            });
        });
    });
</script>
</html>