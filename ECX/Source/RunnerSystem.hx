package;

import ecx.System;
import openfl.Lib;
import openfl.events.Event;

class RunnerSystem extends System
{
    public function new() {}

    override function initialize()
    {
        Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    function onEnterFrame(_)
    {
        // Iterating over ACTIVE systems ordered by priority
        for(system in world.systems()) {
            // Call system's update method
            system.update();

            // Update World state (family changes and entities deletion)
            // world.invalidate();
        }
    }
}