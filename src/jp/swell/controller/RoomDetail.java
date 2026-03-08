/*
 * (c)2023 PATAPATA Corp. Corp. All Rights Reserved
 *
 * システム名　　：PATAPATA System
 * サブシステム名：コントローラ
 * 機能名　　　　：room 部屋情報テーブルデータを登録・更新・削除するためのコントローラクラス
 * ファイル名　　：RoomDetail.java
 * クラス名　　　：RoomDetail
 * 概要　　　　　：room 部屋情報テーブルデータを登録・更新・削除するためのコントローラクラス
 * バージョン　　：
 *
 * 改版履歴　　　：
 * 2013/03/29 <新規>    新規作成
 *
 */
package jp.swell.controller;

import java.util.HashMap;

import jp.patasys.common.AtareSysException;
import jp.patasys.common.db.DbBase;
import jp.patasys.common.http.WebBean;
import jp.patasys.common.util.Sup;
import jp.swell.common.ControllerBase;
import jp.swell.dao.RoomDao;

/**
 * 部屋情報（room）テーブルデータを登録・更新・削除するためのコントローラクラス。
 *
 * @author PATAPATA
 * @version 1.0
 */
public class RoomDetail extends ControllerBase {
    /**
     * コントローラの初期化処理。
     * jp.patasys.alumni.controller.HttpServlet のメソッドをオーバライドする。
     * doAction（リクエスト処理）の前に呼び出され、アクセス要件を設定する。
     */
    @Override
    public void doInit() {
        setLoginNeeds(false); // この処理にはログインが必要かどうか（デフォルト true）
        setHttpNeeds(false); // この処理はhttpでなければならないか（デフォルト false）
        setHttpsNeeds(false); // この処理はhttps でなければならないか。公開時にはセキュア通信のためtrueにする
        setUsecache(false); // この処理はクライアントのキャッシュを認めるか（デフォルト false）
    }

