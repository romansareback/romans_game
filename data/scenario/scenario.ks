[iscript]
tyrano.plugin.kag.setTitle("体力ゲージと攻撃ボタン");
[endlink]

; 画面クリア
[cm]
@bg storage="シローマン.jpg" time=1000 ; 背景を設定

; 体力ゲージを表示するエリアを作成
[iscript]
var max_hp = 100; // 最大HP
var current_hp = max_hp; // 現在のHP

// HPバーを描画する関数
function updateHpBar() {
    var hp_percentage = (current_hp / max_hp) * 100;
    $("#hp_bar").css("width", hp_percentage + "%");
    $("#hp_text").text("HP: " + current_hp + "/" + max_hp);
}

// ゲージのHTML要素を作成
$(".layer_free").append(`
    <div id="hp_container" style="position: absolute; top: 50px; left: 50px; width: 300px; height: 30px; background-color: #ccc; border: 2px solid #000;">
        <div id="hp_bar" style="width: 100%; height: 100%; background-color: green;"></div>
    </div>
    <div id="hp_text" style="position: absolute; top: 90px; left: 50px; font-size: 20px; color: black;">HP: 100/100</div>
`);

// 初期状態のHPバーを設定
updateHpBar();
[endlink]

; 攻撃ボタン
[button text="攻撃する" x=400 y=500 target="attack" color="red"]

*attack
[cm]
[iscript]
    // 攻撃でHPを10減らす
    current_hp -= 10;
    if (current_hp < 0) {
        current_hp = 0;
    }
    updateHpBar();

    // HPが0になったらメッセージ表示
    if (current_hp <= 0) {
        tyrano.plugin.kag.ftag.startTag("jump", {"target":"gameover"});
    }
[endlink]

; 攻撃後に再び攻撃ボタンを表示
[button text="攻撃する" x=400 y=500 storage="attack" color="red"]

*gameover
[cm]
@bg storage="gameover.jpg" time=1000 ; ゲームオーバー背景
「あなたは倒れました...」
[end]
