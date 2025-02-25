
*start
[cm]
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=false]
@bg storage="ゲームUI-01-01.png" 

[iscript]


window.startCountdown = function() {
    if (window.countdownStarted) return; // すでに開始済みなら再実行しない
    
    window.countdownStarted = true; // カウントダウン開始フラグ
    window.remainingTime = window.remainingTime || 150; // 既に設定されていればそのまま、なければ30秒

    // カウントダウンのHTML要素を再描画
    $("#countdown").remove();
$(".layer_free").append(`
    <div id="countdown" style="position:absolute; top:30px; left:30px; color:white; font-size:40px;">
        出陣まで <span id="cd_value">` + window.remainingTime + `</span> 秒
    </div>
`);

    // 一定間隔ごとに残り時間を減らす
    window.countdownTimer = setInterval(function() {
        window.remainingTime--;
        $("#cd_value").text(window.remainingTime);

        if (window.remainingTime <= 0) {
            clearInterval(window.countdownTimer);
            window.countdownStarted = false;
            tyrano.plugin.kag.ftag.startTag("jump", {"target":"deploy"});
        }
    }, 1000);
};
[endscript]

[iscript]
tyrano.plugin.kag.setTitle("体力ゲージと攻撃ボタン");

window.charisma_max_hp= 100;
window.charisma_current_hp = 0;
window.charisma_previous_hp = 0
window.miracle_max_hp = 100;
window.miracle_current_hp = 0;
window.miracle_previous_hp = 0;
window.fight_max_hp = 100;
window.fight_current_hp = 0;
window.fight_previous_hp = 0;

window.checkTrainingFailure = function () {
    if (charisma_current_hp - fight_current_hp >= 30) {
        miracle_previous_hp = miracle_current_hp;
        miracle_current_hp = 0;        
        fight_previous_hp = fight_current_hp;
        fight_current_hp = 0;
        charisma_previous_hp = charisma_current_hp;
        charisma_current_hp = 0;
        createHpBar('miracle', miracle_previous_hp, miracle_current_hp, miracle_max_hp);
        createHpBar('fight', fight_previous_hp, fight_current_hp, fight_max_hp);
        createHpBar('charisma', charisma_previous_hp, charisma_current_hp, charisma_max_hp);
        tyrano.plugin.kag.ftag.startTag("jump", {"target": "training_fail"});
    } else {
    $(".layer_free").append('<div id="temp_gif" style="position:absolute; z-index:9999; left: 30%;"><img src="data/fgimage/chara/照れロー.gif" style="width: 58%; top: 40%;" alt="Temporary GIF"/></div>');
    setTimeout(function(){
        $("#temp_gif").remove();
    }, 3000);
    }}

window.checkmiracleFailure = function () {
    if (fight_current_hp - miracle_current_hp >= 20) {
        miracle_previous_hp = miracle_current_hp;
        miracle_current_hp = 0;        
        fight_previous_hp = fight_current_hp;
        fight_current_hp = 0;
        charisma_previous_hp = charisma_current_hp;
        charisma_current_hp = 0;
        createHpBar('miracle', miracle_previous_hp, miracle_current_hp, miracle_max_hp);
        createHpBar('fight', fight_previous_hp, fight_current_hp, fight_max_hp);
        createHpBar('charisma', charisma_previous_hp, charisma_current_hp, charisma_max_hp);
        tyrano.plugin.kag.ftag.startTag("jump", {"target": "fight_fail"});
    } else {
    $(".layer_free").append('<div id="temp_gif1" style="position:absolute; z-index:9999; left: 30%;"><img src="data/fgimage/chara/鍛えロー.gif" style="width: 58%; top: 40%;" alt="Temporary GIF"/></div>');
    setTimeout(function(){
        $("#temp_gif1").remove();
    }, 3000);
    }}

