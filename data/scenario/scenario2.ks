
[cm]
@bg storage="シローマン.jpg" 



*start

[iscript]
tf.tag = '<img src="data/image/button/ゲームUI-03.png" width=40 height=40>';
tyrano.plugin.kag.setTitle("体力ゲージと攻撃ボタン");

// 最大HPと現在のHPをグローバル変数として宣言
window.max_hp = 100;
window.current_hp = max_hp;
window.previous_hp = max_hp;
// HPバーを更新する関数をグローバルに定義
window.updateHpBar = function () {
    var hp_percentage = (current_hp / max_hp) * 100;

    // アニメーションでHPバーの幅を変更
    $("#hp_bar").animate(
        { width: hp_percentage + "%" }, 
        {
            duration: 500, // アニメーションの持続時間（ミリ秒）
            easing: "linear", // アニメーションのイージング
            step: function(now, fx) {
                // アニメーション中もHPテキストを更新
                $("#hp_text").text("気力: " + Math.round(now / 100 * max_hp) + "/" + max_hp);
            },
            complete: function() {
                // 完了時に正確なHPテキストを表示
                $("#hp_text").text("気力: " + current_hp + "/" + max_hp);
            }
        }
    );
};

window.createHpBar = function () {
    // 既に体力ゲージが存在していれば削除
    var percentage = (previous_hp / max_hp) * 100;
    $("#hp_container, #hp_text").remove();

    // 体力ゲージのHTML要素を追加
    $(".layer_free").append(`
        <div id="hp_container" style="position: absolute; top: 50px; left: 80px; width: 300px; height: 30px; background-color: #ccc; border: 2px solid #000;">
            <div id="hp_bar" style="width: ${percentage}%; height: 100%; background-color: green;"></div>
        </div>
        <div id="hp_text" style="position: absolute; top: 90px; left: 80px; font-size: 20px; color: black;">HP: ${previous_hp}/100</div>
    `);

    // HPバーの初期状態を設定
    updateHpBar();
}
window.createButton = function () {

    $(".layer_free").append(`
    <button id="attack_button" style="position: absolute;  ">攻撃する</button>
    <button id="comfort_button" style="position: absolute; ">慰める</button>
    `
    );
}
$(document).ready(function() {
    // ページ読み込み時に体力ゲージとボタンを生成
    createHpBar();
    createButton();

    // 動的に生成されたボタンにイベントをバインド
    $(document).on("click", "#attack_button", function() {
        handleAction("attack");
    });

    $(document).on("click", "#comfort_button", function() {
        handleAction("comfort");
    });
});

window.handleAction = function(actionType) {
    previous_hp = current_hp;

    if (actionType === "attack") {
        current_hp -= 10;
        if (current_hp < 0) current_hp = 0;
    } else if (actionType === "comfort") {
        current_hp += 10;
        if (current_hp > max_hp) current_hp = max_hp;
    }

    createHpBar();

    if (current_hp <= 0) {
        // ゲームオーバー画面へ
        tyrano.plugin.kag.ftag.startTag("jump", {"target":"gameover"});
    }
};

window.showGameOver = function() {
    $(".layer_free").html(`
        <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center;">
            <img src="gameover.jpg" alt="Game Over" style="width: 300px;">
            <p>あなたは倒れました...</p>
        </div>
    `);
};

$("#attack_button").on("click", function() {
        handleAction("attack");
    });
$("#comfort_button").on("click", function() {
        handleAction("comfort");
    });

[endscript]

[glink text="攻撃する" x=400 y=500 target="attack" color="red"]
[glink text="慰める" x=800 y=500 target="comfort" color="blue"]
[s]

*attack
[cm]
[iscript]
    // 攻撃でHPを10減らす
    previous_hp = current_hp;
    current_hp -= 10;
    if (current_hp < 0) {
        current_hp = 0;
    }
    createHpBar();

    // HPが0になったらゲームオーバーへジャンプ
    if (current_hp <= 0) {
        tyrano.plugin.kag.ftag.startTag("jump", {"target":"gameover"});
    }
    
[endscript]

*comfort
[cm]
[iscript]
    // 慰めでHPを10回復
    previous_hp = current_hp;
    current_hp += 10;
    if (current_hp > 100) {
        current_hp = 100;
    }
    createHpBar();
[endscript]

[glink  text="攻撃する" x=400 y=500 target="attack" color="red"]
[glink  text="慰める" x=800 y=500 target="comfort" color="blue"]
[s]
;メッセージウィンドウの設定
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true]

;文字が表示される領域を調整
[position layer=message0 page=fore margint="45" marginl="50" marginr="70" marginb="60"]

*gameover
[cm]
@bg storage="gameover.jpg" 
「あなたは倒れました...」[p]