    /**
     * メインのコントローラ処理。
     * 画面からのリクエスト（form_name, action_cmd, request_cmd）に応じて、
     * 登録・修正・削除の確認画面への遷移や、実際のDB処理の呼び出しをルーティングする。
     *
     * @throws AtareSysException システム共通の例外エラー
     */
    @Override
    public void doActionProcess() throws AtareSysException {
        WebBean bean = getWebBean();

        try {
            // 画面から送信されたパラメータの取得
            String formName = bean.value("form_name"); // 遷移元の画面名
            String actionCmd = bean.value("action_cmd"); // 実行アクション（次へ進む、戻るなど）
            String requestCmd = bean.value("request_cmd"); // 処理種別（登録:ins, 更新:update, 削除:deletef など）
            String mainKey = bean.value("main_key"); // 対象データの主キー(RoomId)
            String roomName = bean.value("room_name"); // 入力された部屋名
            String beforeName = bean.value("before_name"); // 変更前の部屋名

            // 入力情報をDAOにセットし、シリアライズして保持
            RoomDao dao = setWeb2Dao2InputInfo();

            bean.setValue("request_name", "修正する"); // デフォルトのボタン表示名

            // 更新時の比較用：変更前の名前が未設定の場合は、現在の部屋名をセットしておく
            if (beforeName == null || beforeName.trim().isEmpty()) {
                beforeName = roomName;
            }
            bean.setValue("before_name", beforeName);
            bean.setValue("room_name", roomName);

            /*
             * ==================================================
             * 1. 「部屋詳細（入力）画面」からのリクエスト処理
             * ==================================================
             */
            if ("RoomDetail".equals(formName)) {
                if ("go_next".equals(actionCmd)) // 確認画面へ進む
                {
                    if ("ins".equals(requestCmd)) // 登録の場合
                    {
                        bean.setMessage("この内容で登録します。よろしいですか？");
                        bean.setValue("request_name", "登録する");
                        bean.setValue("room_name", roomName);
                        forward("RoomConfirm.jsp"); // 確認画面へフォワード
                    } else if ("update".equals(requestCmd)) // 更新の場合
                    {
                        bean.setMessage("この内容で修正します。よろしいですか？");
                        bean.setValue("request_name", "修正する");
                        bean.setValue("before_name", beforeName);
                        bean.setValue("room_name", roomName);
                        forward("RoomConfirm.jsp"); // 確認画面へフォワード
                    }
                } else if ("return".equals(actionCmd)) // 一覧へ戻る場合
                {
                    forward("RoomList.do");
                }
            }
            /*
             * ==================================================
             * 2. 「部屋一覧画面」からのリクエスト処理
             * ==================================================
             */
            else if ("RoomList".equals(formName)) {
                if ("go_next".equals(actionCmd)) {
                    if ("ins".equals(requestCmd)) // 新規登録ボタン押下
                    {
                        bean.setValue("request_name", "登録する");
                        forward("RoomConfirm.jsp"); // 詳細（入力）画面へ
                    } else if ("update".equals(requestCmd)) // 修正ボタン押下
                    {
                        // DBから対象データを取得して画面にセット
                        if (!setDb2Web()) {
                            bean.setError("データの取得に失敗しました");
                            forward("RoomList.jsp");
                        } else {
                            bean.setValue("request_name", "修正する");
                            bean.setValue("before_name", beforeName);
                            forward("RoomConfirm.jsp"); // 詳細（入力）画面へ
                        }
                    } else if ("deletef".equals(requestCmd)) // 削除ボタン押下
                    {
                        // 削除対象が存在するか確認
                        if (!dao.dbSelect(mainKey)) {
                            bean.setError("データの取得に失敗しました");
                            forward("RoomList.jsp");
                        } else {
                            bean.setMessage("この部屋を削除します。よろしいですか？");
                            bean.setValue("request_name", "削除する");
                            bean.setValue("room_name", roomName);
                            forward("RoomConfirm.jsp"); // 確認画面へ直接フォワード
                        }
                    }
                }
            }
            /*
             * ==================================================
             * 3. 「部屋詳細（確認）画面」からのリクエスト処理（実際のDB反映）
             * ==================================================
             */
            else if ("RoomConfirm".equals(formName) || "RoomDetail_2".equals(formName)) {
                if ("go_next".equals(actionCmd)) // 確定ボタン押下
                {
                    if ("insConfirm".equals(requestCmd) || "insEnter".equals(requestCmd)) // 登録実行
                    {
                        dbRegistration();
                    } else if ("updateConfirm".equals(requestCmd) || "updateEnter".equals(requestCmd)) // 更新実行
                    {
                        dbEdit();
                    } else if ("deleteConfirm".equals(requestCmd) || "deleteEnter".equals(requestCmd)) // 削除実行
                    {
                        dbDeletef();
                    }
                } else if ("return".equals(actionCmd)) {
                    if ("insConfirm".equals(requestCmd)) {
                        bean.setValue("request_name", "登録する");
                        bean.setValue("request_cmd", "ins");
                        forward("RoomConfirm.jsp");
                    } else if ("updateConfirm".equals(requestCmd)) {
                        bean.setValue("request_name", "修正する");
                        bean.setValue("request_cmd", "update");
                        forward("RoomConfirm.jsp");
                    } else {
                        redirect("RoomList.do");
                    }
                }
                // 実行後は一覧画面へリダイレクト（二重送信防止のため）の処理を回避
            }
            /*
             * ==================================================
             * 4. その他の不正な遷移や初期表示時の処理
             * ==================================================
             */
            else {
                bean.setValue("request_name", "修正する");
                bean.setValue(requestCmd, "update");
                if (!setDb2Web()) {
                    bean.setError("データの取得に失敗しました");
                }
                bean.setMessage("以下の項目を修正してください。");
                forward("RoomList.jsp");
            }
        } catch (Exception e) {
            // 予期せぬエラーのハンドリング
            bean.setError("処理中にエラーが発生しました: " + e.getMessage());
            forward("ErrorPage.jsp");
        }
    }

