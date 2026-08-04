{ local, ... }:
{
  system = {
    stateVersion = 6;
    primaryUser = local.userName;

    keyboard = {
      enableKeyMapping = true;
      # CapsLockをControlにマッピング
      remapCapsLockToControl = true;
    };

    defaults = {
      CustomSystemPreferences = {
        "com.apple.security.authorization" = {
          ignoreArd = true;
        };
      };
      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
        };
      };
      WindowManager = {
        # デスクトップ上のアイテムを非表示にする
        StandardHideDesktopIcons = true;
      };
      controlcenter = {
        # メニューバーにAirDropを表示する
        AirDrop = true;
        # メニューバーにバッテリー残量を表示する
        BatteryShowPercentage = true;
        # メニューバーにBluetoothを表示する
        Bluetooth = true;
      };
      dock = {
        # アプリケーションスイッチャーを全てのディスプレイに表示する
        appswitcher-all-displays = true;
        # Dockの自動非表示を有効にする
        autohide = true;
        # Mission ControlのExposeでアプリケーションをグループ化する
        expose-group-apps = true;
        # Dockのホバー時の拡大サイズ
        largesize = 48;
        # Dockのホバー時の拡大を有効にする
        magnification = true;
        # Dockの位置を左側に設定する
        orientation = "right";
        # 最近使用したアプリケーションをDockに表示しない
        show-recents = false;
        # 開いているアプリケーションのみをDockに表示する
        static-only = true;
        # Dock内のアイコンサイズ
        tilesize = 32;
        # ホットコーナー(左下)にMission Controlを設定する
        wvous-bl-corner = 2;
        # ホットコーナー(左上)に画面ロックを設定する
        wvous-tl-corner = 13;
        # ホットコーナー(右上)にMission Controlを設定する
        wvous-tr-corner = 2;
      };
      finder = {
        # 拡張子を常に表示する
        AppleShowAllExtensions = true;
        # 隠しファイルを常に表示する
        AppleShowAllFiles = true;
        # Finderアイコンをデスクトップに表示しない
        CreateDesktop = false;
        # 拡張子を変更するときに警告を表示しない
        FXEnableExtensionChangeWarning = false;
        # リストビューをデフォルトにする
        FXPreferredViewStyle = "Nlsv";
        # CD, DVDなどをデスクトップに表示しない
        ShowRemovableMediaOnDesktop = false;
        # Finderの下部にステータスバーを表示する
        ShowStatusBar = true;
        # 完全パスを表示する
        _FXShowPosixPathInTitle = true;
      };
      magicmouse = {
        # 左右クリックを有効にする
        MouseButtonMode = "TwoButton";
      };
      trackpad = {
        # タップでクリックを有効にする
        Clicking = true;
        # 2本指タップ/クリックで右クリックを有効にする
        TrackpadRightClick = true;
      };
      menuExtraClock = {
        # メニューバーの時計を24時間表示にする
        Show24Hour = true;
        # メニューバーに余裕がある場合は日付を表示する
        ShowDate = 0;
        # 日付を表示する
        ShowDayOfMonth = true;
        # 曜日を表示する
        ShowDayOfWeek = true;
        # 秒は表示しない
        ShowSeconds = false;
      };
      screensaver = {
        # 復帰時に即座に認証を要求する
        askForPassword = true;
        askForPasswordDelay = 0;
      };
      spaces = {
        # ディスプレイごとに異なるスペースを使用する
        spans-displays = false;
      };
    };
  };

  security.pam.services.sudo_local = {
    reattach = true;
    touchIdAuth = true;
  };
}
