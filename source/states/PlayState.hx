package states;

import csHxUtils.CsMath;
import csHxUtils.entities.CsEmitter;
import csHxUtils.entities.SplitText;
import entities.Gem.GemType;
import entities.PlayBoard;
import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import haxe.Timer;
import states.subStates.PauseState;
import utils.GlobalState;
import utils.Loader;

enum Play_State
{
	Idle;
	BoardMatching;
	SpellEffect;
	GameOver;
}

class PlayState extends FlxState
{
	var board:PlayBoard;

	var firstTurn:Bool = true;

	var timer:Float = 0;
	var triggerTime:Float = 1.5;

	var currentState:Play_State = Idle;
	var currentBoardState:BoardState = BoardState.Idle;

	var globalState:GlobalState;

	public function new()
	{
		super();
	}

	override public function create()
	{
		super.create();
		FlxG.mouse.visible = true;
		FlxG.camera.antialiasing = true;

		globalState = FlxG.plugins.get(GlobalState);

		board = new PlayBoard(8, 8); // var rows = 8;
		add(board);

		board.onStateChange = (state) ->
		{
			currentBoardState = state;
			switch (state)
			{
				case BoardState.Idle:
					setState(Idle);
				case BoardState.Swapping:
					setState(Play_State.BoardMatching);
				case BoardState.SwappingRevert:
				case BoardState.PostMatch:
					postMatchUpdateOnce();
				case BoardState.EndTurn:
					// setState(Idle);
				default:
			}
			timer = 0;
		}

		globalState.createEmitter();
		add(globalState.emitter.activeMembers);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (currentState)
		{
			case Play_State.Idle:
				idleUpdate(elapsed);
			case Play_State.GameOver:
				if (FlxG.keys.justPressed.ANY || FlxG.mouse.justPressed)
				{
					FlxG.switchState(new MainMenuState());
				}
			default:
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			this.subState = new PauseState(globalState.controllerId);
			this.subState.create();
			this.subState.closeCallback = () ->
			{
				this.subState = null;
			}
		}
	}

	function setState(state:Play_State)
	{
		var realState = state;
		switch (state)
		{
			case Play_State.Idle:
			case Play_State.BoardMatching:
			case Play_State.SpellEffect:
			case Play_State.GameOver:
		}

		currentState = realState;
	}

	function idleUpdate(elapsed:Float)
	{
		FlxG.log.add("Idle Update");
		var mousePos = FlxG.mouse.getPosition();

		if (FlxG.mouse.justPressed)
		{
			if (board.isPointInside(mousePos))
			{
				board.handleClick(mousePos);
				timer = 0;
			}
		}
	}

	function postMatchUpdateOnce()
	{
		// var sb = isPlayerTurn ? playerSidebar : enemySidebar;

		// var maxLength = 0;
		// for (match in board.activeMatches)
		// {
		// 	maxLength = Std.int(Math.max(maxLength, match.count));

		// 	var manaBonus = Std.int(Math.max(0, match.count - 4)); // adds an extra mana per gem when a match is longer than 4

		// 	for (gemPos in match.pos)
		// 	{
		// 		if (match.manaType == null)
		// 		{
		// 			var enemy = isPlayerTurn ? enemy : globalState.player;

		// 			var healthText = CsMath.centreRect(enemy.sidebar.healthText.getScreenBounds());
		// 			var p = globalState.emitter.emit(gemPos.x, gemPos.y);
		// 			var pSize = FlxPoint.get(1.75, 1.75);
		// 			p.setEffectStates([
		// 				{
		// 					lifespan: () -> FlxG.random.float(0.75, 0.5),
		// 					target: (particle) -> {
		// 						origin: FlxPoint.get(gemPos.x, gemPos.y),
		// 						target: FlxPoint.get(healthText.x, healthText.y),
		// 						easeName: "cubeIn"
		// 					},
		// 					scaleExtended: () -> [
		// 						{t: 0, value: pSize},
		// 						{t: 0.7, value: pSize.scaleNew(0.7)},
		// 						{t: 1, value: pSize.scaleNew(0.1)}
		// 					],
		// 					onComplete: (particle) ->
		// 					{
		// 						if (enemy.health > 0)
		// 						{
		// 							enemy.health.set(enemy.health - 1);
		// 						}
		// 					}
		// 				}
		// 			]);
		// 		}
		// 		else
		// 		{
		// 			sb.addMana(match.manaType, 1 + manaBonus, gemPos);
		// 		}
		// 	}
		// }

		// if (maxLength >= 4)
		// {
		// 	var timeLength = 0.7;
		// 	var perLetter = 0.02;

		// 	isPlayerTurnNext = isPlayerTurn;
		// 	extraTurnText.animateWave(64, perLetter, timeLength, true);
		// 	extraTurnText.animateColour(0xFFFFFFFF, perLetter, timeLength, 0x00ffffff);

		// 	if (maxLength >= 5)
		// 	{
		// 		extraManaText.animateWave(64, perLetter, timeLength, true);
		// 		extraManaText.animateColour(0xFFFFFFFF, perLetter, timeLength, 0x00ffffff);
		// 	}
		// }
	}
}