window.checkcharismaFailure = function () {
    if (miracle_current_hp - charisma_current_hp >= 10) {
        miracle_previous_hp = miracle_current_hp;
        miracle_current_hp = 0;        
        fight_previous_hp = fight_current_hp;
        fight_current_hp = 0;
        charisma_previous_hp = charisma_current_hp;
        charisma_current_hp = 0;
        createHpBar('miracle', miracle_previous_hp, miracle_current_hp, miracle_max_hp);
        createHpBar('fight', fight_previous_hp, fight_current_hp, fight_max_hp);
        createHpBar('charisma', charisma_previous_hp, charisma_current_hp, charisma_max_hp);
        tyrano.plugin.kag.ftag.startTag("jump", {"target": "miracle_fail"});
    } else {
    $(".layer_free").append('<div id="temp_gif3" style="position:absolute; z-index:9999; left: 30%;"><img src="data/fgimage/chara/信仰シロー.gif" style="width: 58%; top: 40%;" alt="Temporary GIF"/></div>');
    setTimeout(function(){
        $("#temp_gif3").remove();
    }, 3000);
    }}
window.checktraining = function () {
    if (fight_current_hp == 80 & charisma_current_hp - fight_current_hp >= 10) {
        miracle_previous_hp = miracle_current_hp;
        miracle_current_hp = 0;        
        fight_previous_hp = fight_current_hp;
        fight_current_hp = 0;
        charisma_previous_hp = charisma_current_hp;
        charisma_current_hp = 0;
        createHpBar('miracle', miracle_previous_hp, miracle_current_hp, miracle_max_hp);
        createHpBar('fight', fight_previous_hp, fight_current_hp, fight_max_hp);
        createHpBar('charisma', charisma_previous_hp, charisma_current_hp, charisma_max_hp);
        tyrano.plugin.kag.ftag.startTag("jump", {"target": "all_fail"});
    } }


window.updateHpBar = function (name, previous_hp, current_hp, max_hp, charisma_gage_percentage, miracle_gage_percentage, fight_gage_percentage) {
    const hpPercentage = {};
    hpPercentage[name] = (current_hp / max_hp) * 100;

    // gage_nameを関数スコープ内で定義
    let gage_name = "";
    if (name === "charisma") {
        gage_name = 'カリスマ性';
    } else if (name === "miracle") {
        gage_name = '奇跡';
    } else if (name === "fight") {
        gage_name = '武道';
    } else {
        console.warn("無効な名前が指定されました: " + name);
        return;
    }

    console.log(gage_name);

    // アニメーションでHPバーの幅を変更
    $(`.${name}_gage_bar`).animate(
        { width: hpPercentage[name] + "%" }, 
        {
            duration: 500, // アニメーションの持続時間（ミリ秒）
            easing: "linear", // アニメーションのイージング
            step: function(now, fx) {
                // アニメーション中もHPテキストを更新
                $(`.${name}_gage_text`).text(`${gage_name}: ` + Math.round(now / 100 * max_hp) + "/" + max_hp);
            },
            complete: function() {
                // 完了時に正確なHPテキストを表示
                $(`.${name}_gage_text`).text(`${gage_name}: ` + current_hp + "/" + max_hp);
            }
        }
    );
};

window.initCreateHpBar = function () {
    // 既に体力ゲージが存在していれば削除
     
     var charisma_gage_percentage = 0;
     var miracle_gage_percentage = 0;
     var fight_gage_percentage = 0;

    $(".layer_free").append(`
        <div id="customLayer" style="position: absolute; bottom: 0; left: 0; width: 100%; height: 30%; background: #6d3030; z-index: 999;">
        </div>
                 `);

    $(".layer_free").append(`
        <div class="charisma_gage_container" style="position: absolute; top: 140px; right: 30px; width: 230px; height: 60px; background-color: #fff; border: 2px solid #000; border-radius: 15%;">
            <div class="charisma_gage_bar" style="width: ${charisma_gage_percentage}%; height: 100%; background-color: green;"></div>
        </div>
        <div class="charisma_gage_text" style="position: absolute; top: 160px; right: 60px; font-size: 20px; color: black; font-weight: bold;">${charisma_current_hp}/${charisma_max_hp}</div>
        
        <div class="miracle_gage_container" style="position: absolute; top: 230px; right: 30px; width: 230px; height: 60px; background-color: #fff; border: 2px solid #000; border-radius: 15%;">
            <div class="miracle_gage_bar" style="width: ${miracle_gage_percentage}%; height: 100%; background-color: green;"></div>
        </div>
        <div class="miracle_gage_text" style="position: absolute; top: 250px; right: 60px; font-size: 20px; color: black; font-weight: bold;">${miracle_current_hp}/${miracle_max_hp}</div>
        
        <div class="fight_gage_container" style="position: absolute; top: 320px; right: 30px; width: 230px; height: 60px; background-color: #fff; border: 2px solid #000; border-radius: 15%;">
            <div class="fight_gage_bar" style="width: ${fight_gage_percentage}%; height: 100%; background-color: green;"></div>
        </div>
        <div class="fight_gage_text" style="position: absolute; top: 340px; right: 60px; font-size: 20px; color: black; font-weight: bold;">${fight_current_hp}/${fight_max_hp}</div>
    `);

}


