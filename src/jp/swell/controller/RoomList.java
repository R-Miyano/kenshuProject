/*
 * (c)2023 PATAPATA Corp. Corp. All Rights Reserved
 *
 * システム名　　：PATAPATA System
 * サブシステム名：コントローラ
 * 機能名　　　　：room 部屋情報テーブルデータをLIST表示するためのコントローラクラス
 * ファイル名　　：RoomList.java
 * クラス名　　　：RoomList
 * 概要　　　　　：room 部屋情報テーブルデータをLIST表示するためのコントローラクラス
 * バージョン　　：
 *
 * 改版履歴　　　：
 * 2013/03/29 <新規>    新規作成
 *
 */
package jp.swell.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;

import jp.patasys.common.AtareSysException;
import jp.patasys.common.db.DaoPageInfo;
import jp.patasys.common.db.SystemUserInfoValue;
import jp.patasys.common.http.WebBean;
import jp.patasys.common.util.Sup;
import jp.patasys.common.util.Validate;
import jp.swell.common.ControllerBase;
import jp.swell.dao.RoomDao;

/**
 * 部屋情報（room）テーブルデータを一覧（LIST）表示するためのコントローラクラス。
 * 検索、ページネーション、ソート機能を提供する。
 *
 * @author PATAPATA
 * @version 1.0
 */
public class RoomList extends ControllerBase
{
    /**
     * コントローラの初期化処理。
     * jp.patasys.alumni.controller.HttpServlet のメソッドをオーバライドする。
     * doAction（リクエスト処理）の前に呼び出され、アクセス要件を設定する。
     */
    @Override
    public void doInit()
    {
        setLoginNeeds(false); // この処理にはログインが必要かどうか
        setHttpNeeds(false);  // この処理はhttpでなければならないか
        setHttpsNeeds(false); // この処理はhttps でなければならないか。公開時にはセキュア通信のためtrueにする
        setUsecache(false);   // この処理はクライアントのキャッシュを認めるか
    }

    /**
     * メインのコントローラ処理。
     * 画面からのリクエスト（form_name, action_cmd）に応じて、
     * 検索、ページ遷移、ソートなどの処理をルーティングする。
     *
     * @throws AtareSysException システム共通の例外エラー
     */
    @Override
    public void doActionProcess() throws AtareSysException
    {
        WebBean bean = getWebBean();

        // =========================================================
        // 1. 自画面（RoomList）からのリクエストの場合（検索・ページ遷移など）
        // =========================================================
        if ("RoomList".equals(bean.value("form_name")))
        {
            bean.trimAllItem(); // 入力値の前後の空白を除去

            if ("search".equals(bean.value("action_cmd"))) // 検索ボタン押下
            {
                bean.setValue("pageNo", "1"); // 検索時は1ページ目に戻す
                searchList();
                forward("RoomList.jsp");
            }
            else if ("next".equals(bean.value("action_cmd"))) // 次のページへ
            {
                bean.setValue("pageNo", calcPageNo(bean.value("pageNo"), 1));
                searchList();
                forward("RoomList.jsp");
            }
            else if ("jump".equals(bean.value("action_cmd"))) // 指定ページへジャンプ
            {
                searchList(); // pageNoは画面から渡されるためそのまま検索
                forward("RoomList.jsp");
            }
            else if ("prior".equals(bean.value("action_cmd"))) // 前のページへ
            {
                bean.setValue("pageNo", calcPageNo(bean.value("pageNo"), -1));
                searchList();
                forward("RoomList.jsp");
            }
            else if ("sort".equals(bean.value("action_cmd"))) // 見出しクリック等でのソート
            {
                searchList();
                forward("RoomList.jsp");
            }
            else if ("clear".equals(bean.value("action_cmd"))) // 検索条件クリア
            {
                formClear();
                searchList();
                forward("RoomList.jsp");
            }
            else if ("return".equals(bean.value("action_cmd"))) // メニューへ戻る
            {
                redirect("MenuAdmin.do");
            }
            else // その他のアクション（再表示など）
            {
                searchList();
                forward("RoomList.jsp");
            }
        }
        // =========================================================
        // 2. 詳細画面等からの戻り処理の場合（以前の検索状態を復元）
        // =========================================================
        else if ("RoomDetail".equals(bean.value("form_name")) || 
                 "UserInfoDetail_2".equals(bean.value("form_name")) || 
                 "UserInfoDetail_3".equals(bean.value("form_name")))
        {
            // シリアライズして保持していた検索条件（search_info）を復元
            setWebBeanFromSerialize(bean.value("search_info"));
            bean = getWebBean();
            searchList();
            forward("RoomList.jsp");
        }
        // =========================================================
        // 3. メニュー等からの初回遷移の場合
        // =========================================================
        else
        {
            formInit();   // 初期設定
            searchList(); // 初回検索（全件表示など）
            forward("RoomList.jsp");
        }
    }

