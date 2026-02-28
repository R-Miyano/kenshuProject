package jp.swell.controller;

import jp.patasys.common.AtareSysException;
import jp.swell.common.ControllerBase;
import jp.swell.user.UserLoginInfo;

/**
 * ログイン時に管理者権限のあるユーザーの遷移先
 * 管理メニュー
 */
public class MenuAdmin extends ControllerBase {

    /**
     * jp.patasys.alumni.controller.HttpServlet のメソッドをオーバライドする。
     * オーバライドしない場合は、デフォルトが設定される。.
     * この処理にはログインが必要かどうか デフォルト true.
     * この処理はhttpでなければならないか デフォルト false.
     * この処理はhttps でなければならないか デフォルト false.
     * この処理はクライアントのキャッシュを認めるか デフォルト false. 等を設定する。
     * doActionの前に呼ばれる。
     */
    @Override
    public void doInit() {
        setLoginNeeds(true); // この処理にはログインが必要かどうか
        setHttpNeeds(false); // この処理はhttpでなければならないか
        setHttpsNeeds(false); // この処理はhttps でなければならないか。公開時にはtrueにする
        setUsecache(false); // この処理はクライアントのキャッシュを認めるか
    }

    @Override
    public void doActionProcess() throws AtareSysException {
        UserLoginInfo loginInfo = (UserLoginInfo) getLoginInfo();

        // ログイン情報が取得できない場合はログインページへ
        if (loginInfo == null) {
            redirect("UserLogin.do");
            return;
        }

        // 管理者権限を確認してから遷移する
        if (loginInfo.isSystemManager()) {
            // 管理者であれば管理者メニューページを表示
            forward("/MenuAdmin.jsp");
        } else {
            // 管理者でなければ一般ユーザーメニューへリダイレクト
            redirect("UserMenu.do");
        }
    }
}