window.createHpBar = function (name,previous_hp,current_hp, max_hp) {
    
     $(`.${name}_hp_container, .${name}_hp_text`).remove();
     var charisma_gage_percentage = (charisma_current_hp / charisma_max_hp) * 100;
     var miracle_gage_percentage = (miracle_current_hp / miracle_max_hp) * 100;
     var fight_gage_percentage = (fight_current_hp / fight_max_hp) * 100;

    
    let gage_percentage;
    if (name === "charisma") {
        charisma_gage_percentage = (previous_hp / max_hp) * 100;
    } else if (name === "miracle") {
        miracle_gage_percentage = (previous_hp / max_hp) * 100;
    } else if (name === "fight") {
        fight_gage_percentage = (previous_hp / max_hp) * 100;
    } else {
        console.warn("無効な名前が指定されました: " + name);
        return;
    }

    // 体力ゲージのHTML要素を追加
    $(".layer_free").append(`
        <div class="charisma_gage_container" style="position: absolute; top: 140px; right: 30px; width: 230px; height: 60px; background-color: #fff; border: 2px solid #000; border-radius: 15%;">
            <div class="charisma_gage_bar" style="width: ${charisma_gage_percentage}%; height: 100%; background-color: green;"></div>
        </div>
        <div class="charisma_gage_text" style="position: absolute; top: 160px; right: 60px; font-size: 20px; color: black; font-weight: bold;">${charisma_current_hp}/${charisma_max_hp}</div>
        
       <div class="miracle_gage_container" style="position: absolute; top: 230px; right: 30px; width: 230px; height: 60px; background-color: #fff; border: 2px solid #000; border-radius: 15%;">
            <div class="miracle_gage_bar" style="width: ${miracle_gage_percentage}%; height: 100%; background-color: green;"></div>
        </div>
        <div class="miracle_gage_text" style="position: absolute; top: 250px; right: 60px; font-size: 20px; color: black; font-weight: bold;">${miracle_current_hp}/${miracle_max_hp}</div>
        
         <div class="fight_gage_container" style="position: absolute; top: 320px; right: 30px; width: 230px; height: 60px; background-color: #fff; border: 2px solid #000; border-radius: 15%;">
            <div class="fight_gage_bar" style="width: ${fight_gage_percentage}%; height: 100%; background-color: green;"></div>
        </div>
        <div class="fight_gage_text" style="position: absolute; top: 340px; right: 60px; font-size: 20px; color: black; font-weight: bold;">${fight_current_hp}/${fight_max_hp}</div>

    `);

    // HPバーの初期状態を設定
    updateHpBar(name,previous_hp,current_hp,max_hp,charisma_gage_percentage,miracle_gage_percentage,fight_gage_percentage);

}


initCreateHpBar();

$("head").append("<style>\
.tyrano-focusable.event-setting-element { transition: transform 0.2s ease; }\
.tyrano-focusable.event-setting-element:hover { transform: scale(1.05); }\
.tyrano-focusable.event-setting-element:active { transform: scale(0.95); }\
</style>");

$(".layer_free").append('<div id="main" style="position:absolute; left: 30%;"><img src="data/fgimage/chara/メイン.gif" style="width: 58%; top: 40%;" alt="Temporary GIF"/></div>');
    setTimeout(function(){
        $("#temp_gif").remove();
    }, 3000);
[endscript]


[eval exp="window.startCountdown()"]

*restart2
[iscript]
$(".message_inner p").remove();
[endscript]
[position layer="message0" left=0 top=400 width=1000 height=200 page=fore visible=false]