    /**
     * 画面の初回表示時の初期化処理を行う。
     *
     * @throws AtareSysException
     */
    private void formInit() throws AtareSysException
    {
        WebBean bean = getWebBean();
        bean.setValue("sort_key", "room_id"); // 初回のソート対象項目
        bean.setValue("sort_order", "asc");   // 初回のソート順（昇順）
        // ユーザー固有の表示件数設定を取得（デフォルト100件）
        bean.setValue("lineCount", SystemUserInfoValue.getUserInfoValue(getLoginUserId(), "RoomList", "lineCount", "100"));
    }
   
    /**
     * 検索条件フィールドをクリアし、検索状態をリセットする。
     *
     * @throws AtareSysException
     */
    private void formClear() throws AtareSysException
    {
        WebBean bean = getWebBean();
        bean.setValue("list_search_room_name", ""); // 部屋名の検索条件をクリア
        bean.setValue("lineCount", "");             // 表示件数をクリア
        
        // クリア後の状態をシリアライズして画面に保持（状態維持用）
        String search_info = Sup.serialize(bean);
        bean.setValue("search_info", search_info);
    }

    /**
     * 検索条件の入力バリデーションを行う。
     *
     * @return errors HashMapにエラーフィールド名をキーとしてエラーメッセージを返す
     */
    private HashMap<String, String> inputCheck()
    {
        WebBean bean = getWebBean();
        HashMap<String, String> errors = bean.getItemErrors();
        
        // 部屋名検索条件の桁数超過チェック
        if (bean.value("list_search_room_name").length() > 0)
        {
            if (100 < bean.value("list_search_room_name").length())
            {
                errors.put("list_search_room_name", "部屋名の入力内容が長すぎます。");
            }
        }
        return errors;
    }

    /**
     * データベースを検索し、結果リストやページング情報をWebBeanに格納する。
     *
     * @throws AtareSysException
     */
    private void searchList() throws AtareSysException
    {
        WebBean bean = getWebBean();
        HashMap<String, String> errors;

        // 1. 検索条件のチェック
        errors = inputCheck();
        if (errors.size() > 0)
        {
            bean.setValue("errors", errors);
            return; // エラーがあれば検索を行わずに終了
        }

        // 2. ソートキーの決定
        LinkedHashMap<String, String> sortKey = sortKey();

        // 3. 検索条件のセット（部分一致検索のために "%" を付与）
        RoomDao dao = new RoomDao();
        dao.setRoomName("%" + bean.value("list_search_room_name") + "%");

        // 4. ページネーション（DaoPageInfo）の設定
        DaoPageInfo daoPageInfo = new DaoPageInfo();
        
        // 表示件数の設定（不正値の場合はデフォルト20件）
        if (!Validate.isInteger(bean.value("lineCount")))
        {
            bean.setValue("lineCount", "20");
        }
        daoPageInfo.setLineCount(Integer.parseInt(bean.value("lineCount")));
        
        // ユーザーの表示件数設定をDBに保存
        SystemUserInfoValue.setUserInfoValue(getLoginUserId(), "RoomList", "lineCount", bean.value("lineCount"));
        
        // ページ番号の設定
        if (!Validate.isInteger(bean.value("pageNo")))
        {
            daoPageInfo.setPageNo(1);
        }
        else
        {
            daoPageInfo.setPageNo(Integer.parseInt(bean.value("pageNo")));
        }

        // 5. データベースからリストを取得
        ArrayList<RoomDao> listData = RoomDao.dbSelectList(dao, sortKey, daoPageInfo);

        // 6. 取得したページング情報と検索結果を画面表示用にセット
        bean.setValue("lineCount", daoPageInfo.getLineCount());
        bean.setValue("pageNo", daoPageInfo.getPageNo());
        bean.setValue("recordCount", daoPageInfo.getRecordCount());
        bean.setValue("maxPageNo", daoPageInfo.getMaxPageNo());

        // 現在の検索状態をシリアライズして保持（詳細画面からの戻り用）
        bean.getWebValues().remove("search_info");
        String search_info = Sup.serialize(bean);
        bean.setValue("search_info", search_info);
        
        // 検索結果リストをセット
        bean.setValue("list", listData);
    }

