package utils;

import csHxUtils.Observer.FloatObservable;
import csHxUtils.Observer.IntObservable;
import csHxUtils.entities.CsEmitter;
import entities.Gem.ManaType;
import flixel.FlxBasic;
import states.PlayState.Play_State;

var nextState = [Play_State.Idle, Play_State.BoardMatching];

class GlobalState extends FlxBasic
{
	public var isUsingController:Bool = false;
	public var controllerId:Int = 0;
	public var emitter:CsEmitter;

	public function new()
	{
		super();
		emitter = new CsEmitter();
	}

	public function createEmitter()
	{
		emitter = new CsEmitter();
	}
}