*restart
[iscript]
$(".message_inner p").remove();
[endscript]
[eval exp="window.startCountdown()"]
[button graphic="ゲームUI-05.png" width=250 height=150 x=250 y=550 target="flatter" color="red"]
[button graphic="ゲームUI-03.png" width=250 height=150 x=550 y=550 target="believe" color="blue"]
[button graphic="ゲームUI-07.png" width=250 height=150 x=850 y=550 target="fight" color="green"]
[s]




*flatter
[iscript]
    charisma_previous_hp = charisma_current_hp;
    if (charisma_current_hp < 100) {
       charisma_current_hp += 10;
    }
    if (charisma_current_hp < 0) {
        charisma_current_hp= 0;
    }

    if ($('.charisma_gage_bar').length === 0) {
    
    createHpBar('charisma', charisma_previous_hp, charisma_current_hp, charisma_max_hp);
} else {
    updateHpBar('charisma', charisma_previous_hp, charisma_current_hp, charisma_max_hp);
}
checkTrainingFailure();
checktraining();


 
   

[endscript]
[playbgm storage="up.ogg" loop="false"  ]
[wait time="3000" ]
[jump target="restart"]

*believe
[iscript]

miracle_previous_hp = miracle_current_hp;

if (miracle_current_hp < miracle_max_hp) {
    miracle_current_hp += 10;
    if (miracle_current_hp > miracle_max_hp) {
        miracle_current_hp = miracle_max_hp;
    }
}


if ($('.miracle_gage_bar').length === 0) {
   
    createHpBar('miracle', miracle_previous_hp, miracle_current_hp, miracle_max_hp);
} else {
   
    updateHpBar('miracle', miracle_previous_hp, miracle_current_hp, miracle_max_hp);
}
checkcharismaFailure();


[endscript]
[playbgm storage="beliave.ogg" loop="false"  ]
[wait time="3000"]
[jump target="restart"]

*fight
[iscript]

    fight_previous_hp = fight_current_hp
    fight_current_hp += 10;
    if (fight_current_hp > 100) {
       fight_current_hp == 100;
    }
if ($('.fight_gage_bar').length === 0) {
    // ゲージがなければ新規作成
    createHpBar('fight', fight_previous_hp, fight_current_hp, fight_max_hp);
} else {
    // ゲージがあれば更新
    updateHpBar('fight', fight_previous_hp, fight_current_hp, fight_max_hp);
}

checkmiracleFailure();
    

[endscript]
[playbgm storage="training.ogg" loop="false"  ]
[wait time="3000"]
[jump target="restart"]

*training_fail
[playbgm storage="down.ogg" loop="false"  ]
[position layer="message0" left=0 top=400 width=1000 height=200 page=fore visible=true]
「胡散臭いと言われた。」
[wait time="2000" ]
[jump target="restart2"]

*fight_fail
[playbgm storage="down.ogg" loop="false"  ]
[position layer="message0" left=0 top=400 width=1000 height=200 page=fore visible=true]
「筋を痛めた。」
[wait time="2000" ]
[jump target="restart2"]

*miracle_fail
[playbgm storage="down.ogg" loop="false"  ]
[position layer="message0" left=0 top=400 width=1000 height=200 page=fore visible=true]
「神に見放された。」
[wait time="2000" ]
[jump target="restart2"]

*all_fail
[position layer="message0" left=0 top=400 width=1000 height=200 page=fore visible=true]
「石を投げつけられた。」
[wait time="2000" ]
[jump target="restart2"]




*deploy
[iscript]
    // 各HPの比較
    if (charisma_current_hp == charisma_max_hp && miracle_current_hp == miracle_max_hp && fight_current_hp == fight_max_hp) {
        tyrano.plugin.kag.ftag.startTag("jump", {"target": "win"});
    } else {
        tyrano.plugin.kag.ftag.startTag("jump", {"target": "lose"});
    }
[endscript]

*win
[cm]
@bg storage="win.jpg"
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true]
「シローマンは軍を率い、無事幕府の軍を一致団結し、追い払った！」[p]
@jump target="start"


*lose
[cm]
@bg storage="lose.jpg"
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true]
「力及ばず、シローマン敗北」[p]



*gameover
[cm]
@bg storage="gameover.jpg"

;メッセージウィンドウの設定
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true]

「シローマン永眠」[p]



