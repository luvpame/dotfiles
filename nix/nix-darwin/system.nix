{ ... }:
{
  networking.applicationFirewall = {
    blockAllIncoming = false;
    enable = true;
  };

  system = {
    stateVersion = 6;

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
        NSGlobalDomain = {
          # フルスクリーン時もメニューバーを表示する
          AppleMenuBarVisibleInFullscreen = true;
          # メニューバーの背景を表示する（macOS Tahoe）
          SLSMenuBarUseBlurredAppearance = true;
        };
        "com.apple.controlcenter" = {
          "NSStatusItem VisibleCC WiFi" = true;
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
        };
      };
      NSGlobalDomain = {
        # メニューバーを自動的に隠さない
        _HIHideMenuBar = false;
      };
      WindowManager = {
        # デスクトップ上のアイテムを非表示にする
        StandardHideDesktopIcons = true;
      };
      controlcenter = {
        # メニューバーにAirDropを表示しない
        AirDrop = false;
        # メニューバーにバッテリー残量を表示しない
        BatteryShowPercentage = false;
        # メニューバーにBluetoothを表示しない
        Bluetooth = false;
      };
      dock = {
        # アプリケーションスイッチャーを全てのディスプレイに表示する
        appswitcher-all-displays = true;
        # Dockを自動的に表示・非表示にする
        autohide = true;
        # Mission ControlのExposeでアプリケーションをグループ化する
        expose-group-apps = true;
        # Dockのホバー時の拡大サイズ
        largesize = 48;
        # Dockのホバー時の拡大を有効にする
        magnification = true;
        # Dockの位置を下側に設定する
        orientation = "bottom";
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
        # 日付なしのアナログ時計を表示する
        IsAnalog = true;
        Show24Hour = false;
        ShowDate = 2;
        ShowDayOfMonth = false;
        ShowDayOfWeek = false;
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
