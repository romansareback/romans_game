*init_fullscreen
[cm]
@bg storage="ゲームUI-01-01.png"  ; 任意の背景画像を指定してください
[position layer="message0" left=0 top=500 width=100% height=20% page=fore visible=true]
[iscript]
// 画面全体をタッチ可能な透明エリアとして追加
$(".layer_free").append('<div id="start_area" style="position:absolute; top:0; left:0; width:100%; height:100%; z-index:1000;"></div>');
// タッチエリアにクリックイベントを登録
$("#start_area").on("click", function(){
    var element = document.documentElement;
    // 全画面表示のリクエスト
    if (element.requestFullscreen) {
        element.requestFullscreen().then(function(){
            // 対応ブラウザでは横向きロックも試みる（オプション）
            if (screen.orientation && screen.orientation.lock) {
                screen.orientation.lock("landscape").catch(function(err){
                    console.error("Orientation lock failed:", err);
                });
            }
            // 全画面表示完了後、scenario.ks へジャン
            tyrano.plugin.kag.ftag.startTag("jump", {"storage": "scenario.ks"});
        });
    } else if (element.webkitRequestFullscreen) {
        element.webkitRequestFullscreen();
        tyrano.plugin.kag.ftag.startTag("jump", {"storage": "scenario.ks"});
    } else if (element.msRequestFullscreen) {
        element.msRequestFullscreen();
        tyrano.plugin.kag.ftag.startTag("jump", {"storage": "scenario.ks"});
    } else {
        // 全画面APIが使えない場合はそのままジャンプ
        tyrano.plugin.kag.ftag.startTag("jump", {"storage": "scenario.ks"});
    }
});
[endscript]


[glink color="#ffffff" align="center"]
「画面をタップしてゲーム開始」