package;

import ecx.Family;
import ecx.System;
import openfl.Lib;

class MotionSystem extends System
{
    var _entities:Family<RenderComponent, MotionComponent>;

    public function new() {}

    override public function update() 
    {
        for (entity in _entities) {
            var view = world.edit(entity);
            var render = view.get(RenderComponent);
            var motion = view.get(MotionComponent);

            if (render.tile.x < 0 || render.tile.x > Lib.current.stage.stageWidth) motion.vx *= -1;
            if (render.tile.y < 0 || render.tile.y > Lib.current.stage.stageHeight) motion.vy *= -1;
            render.tile.x += motion.vx;
            render.tile.y += motion.vy;
        }
    }
}