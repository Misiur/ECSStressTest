package;

import edge.ISystem;
import openfl.Lib;

class MotionSystem implements ISystem
{    
    public function update(motion:MotionComponent, render:RenderComponent)
    {
        if (render.tile.x < 0 || render.tile.x > Lib.current.stage.stageWidth) motion.vx *= -1;
        if (render.tile.y < 0 || render.tile.y > Lib.current.stage.stageHeight) motion.vy *= -1;
        render.tile.x += motion.vx;
        render.tile.y += motion.vy;
    }
}