    /**
     * 新規登録の実行処理。
     * 入力チェック後、DBへの登録（トランザクション処理）を行う。
     * * @throws AtareSysException
     */
    public void dbRegistration() throws AtareSysException {
        WebBean bean = getWebBean();
        bean.rtrimAllItem(); // 入力項目の末尾スペースを除去
        RoomDao dao = setWeb2Dao2InputInfo();

        // 入力チェックを実施
        if (inputCheck(dao)) {
            if (signUp()) // DB登録処理
            {
                // セッションにメッセージを保存
                String roomName = dao.getRoomName();
                getRequest().getSession().setAttribute("flash_message", roomName + "を新規登録しました");
                redirect("RoomList.do"); // 成功時は一覧へ
            } else {
                bean.setError("登録に失敗しました");
                bean.setValue("request_name", "登録する"); // 新規登録ページであることを維持
                forward("RoomConfirm.jsp"); // 失敗時は入力画面へ戻る
            }
        } else {
            bean.setError("入力内容に誤りがあります");
            bean.setValue("request_name", "登録する"); // 新規登録ページであることを維持
            forward("RoomConfirm.jsp"); // バリデーションエラー時
        }
    }

    /**
     * 修正（更新）の実行処理。
     * 入力チェック後、DBの対象レコードを更新する。
     * * @throws AtareSysException
     */
    public void dbEdit() throws AtareSysException {
        WebBean bean = getWebBean();
        bean.rtrimAllItem();
        RoomDao dao = setWeb2Dao2InputInfo();
        String mainKey = bean.value("main_key"); // RoomIdの取得

        if (inputCheck(dao)) {
            try {
                // トランザクション制御
                DbBase.dbBeginTran();
                dao.dbUpdate(mainKey); // 更新実行
                DbBase.dbCommitTran();
                // セッションにメッセージを保存
                String roomName = dao.getRoomName();
                getRequest().getSession().setAttribute("flash_message", roomName + "に更新しました");
                redirect("RoomList.do");
            } catch (Exception e) {
                DbBase.dbRollbackTran(); // 失敗時はロールバック
                forward("RoomConfirm.jsp");
            }
        } else {
            // 入力チェックエラー時、元の名前に戻してエラー表示
            String beforeName = bean.value("before_name").trim();
            bean.setValue("room_name", beforeName);
            bean.setValue("before_name", beforeName);

            bean.setError("入力項目にエラーがあります。下記事項をご確認ください。");
            forward("RoomConfirm.jsp");
        }
    }

    /**
     * 削除の実行処理。
     * データベースから指定された主キーのレコードを削除する。
     * * @throws AtareSysException
     */
    public void dbDeletef() throws AtareSysException {
        WebBean bean = getWebBean();
        bean.rtrimAllItem();
        RoomDao dao = setWeb2Dao2InputInfo();
        String mainKey = bean.value("main_key"); // RoomIdの取得

        try {
            // トランザクション制御
            DbBase.dbBeginTran();
            dao.dbDelete(mainKey); // 削除実行
            DbBase.dbCommitTran();
            // セッションにメッセージを保存
            String roomName = dao.getRoomName();
            getRequest().getSession().setAttribute("flash_message", roomName + "を削除しました");
            redirect("RoomList.do");
        } catch (Exception e) {
            DbBase.dbRollbackTran(); // 失敗時はロールバック
            forward("RoomConfirm.jsp");
        }
    }

    /**
     * DBから主キーを元に対象レコードを取得し、表示エリア(WebBean)に設定する。
     *
     * @return 取得成功時はtrue、データが存在しない場合はfalse
     * @throws AtareSysException エラー
     */
    private boolean setDb2Web() throws AtareSysException {
        WebBean bean = getWebBean();
        RoomDao dao = new RoomDao();
        String mainKey = bean.value("main_key"); // RoomIdの取得

        // データの取得
        if (!dao.dbSelect(mainKey)) {
            return false;
        }

        // 取得した値を画面表示用のBeanにセット
        bean.setValue("room_id", dao.getRoomId());
        bean.setValue("room_name", dao.getRoomName());
        bean.setValue("insert_date", dao.getInsertDate());
        bean.setValue("insert_user_id", dao.getInsertUserId());
        bean.setValue("update_date", dao.getUpdateDate());
        bean.setValue("update_user_id", dao.getUpdateUserId());

        // 編集前データをシリアライズして隠しフィールド等に保持しておく
        bean.setValue("select_info", Sup.serialize(dao));
        bean.setValue("input_info", Sup.serialize(dao));

        return true;
    }

