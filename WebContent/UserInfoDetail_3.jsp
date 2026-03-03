<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ page import="jp.patasys.common.http.WebUtil" %>
    <%@ page import="jp.patasys.common.http.HtmlParts" %>
      <%@ page import="jp.swell.dao.UserInfoDao" %>
        <%@ page import="jp.patasys.common.http.WebBean" %>
          <jsp:useBean id="webBean" class="jp.patasys.common.http.WebBean" scope="request" />

          <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
          <html xmlns="http://www.w3.org/1999/xhtml">

          <head>
            <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
            <meta http-equiv="Content-Script-Type" content="text/javascript" />
            <meta http-equiv="Content-Style-Type" content="text/css" />
            <link type="text/css" href="jquery-ui/jquery-ui.css" rel="stylesheet" />
            <link rel="stylesheet" href="css/common.css" type="text/css" />
            <script type="text/javascript" src="js/jquery-3.6.4.min.js"></script>
            <script type="text/javascript" src="jquery-ui/jquery-ui.js"></script>
            <script type="text/javascript" src="js/common.js"></script>
            <% /* アクション種別の判定 */ String requestName=webBean.txt("request_name"); String actionType="unknown" ; if
              ("ins".equals(requestName) || "登録" .equals(requestName) || "ins" .equals(webBean.txt("request_cmd"))) {
              actionType="ins" ; } else if ("update".equals(requestName) || "修正" .equals(requestName) || "update"
              .equals(webBean.txt("request_cmd"))) { actionType="update" ; } else if ("delete".equals(requestName)
              || "確定" .equals(requestName) || "delete" .equals(webBean.txt("request_cmd"))) { actionType="delete" ; }
              else if ("send".equals(requestName) || "メール送信" .equals(requestName)) { actionType="send" ; } String
              actionBtn="メール送信" .equals(requestName) ? "go_mail" : "go_submit" ; String pageTitle="ユーザー情報 確認" ; if
              ("delete".equals(actionType)) { pageTitle="退職処理 確認" ; } else if ("update".equals(actionType)) {
              pageTitle="ユーザー情報 修正確認" ; } else if ("ins".equals(actionType)) { pageTitle="ユーザー情報 登録確認" ; } String
              btnLabel="修正" ; if ("delete".equals(actionType)) { btnLabel="確定" ; } else if ("メール送信".equals(requestName))
              { btnLabel="メール送信" ; } else if ("ins".equals(actionType)) { btnLabel="登録" ; } String
              adminVal=webBean.txt("admin"); String adminLabel="1" .equals(adminVal) ? "管理者" : "一般" ; /*
              退職予定日のフォーマット変換（yyyyMMdd → yyyy/MM/dd） */ String leaveDate=WebUtil.htmlEscape(webBean.txt("leave_date"));
              String formatLeaveDate="" ; if (leaveDate !=null && leaveDate.length()>= 8) {
              formatLeaveDate = leaveDate.substring(0, 4) + "/" + leaveDate.substring(4, 6) + "/" +
              leaveDate.substring(6, 8);
              }
              String userInfoId = webBean.txt("user_info_id");
              %>
              <title>
                <%= pageTitle %>
              </title>
              <style type="text/css">
                /* ===== 共通レイアウト ===== */
                body {
                  font-family: 'Arial', sans-serif;
                  background-color: #f9f9f9;
                  margin: 0;
                  padding: 10px;
                }

                header {
                  position: relative;
                  background: #00bcd4;
                  width: 100%;
                  height: 70px;
                  margin: 15px auto;
                  display: flex;
                  justify-content: center;
                  align-items: center;
                }

                h1 {
                  font-size: 36px;
                  color: white;
                  text-decoration: none;
                  font-weight: normal;
                }

                .container {
                  position: relative;
                  background-color: #f0f0f0;
                  border: 1px solid #ddd;
                  border-radius: 5px;
                  padding: 20px;
                  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                  width: 90%;
                  margin: 20px auto;
                }

                /* ===== 戻るボタン ===== */
                .new-btn {
                  position: absolute;
                  right: 10px;
                  top: 5px;
                }

                .new-btn input {
                  border-radius: 10px;
                  background: #fff;
                  color: #000;
                  cursor: pointer;
                  padding: 4px 16px;
                }

                /* ===== テーブル ===== */
                .left {
                  margin-bottom: 20px;
                  text-align: center;
                  display: flex;
                  justify-content: center;
                  align-items: center;
                }

                .input-table {
                  width: 60%;
                }

                table {
                  width: 100%;
                  border: 1px solid #ddd;
                  border-collapse: collapse;
                }

                td,
                th {
                  border: 1px solid #ddd;
                  padding: 8px;
                }

                .style_head3 {
                  padding-left: 10px;
                  font-size: 16px;
                  font-weight: bold;
                  text-align: center;
                }

                .style_head_size {
                  height: 32px;
                  vertical-align: middle;
                  background: #00bcd4;
                  color: #fff;
                }

                .input-text {
                  font-size: 16px;
                  background: #fff;
                  text-align: left;
                }

                /* ===== メッセージ ===== */
                .messages {
                  font-size: 22px;
                  margin-bottom: 20px;
                  text-align: center;
                }

                /* ===== 削除専用：ユーザー名強調 ===== */
                .delete-confirm-box {
                  background: #fff3f3;
                  border: 2px solid #e57373;
                  border-radius: 8px;
                  padding: 20px 30px;
                  margin: 20px auto;
                  width: 60%;
                  text-align: center;
                }

                .delete-confirm-box .user-name {
                  font-size: 32px;
                  font-weight: bold;
                  color: #c62828;
                  margin: 10px 0;
                }

                .delete-confirm-box .sub-info {
                  font-size: 16px;
                  color: #555;
                  margin-top: 8px;
                }

                /* ===== 確定ボタン ===== */
                .button {
                  display: flex;
                  justify-content: center;
                  align-items: center;
                  margin-top: 20px;
                }

                .button input[type="button"] {
                  padding: 8px 60px;
                  font-size: 22px;
                  border: 2px solid #fff;
                  border-radius: 10px;
                  cursor: pointer;
                  background-color: #00bcd4;
                  color: #fff;
                }

                .button input[type="button"]:hover {
                  background-color: #4baea8;
                }

                /* 削除確定ボタンは赤系 */
                .button.delete-btn input[type="button"] {
                  background-color: #e57373;
                }

                .button.delete-btn input[type="button"]:hover {
                  background-color: #c62828;
                }
              </style>
              <script type="text/javascript">
                /** 登録・修正・削除の確定処理 */
                function go_submit(action_cmd, request_cmd) {
                  document.getElementById('main_form').action = 'UserInfoDetail.do';
                  document.getElementById('action_cmd').value = action_cmd;
                  document.getElementById('request_cmd').value = request_cmd;
                  document.getElementById('main_form').submit();
                }

                /** メール送信処理 */
                function go_mail(action_cmd, request_cmd, main_key) {
                  document.getElementById('main_form').action = 'SendPassMail.do';
                  document.getElementById('action_cmd').value = action_cmd;
                  document.getElementById('request_cmd').value = request_cmd;
                  document.getElementById('main_key').value = main_key;
                  document.getElementById('main_form').submit();
                }

                /** 戻るボタン：前の入力画面または一覧へ */
                function go_list(action_cmd, request_cmd, main_key) {
                  document.getElementById('main_form').action = 'UserInfoDetail.do';
                  document.getElementById('action_cmd').value = action_cmd;
                  document.getElementById('request_cmd').value = request_cmd;
                  document.getElementById('main_key').value = main_key;
                  document.getElementById('main_form').submit();
                }
              </script>
          </head>

          <body>
            <div class="container">
              <!-- 戻るボタン -->
              <div class="new-btn">
                <input type="button" value="　戻る　" onclick="go_list('return','<%= actionType %>','<%= userInfoId %>')" />
              </div>

              <!-- ヘッダー -->
              <header>
                <h1>
                  <%= pageTitle %>
                </h1>
              </header>

              <!-- フォーム（hidden 値群） -->
              <form method="post" id="main_form" action="">
                <input type="hidden" name="form_name" id="form_name" value="UserInfoDetail_3" />
                <input type="hidden" name="action_cmd" id="action_cmd" value="" />
                <input type="hidden" name="request_cmd" id="request_cmd" value="<%= webBean.txt(" request_cmd") %>" />
                <input type="hidden" name="request_name" id="request_name" value="<%= webBean.txt(" request_name") %>"
                />
                <input type="hidden" name="main_key" id="main_key" value="<%= webBean.txt(" main_key") %>" />
                <input type="hidden" name="input_info" id="input_info" value="<%= webBean.txt(" input_info") %>" />
                <input type="hidden" name="select_info" id="select_info" value="<%= webBean.txt(" select_info") %>" />

                <!-- メッセージ -->
                <div class="style_head3 messages">
                  <%= webBean.dispMessages() %>
                </div>

                <!-- ============================================================
         		削除確認：ユーザー名と退職予定日のみ表示
    			============================================================ -->
                <% if ("delete".equals(actionType)) { %>
                  <div class="delete-confirm-box">
                    <p style="font-size:18px; color:#555;">以下の社員を退職処理します。よろしいですか？</p>
                    <div class="user-name">
                      <%= webBean.txt("last_name") %>　<%= webBean.txt("middle_name") %>　<%= webBean.txt("first_name") %>
                    </div>
                    <% if (!formatLeaveDate.isEmpty()) { %>
                      <div class="sub-info">退職予定日：<strong>
                          <%= formatLeaveDate %>
                        </strong></div>
                      <% } else { %>
                        <div class="sub-info" style="color:#e57373;">退職予定日：未設定</div>
                        <% } %>
                  </div>

                  <!-- ============================================================
         			登録・修正確認：入力された全項目を表示
    				============================================================ -->
                  <% } else { %>
                    <div class="left">
                      <table class="input-table">
                        <!-- ユーザーID -->
                        <tr>
                          <td class="style_head3 style_head_size" style="width:30%">ユーザーID</td>
                          <td class="input-text" style="width:70%">
                            <%= webBean.txt("user_info_id") %>
                          </td>
                        </tr>
                        <!-- 氏名 -->
                        <tr>
                          <td class="style_head3 style_head_size">氏名</td>
                          <td class="input-text">
                            <%= webBean.txt("last_name") %> <%= webBean.txt("middle_name") %> <%=
                                  webBean.txt("first_name") %>
                          </td>
                        </tr>
                        <!-- 氏名よみ -->
                        <tr>
                          <td class="style_head3 style_head_size">氏名よみ</td>
                          <td class="input-text">
                            <%= webBean.txt("last_name_kana") %> <%= webBean.txt("middle_name_kana") %> <%=
                                  webBean.txt("first_name_kana") %>
                          </td>
                        </tr>
                        <!-- 旧姓（入力がある場合のみ） -->
                        <% if (!webBean.txt("maiden_name").trim().isEmpty()) { %>
                          <tr>
                            <td class="style_head3 style_head_size">旧姓</td>
                            <td class="input-text">
                              <%= webBean.txt("maiden_name") %>
                            </td>
                          </tr>
                          <tr>
                            <td class="style_head3 style_head_size">旧姓よみ</td>
                            <td class="input-text">
                              <%= webBean.txt("maiden_name_kana") %>
                            </td>
                          </tr>
                          <% } %>
                            <!-- 任意ID（入力がある場合のみ） -->
                            <% if (!webBean.txt("insert_user_id").trim().isEmpty()) { %>
                              <tr>
                                <td class="style_head3 style_head_size">任意ＩＤ</td>
                                <td class="input-text">
                                  <%= webBean.txt("insert_user_id") %>
                                </td>
                              </tr>
                              <% } %>
                                <!-- メールアドレス -->
                                <tr>
                                  <td class="style_head3 style_head_size">メールアドレス</td>
                                  <td class="input-text">
                                    <%= webBean.txt("memail") %>
                                  </td>
                                </tr>
                                <!-- ユーザー区分（数値比較で正しく判定） -->
                                <tr>
                                  <td class="style_head3 style_head_size">ユーザー区分</td>
                                  <td class="input-text">
                                    <%= adminLabel %>
                                  </td>
                                </tr>
                                <!-- パスワード（新規登録時のみ表示） -->
                                <% if ("ins".equals(actionType)) { %>
                                  <tr>
                                    <td class="style_head3 style_head_size">パスワード</td>
                                    <td class="input-text">
                                      <%= webBean.txt("password") %>
                                    </td>
                                  </tr>
                                  <% } %>
                      </table>
                    </div>
                    <% } %>

                      <!-- 確定ボタン -->
                      <div class="button <%= " delete".equals(actionType) ? "delete-btn" : "" %>">
                        <input type="button" id="submitButton" value="<%= btnLabel %>"
                          onclick="<%= actionBtn %>('go_next','<%= actionType %>','<%= userInfoId %>')" />
                      </div>

              </form>
            </div>
          </body>

          </html>