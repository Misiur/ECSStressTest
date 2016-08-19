package;

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

class Main extends Sprite
{
	private var tiles:Array<Tile> = [];
	private var motions:Array<Point> = [];

    public function new()
    {
        super();

        addEventListener(Event.ENTER_FRAME, init, false);
    }

    private function init(e:Event)
    {
        removeEventListener(Event.ENTER_FRAME, init, false);

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

        for (i in 0...4000) {
            var motion = new Point();
            motion.x = (Math.random() * 10) - 5;
            motion.y = (Math.random() * 10) - 5;
            motions.push(motion);

            var tile = new Tile(0);
            tile.x = Math.ceil(Lib.current.stage.stageWidth / 2) + 10;
            tile.y = Math.ceil(Lib.current.stage.stageHeight / 2) + 10;
            tiles.push(tile);
            tilemap.addTile(tile);
        }

        addChild(tilemap);
        addChild(new FPS());
        addEventListener(Event.ENTER_FRAME, update, false);
    }

    private function update(e:Event)
    {
    	var motion:Point;
    	var tile:Tile;

        for(i in 0...tiles.length)
        {
        	// tile = tiles[i];
        	// motion = motions[i];
        	if (tiles[i].x < 0 || tiles[i].x > Lib.current.stage.stageWidth) motions[i].x *= -1;
            if (tiles[i].y < 0 || tiles[i].y > Lib.current.stage.stageHeight) motions[i].y *= -1;

        	tiles[i].x += motions[i].x;
        	tiles[i].y += motions[i].y;
        }
    }
}