    /**
     * 入力チェック（バリデーション）を行う。
     *
     * @param pRoomDao チェック対象のDAO
     * @return エラーがない場合はtrue、エラーがある場合はfalse
     * @throws AtareSysException
     */
    private boolean inputCheck(RoomDao pRoomDao) throws AtareSysException {
        WebBean bean = getWebBean();
        HashMap<String, String> errors = bean.getItemErrors(); // エラー格納用マップ
        String roomName = bean.value("room_name").trim();
        String beforeName = "";
        if (bean.value("before_name") != null) {
            beforeName = bean.value("before_name").trim(); // hidden 等から取得した変更前名称
        }
        String requestCmd = bean.value("request_cmd"); // 現在の処理種別を取得

        // 必須入力チェック
        if (roomName.length() == 0) {
            errors.put("room_name_empty", "部屋名を入力してください。");
        }
        // 更新時のみ同一名称チェック（変更されていない場合の警告）
        if ("update".equals(requestCmd) || "updateEnter".equals(requestCmd) || "updateConfirm".equals(requestCmd)) {
            if (roomName.equalsIgnoreCase(beforeName)) {
                errors.put("room_name_duplicate", "部屋名が以前と同じです。別の名前を入力してください。");
            }
        }

        // エラーマップが空であればチェックOK
        return errors.isEmpty();
    }

    /**
     * 画面の入力項目をDAOクラスに格納し、それをシリアライズして input_info フィールドに格納する。
     *
     * @return 入力値がセットされたRoomDaoインスタンス
     * @throws AtareSysException エラー
     */
    private RoomDao setWeb2Dao2InputInfo() throws AtareSysException {
        WebBean bean = getWebBean();
        RoomDao dao = new RoomDao();

        // 画面の入力値をDAOにセット
        dao.setRoomName(bean.value("room_name"));

        // オブジェクトの永続化・引継ぎ用にシリアライズ
        bean.setValue("input_info", Sup.serialize(dao));
        return dao;
    }

    /**
     * 部屋の新規登録処理（DBインサート）をトランザクション内で行うメソッド。
     * * @return 登録が成功した場合はtrue、失敗した場合はfalse
     * 
     * @throws AtareSysException
     */
    private boolean signUp() throws AtareSysException {
        RoomDao dao = setWeb2Dao2InputInfo();

        try {
            DbBase.dbBeginTran();
            dao.dbInsert(); // 新規登録実行
            DbBase.dbCommitTran();
            return true;
        } catch (Exception e) {
            DbBase.dbRollbackTran();
            return false;
        }
    }

    /**
     * input_info フィールドからシリアライズされたクラスを取り出し、画面の項目に値を復元する。
     * （※現在未使用）
     *
     * @throws AtareSysException
     */
    @SuppressWarnings("unused")
    private void setInputInfo2Dao2Web() throws AtareSysException {
        WebBean bean = getWebBean();
        // シリアライズされた情報をデシリアライズしてDAOに復元
        RoomDao dao = (RoomDao) Sup.deserialize(bean.value("input_info"));

        // 復元したデータをWebBeanに再セット
        bean.setValue("room_id", dao.getRoomId());
        bean.setValue("room_name", dao.getRoomName());
        bean.setValue("insert_date", dao.getInsertDate());
        bean.setValue("insert_user_id", dao.getInsertUserId());
        bean.setValue("update_date", dao.getUpdateDate());
        bean.setValue("update_user_id", dao.getUpdateUserId());
    }
}