package;

import edge.Engine;
import edge.View;
import haxe.ds.Option;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.events.Event;
import openfl.display.FPS;
import thx.Unit;

using thx.ReadonlyArray;

class Main extends Sprite
{
    public function new()
    {
        super();

        addEventListener(Event.ENTER_FRAME, init, false);
    }

    private function init(e:Event)
    {
        removeEventListener(Event.ENTER_FRAME, init, false);

        var engine = Engine.withEnumEnvironment(),
        phase = engine.createPhase();

        phase.addView(View.components(MotionSystem.extract))
          .with(MotionSystem.system);

        var bullet = new Shape();
        bullet.graphics.beginFill(0x000000);
        bullet.graphics.drawCircle(0, 0, 3);
        bullet.graphics.endFill();

        var bounds = bullet.getBounds(bullet);
        var bitmapData = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), true, 0);

        var matrix = new Matrix();
        matrix.translate(-bounds.left, -bounds.top);
        bitmapData.draw(bullet, matrix);

        var tileset = new Tileset(bitmapData);
        tileset.addRect(bitmapData.rect);

        var tilemap = new Tilemap(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, tileset);

        for (i in 0...10000) {
            var tile = new Tile(0);
            tile.x = Math.ceil(Lib.current.stage.stageWidth / 2) + 10;
            tile.y = Math.ceil(Lib.current.stage.stageHeight / 2) + 10;
            tilemap.addTile(tile);

            engine.createEntity([
	        	Motion(new Point((Math.random() * 10) - 5, (Math.random() * 10) - 5)),
	        	Render(tile)
            ]);
        }

        addChild(tilemap);
        addChild(new FPS());
        
        createLoop(phase.update);
    }


    static function createLoop(update: Void -> Void) {
      function loop() {
        update();
        thx.Timer.nextFrame(loop);
      }
      loop();
    }
}

enum Components
{
    Motion(speed:Point);
    Render(tile:Tile);
}


class MotionSystem
{    
    public static function system(list: ReadonlyArray<ItemEntity<{ motion: Point, tile: Tile }, Components, Unit>>)
    {
        for(item in list) {
            var motion = item.data.motion;
            var tile = item.data.tile;
            if (tile.x < 0 || tile.x > Lib.current.stage.stageWidth) motion.x *= -1;
            if (tile.y < 0 || tile.y > Lib.current.stage.stageHeight) motion.y *= -1;
            tile.x += motion.x;
            tile.y += motion.y;
        }
    }

    public static function extract(comps: Iterator<Components>)
    {
        var out = { motion: None, tile: None };
        for(comp in comps) switch comp {
          case Motion(point): out.motion = Some(point);
          case Render(tile): out.tile = Some(tile);
          case _:
        }
        return switch out {
          case { motion: Some(pos), tile: Some(tile) }: Some({ motion: pos, tile: tile });
          case _: None;
        };
    }
}