    /**
     * ソート順（カラムと昇順・降順）を決定する。
     * 見出しをクリックするたびに昇順・降順が切り替わる（フリップフロップ処理）を行う。
     *
     * @return ソート順を格納したマップ（キー：カラム名、値：asc または desc）
     */
    private LinkedHashMap<String, String> sortKey()
    {
        WebBean bean = getWebBean();
        String key = "";
        LinkedHashMap<String, String> sort_key = new LinkedHashMap<String, String>(); /* この配列にソートキーとソートオーダーを入れる */
        
        // ソートキーが全く設定されていない場合はnullを返す
        if (bean.value("sort_key").length() == 0 && bean.value("sort_key_old").length() == 0) return null;

        if (bean.value("sort_key_old").length() > 0)
        {
            if (bean.value("sort_key").length() > 0)
            {
                if (bean.value("sort_key").equals(bean.value("sort_key_old")))
                {
                    // 前回と同じカラムがクリックされた場合（昇順・降順を反転）
                    key = bean.value("sort_key_old");
                    if ("desc".equals(bean.value("sort_order")))
                    {
                        sort_key.put(key, "asc");
                    }
                    else
                    {
                        sort_key.put(key, "desc");
                    }
                }
                else
                {
                    // 前回と異なる新しいカラムがクリックされた場合（常に昇順からスタート）
                    key = bean.value("sort_key");
                    sort_key.put(key, "asc");
                }
            }
            else
            {
                // リクエストにソートキーがない場合（ページ遷移など）、前回のソート状態を引き継ぐ
                key = bean.value("sort_key_old");
                if ("asc".equals(bean.value("sort_order")))
                {
                    sort_key.put(key, "asc");
                }
                else
                {
                    sort_key.put(key, "desc");
                }
            }
        }
        else
        {
            // 初期状態からのソート
            key = bean.value("sort_key");
            if ("asc".equals(bean.value("sort_order")))
            {
                sort_key.put(key, "asc");
            }
            else
            {
                sort_key.put(key, "desc");
            }
        }

        // 次回判定用に現在のソート状態を保存
        bean.setValue("sort_key", "");
        bean.setValue("sort_key_old", key);
        bean.setValue("sort_order", sort_key.get(key));
        
        return sort_key;
    }

    /**
     * ページ番号の加算・減算を安全に行う。
     *
     * @param pageNo 現在のページ番号（文字列）
     * @param add    加算・減算する値（1 または -1）
     * @return 計算結果のページ番号文字列
     */
    private String calcPageNo(String pageNo, int add)
    {
        int ret;
        // ページ番号が不正、または空の場合は1ページ目として扱う
        if (null == pageNo || "".equals(pageNo) || !Validate.isInteger(pageNo))
        {
            pageNo = "1";
        }
        
        ret = Integer.parseInt(pageNo);
        ret += add; // 加算処理
        
        return String.valueOf(ret);
    }
}